package sdk

import (
    "testing"
    "fmt"
    "os"

    network "../../../../../../iaas/sdk/gcp/golang/testingtool/network"
)

func TestExistTestNetwork(t *testing.T){
    actual, err := network.ContainVPCNetwork("test")
    expected := true

    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }

    if actual != expected {
        t.Errorf("got: %v\nwant: %v", actual, expected)
    }
}

func TestTestSubnetworkCidr(t *testing.T){
    actual, err := network.GetCidr("test", "asia-northeast1")
    expected := "192.168.0.0/29"

    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }

    if actual != expected {
        t.Errorf("got: %v\nwant: %v", actual, expected)
    }
}
