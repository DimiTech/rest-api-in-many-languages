#!/bin/bash

API_URL='http://localhost:9090'
API_PATH='/'

echo "GET ${API_PATH}"

function itReturnsHTTPStatusCode200() {
  assertStatusCode $API_URL $API_PATH '200'
  assertStatusCode $API_URL $API_PATH '200'
}

function itReturnsHelloWorldMessageInResponseBody() {
  assertResponseBody $API_URL $API_PATH '{"message":"Hello World!"}'
}

function itReturnsNotFoundForNonexistentPaths() {
  local NONEXISTENT_PATH='/nonexistent'
  assertStatusCode $API_URL $NONEXISTENT_PATH '404'
  assertResponseBody $API_URL $NONEXISTENT_PATH '{"message":"Not Found!"}'
}
