package network

import (
	"context"
	"fmt"
	"os"

	"google.golang.org/api/compute/v1"
)

type SubnetworkInfo struct {
	Name                  string
	Cidr                  string
	Selflink              string
	GatewayAddress        string
	Kind                  string
	Network               string
	PrivateIpGoogleAccess bool
	Region                string
	Role                  string
	State                 string
}

func GetSubnetworkList(region string) (*compute.SubnetworkList, error) {
	ctx := context.Background()
	cps, err := compute.NewService(ctx)
	if err != nil {
		return nil, err
	}
	sns := compute.NewSubnetworksService(cps)
	return sns.List(os.Getenv("GCP_PROJECT"), region).Do()
}

func GetSubnetworkInfo(region string) ([]SubnetworkInfo, error) {
	var subnetInfos []SubnetworkInfo
	snsl, err := GetSubnetworkList(region)
	if err != nil {
		return nil, err
	}
	for _, s := range snsl.Items {
		var info SubnetworkInfo
		info.Name = s.Name
		info.Cidr = s.IpCidrRange
		info.Selflink = s.SelfLink
		info.GatewayAddress = s.GatewayAddress
		info.Kind = s.Kind
		info.PrivateIpGoogleAccess = s.PrivateIpGoogleAccess
		info.Region = s.Region
		info.State = s.State
		subnetInfos = append(subnetInfos, info)
	}
	return subnetInfos, err
}

func ContainSubnetWork(subnetwork string, region string) bool {
	subnetworkList, err := GetSubnetworkInfo(region)

	if err != nil {
		fmt.Println(err)
	}

	for _, s := range subnetworkList {
		if s.Name == subnetwork {
			return true
		}
	}
	return false
}

func GetSubnetInfo(subnetwork string, region string) (*compute.Subnetwork, error){
    ctx := context.Background()
	cps, err := compute.NewService(ctx)
	if err != nil {
		return nil, err
	}
	return compute.NewSubnetworksService(cps).Get(os.Getenv("GCP_PROJECT"), region,subnetwork).Do()
}

func GetCidr(subnetwork string, region string) (string, error) {
    snet, err := GetSubnetInfo(subnetwork, region)
    if err != nil {
        return "" , err
    }
    return snet.IpCidrRange, err
}

func GetSelflink(subnetwork string, region string) (string, error) {
    snet, err := GetSubnetInfo(subnetwork, region)
    if err != nil {
        return "" , err
    }
    return snet.SelfLink, err
}
