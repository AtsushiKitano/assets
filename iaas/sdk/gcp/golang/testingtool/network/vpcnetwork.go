package network

import(
	"os"
    "context"

    "google.golang.org/api/compute/v1"
)

func GetVPCNetwork() ([]string, error){
    var networkNameList []string

    ctx := context.Background()
    cps, err := compute.NewService(ctx)
    if err != nil {
        return networkNameList, err
    }
    nws := compute.NewNetworksService(cps)
    networkList , err := nws.List(os.Getenv("GCP_PROJECT")).Do()
    if err != nil {
        return networkNameList, err
    }

    for _ , n := range networkList.Items {
        networkNameList = append(networkNameList, n.Name)
    }
    return networkNameList, nil
}

func ContainVPCNetwork(network string) (bool, error) {
    networkList, err := GetVPCNetwork()

    if err != nil {
        return false , err
    }

    for _, n := range networkList {
        if n == network {
            return true, err
        }
    }
    return false, err
}
