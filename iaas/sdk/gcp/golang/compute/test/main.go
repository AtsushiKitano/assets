package main

import (
	"fmt"
	"os"
    "context"

    orcom "../gce"
)

func main() {
    ctx := context.Background()
    err := orcom.StopAllGCEs(ctx)
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
}
