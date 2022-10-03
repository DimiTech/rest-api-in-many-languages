# REST API in many different languages

Requirements:
- GNU Make
- cURL

`run-tests.sh` - is a small Bash testing framework which runs all the test
scripts it finds in `./test` directory, whose filename starts with `test-`.

## Run tests
```
make test
```

## Go

Requirements:
- Install `golang`

Run the API:
```
make go
```
