package functions

import (
    "os"
    "context"

    "google.golang.org/api/compute/v1"
)

func getInstances(ctx context.Context) ([]*compute.Instance, error){
    var gces []*compute.Instance
    zones, err := getZones(ctx)

    if err != nil {
        return gces, err
    }

    isv , err := getInstanceService(ctx)

    if err != nil {
        return gces, err
    }

    for _,z := range zones {
        instances, err := isv.List(os.Getenv("GCP_PROJECT"),z).Do()
        if err != nil {
            return gces, err
        }

        for _,i := range instances.Items{
            gces = append(gces, i)
        }
    }

    return gces, nil
}
