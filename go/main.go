package main

import (
	"encoding/json"
	"net/http"
)

type ResponseBody struct {
	Message string `json:"message"`
}

func main() {
	http.HandleFunc("/", func(rw http.ResponseWriter, r *http.Request) {
		rw.Header().Set("Content-Type", "application/json")
		if r.Method == http.MethodGet && r.URL.Path == "/" {
			jsonBytes, _ := json.Marshal(ResponseBody{"Hello World!"})
			rw.WriteHeader(http.StatusOK)
			rw.Write(jsonBytes)
		} else {
			jsonBytes, _ := json.Marshal(ResponseBody{"Not Found!"})
			rw.WriteHeader(http.StatusNotFound)
			rw.Write(jsonBytes)
		}
	})
	http.ListenAndServe(":9090", nil)
}
