package network

import(
	"os"

    "google.golang.org/api/compute/v1"
)

func getFirewallSV() (*compute.FirewallsService, error){
    sv, err := getService()
    if err != nil {
        return nil, err
    }
    return compute.NewFirewallsService(sv), err
}

func getFirewallLists() (*compute.FirewallList, error){
    fws, err := getFirewallSV()
    if err != nil{
        return nil, err
    }
    return fws.List(os.Getenv("GCP_PROJECT")).Do()
}

func getFirewallNameList() ([]string, error) {
    var nameList []string

    fwl, err := getFirewallLists()
    if err != nil {
        return nil, err
    }

    for _, l := range fwl.Items {
        nameList = append(nameList, l.Name)
    }

    return nameList, err
}

func getFirewall(firewallName string) (*compute.Firewall, error){
    sv, err := getFirewallSV()
    if err != nil {
        return nil, err
    }
    return sv.Get(os.Getenv("GCP_PROJECT"), firewallName).Do()
}

func ContainFirewall(firewallName string) (bool, error) {
    fwl, err := getFirewallNameList()
    if err != nil {
        return false, err
    }

    for  _, f := range fwl {
        if f == firewallName {
            return true, err
        }
    }
    return false, err
}

func AllowedRules(firewallName string) ([]*compute.FirewallAllowed, error) {
    fw, err := getFirewall(firewallName)
    if err != nil{
        return nil, err
    }
    return fw.Allowed, err
}
