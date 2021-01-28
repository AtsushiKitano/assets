package main


import (
        "fmt"
        "log"

        "golang.org/x/net/context"
        "golang.org/x/oauth2/google"
        "google.golang.org/api/iam/v1"
)

func main() {
        ctx := context.Background()

        c, err := google.DefaultClient(ctx, iam.CloudPlatformScope)
        if err != nil {
                log.Fatal(err)
        }

        iamService, err := iam.New(c)
        if err != nil {
                log.Fatal(err)
        }

    name := "projects/ca-kitano-study-sandbox/serviceAccounts/test-golang-keyget@ca-kitano-study-sandbox.iam.gserviceaccount.com/keys/mykey"

        resp, err := iamService.Projects.ServiceAccounts.Keys.Get(name).Context(ctx).Do()
        if err != nil {
                log.Fatal(err)
        }

        // TODO: Change code below to process the `resp` object:
        fmt.Printf("%#v\n", resp)
}
