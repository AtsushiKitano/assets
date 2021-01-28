package functions

import (
    "os"
    "context"
    "strings"

    "google.golang.org/api/compute/v1"
)

func stopGCE(gce *compute.Instance,ctx context.Context) error {
    t := strings.Split(gce.Zone, "/")
    zone := t[len(t)-1]
    isa, err := getInstanceService(ctx)

    if err != nil {
        return err
    }


    if gce.Status == "RUNNING" {
        _, err := isa.Stop(os.Getenv("GCP_PROJECT"), zone, gce.Name).Do()
        return err
    }

    return nil
}
