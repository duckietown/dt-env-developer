#!/bin/bash
set -e

dts challenges define --config challenge-aido1_luck/challenge.yaml
dts challenges define --config challenge-aido1_log_processing/challenge.yaml
dts challenges define --config challenge-aido1_dummy_sim/challenge.yaml

(cd challenge-aido1_luck/submission-random; dts challenges submit)
(cd challenge-aido1_log_processing/submission; dts challenges submit)
(cd challenge-aido1_dummy_sim/submission; dts challenges submit)
