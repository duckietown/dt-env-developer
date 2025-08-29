#!/bin/bash

# protect-branches.sh
# Enforce branch protection rules on all repos listed in .mrconfig files
# Usage: ./protect-branches.sh [--dry-run]
# Requires: gh CLI (authenticated), jq


DRY_RUN=false
COPY_WORKFLOW=false
WORKFLOW_SOURCE=".github/workflows/jira-pr-check.yml"

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            echo "[DRY RUN] No changes will be made."
            ;;
        --copy-workflow)
            COPY_WORKFLOW=true
            echo "[COPY WORKFLOW] Will copy workflow file to repos missing it."
            ;;
        --workflow-source=*)
            WORKFLOW_SOURCE="${arg#*=}"
            ;;
    esac
done

# Extract repo and branch from .mrconfig, collect warnings
extract_repo_and_branch() {
    local mrconfig_file="$1"
    grep "checkout = git clone" "$mrconfig_file" | while read -r line; do
        branch=$(echo "$line" | sed -nE "/-b/ s/.*-b[ ]*'([^']+)'.*/\1/p")
        repo=$(echo "$line" | grep -oE "git@github.com:[^']+")
        repo_name=$(echo "$repo" | sed -E "s|git@github.com:([^']+)(\\.git)?|\\1|")
        if [[ -z "$branch" ]]; then
            echo "$repo_name|$line" >> "$WARNINGS_FILE"
            continue
        fi
        echo "$repo_name $branch"
    done
}

# Temp file to collect warnings
WARNINGS_FILE=$(mktemp)
trap 'rm -f "$WARNINGS_FILE"' EXIT

find . -type f -name ".mrconfig" | while read -r mrconfig; do
    echo "Processing $mrconfig"
    extract_repo_and_branch "$mrconfig" | while read -r repo branch; do
        echo "Checking for jira-pr-check.yml in $repo ($branch)"
        # Check if the workflow file exists in the branch
        if gh api "repos/$repo/contents/.github/workflows/jira-pr-check.yml?ref=$branch" --silent > /dev/null 2>&1; then
            echo "Setting protection for $repo ($branch)"
            if ! $DRY_RUN; then
                gh api \
                  -X PUT \
                  "repos/$repo/branches/$branch/protection" \
                  -F required_status_checks='{"strict":true,"contexts":["jira-pr-check"]}' \
                  -F enforce_admins=true \
                  -F required_pull_request_reviews='{"required_approving_review_count":1}' \
                  -F restrictions='null'
            fi
        else
            echo "[WARNING] $repo ($branch) does not have .github/workflows/jira-pr-check.yml" >&2
            echo "$repo|$branch|missing_workflow" >> "$WARNINGS_FILE"
            if $COPY_WORKFLOW && [ -f "$WORKFLOW_SOURCE" ]; then
                echo "Copying workflow file to $repo ($branch)"
                if ! $DRY_RUN; then
                    # Get the file content base64 encoded
                    CONTENT_B64=$(base64 -w 0 "$WORKFLOW_SOURCE")
                    gh api \
                      -X PUT \
                      "repos/$repo/contents/.github/workflows/jira-pr-check.yml" \
                      -F message="Add jira-pr-check workflow" \
                      -F content="$CONTENT_B64" \
                      -F branch="$branch" \
                      --silent
                else
                    echo "[DRY RUN] Would copy $WORKFLOW_SOURCE to $repo ($branch)"
                fi
            fi
        fi
    done
    echo
done

# Print all warnings at the end
if [[ -s "$WARNINGS_FILE" ]]; then
    echo "[WARNINGS] The following repos/branches had issues:" >&2
    while IFS='|' read -r repo_name branch extra; do
        if [[ "$extra" == "missing_workflow" ]]; then
            echo "  Repo: $repo_name | Branch: $branch | Missing jira-pr-check.yml" >&2
        else
            echo "  Repo: $repo_name | Line: $branch" >&2
        fi
    done < "$WARNINGS_FILE"
else
    echo "\nNo missing branch or workflow warnings."
fi
echo "Branch protection rules script completed."
