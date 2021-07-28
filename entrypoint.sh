#!/bin/sh

# cd or fail
cd "$GITHUB_WORKSPACE" || exit 1

if [ "$INPUT_FAIL_ON_ERROR" = true ] ; then
  set -o pipefail
fi

set -x
ls $PWD

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

java -jar /opt/detekt.jar --fail-fast --config "${INPUT_DETEKT_CONFIG}" \
  --report xml:detekt_report.xml \
  --baseline "${INPUT_DETEKT_BASELINE}" \
  --excludes "${INPUT_DETEKT_EXCLUDES}" \
  --plugins /opt/detekt-formatting.jar

reviewdog -f=checkstyle -name="detekt" -reporter="${INPUT_REVIEWDOG_REPORTER}" \
  -level="${INPUT_REVIEWDOG_LEVEL}" -filter-mode="${INPUT_REVIEWDOG_FILTER}" <detekt_report.xml
  