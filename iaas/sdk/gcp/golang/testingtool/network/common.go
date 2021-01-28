package network

import(
    "context"

    "google.golang.org/api/compute/v1"
)

func getService() (*compute.Service, error) {
    ctx := context.Background()
    return compute.NewService(ctx)
}
