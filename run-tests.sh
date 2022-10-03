#!/bin/bash

# -----------------------------------------------------------------------------
# Terminal Setup
# -----------------------------------------------------------------------------

COLOR_RED=`tput setaf 1`
COLOR_GREEN=`tput setaf 2`
COLOR_GREY=`tput setaf 8`
COLOR_CLEAR=`tput sgr0`

function echoGreen() {
  echoInColor "$1" "$COLOR_GREEN"
}
function echoRed() {
  echoInColor "$1" "$COLOR_RED"
}
function echoInColor() {
  MESSAGE=$1
  COLOR=$2
  echo ${COLOR}${MESSAGE}${COLOR_CLEAR}
}
function echoExpectedAndActual() {
  echo "Expected : ${COLOR_GREEN}${1}${COLOR_CLEAR}"
  echo "Actual   : ${COLOR_RED}${2}${COLOR_CLEAR}"
}

# -----------------------------------------------------------------------------
# Assertion Functions
# -----------------------------------------------------------------------------

function assert() {
  ACTUAL=$1
  EXPECTED=$2

  if [ "${ACTUAL}" == "${EXPECTED}" ]; then
    return 0
  else

    local MESSAGE
    for FUNC in ${FUNCNAME[@]}; do
      if [[ ${FUNC} =~ ^it.+ ]]; then
        MESSAGE=$FUNC
        break
      fi
    done

    echoRed "  ✗ ${MESSAGE}"
    echoExpectedAndActual "$EXPECTED" "$ACTUAL"
    exit 1
  fi
}

function assertStatusCode() {
  API_URL=$1
  API_PATH=$2
  EXPECTED_STATUS_CODE=$3
  STATUS_CODE=$(curl -X GET -o /dev/null -s -w "%{http_code}" "${API_URL}${API_PATH}")
  assert "${STATUS_CODE}" "${EXPECTED_STATUS_CODE}"
}

function assertResponseBody() {
  API_URL=$1
  API_PATH=$2
  EXPECTED_RESPONSE_JSON=$3
  RESPONSE_JSON=$(curl -X GET -s "${API_URL}${API_PATH}")
  assert "${RESPONSE_JSON}" "${EXPECTED_RESPONSE_JSON}"
}

# -----------------------------------------------------------------------------
# Find & Run Test Scripts
# -----------------------------------------------------------------------------

echo # Newline

TEST_DIR='./test'

# Find all files whose filenames start with 'test-'
find $TEST_DIR -name 'test-*' | while read -r TEST_SCRIPT; do
  echo ${COLOR_GREY}${TEST_SCRIPT}${COLOR_CLEAR}
  echo

  source $TEST_SCRIPT

  # Run functions whose name starts with `it` (test functions)
  TEST_FUNCTION_NAMES=$(
    cat $TEST_SCRIPT |
      grep -e '^function it.*'   | # Grep for lines starting with 'function it'
      grep -v grep               | # Exclude the 'grep command'
      grep -o -e 'it\w*'           # Extract only the function name
  )
  for TEST_FUNCTION in $TEST_FUNCTION_NAMES; do
    eval $TEST_FUNCTION
    echoGreen "  ✓ ${TEST_FUNCTION}"
  done

  echo # Newline
  exit 0
done
