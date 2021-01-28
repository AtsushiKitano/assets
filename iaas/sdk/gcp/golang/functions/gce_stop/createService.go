package functions

import (
    "context"

    "google.golang.org/api/compute/v1"
)

func createSv(ctx context.Context) (*compute.Service, error){
    return compute.NewService(ctx)
}

func getInstanceService(ctx context.Context) (*compute.InstancesService, error) {
    sv, err := createSv(ctx)
    return compute.NewInstancesService(sv), err
}
