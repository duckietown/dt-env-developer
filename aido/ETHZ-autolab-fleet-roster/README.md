## Usage:
This folder contains all the history of compliance and suitability test for autolab agents (autobots and watchtowers mainly).
Every time someone remakes one of those tests, it needs to be *added to the corresponding folder and pushed*, as it will be used by autolab operators to determine which agents are compliant and most up to date.

## Important:
Structure is the following (as for autobot02 right now):
- autobots
    - autobotXX
        - camera-verification
            - yyyy-mm-dd-hh-mm_camera-verification
                - lots of stuff
                - ...
                - camera_test_report.yaml
        - hardware-compliance
            - yyyy-mm-dd_hardware-compliance
                - yyyy-mm-dd_hardware-compliance.yaml
        - system-identification
            - yyyy-mm-dd-hh-mm_system-identification
                - lots of stuff
                - ...
                - report.yaml
    - autobotYY
        - ....
        ...
        ...


## Hardware Compliance: 
to run the hardware compliance test, follow the instructions here: https://ethidsc.atlassian.net/wiki/spaces/ARE/pages/80674836/Suitability+Test+HW+compliance
