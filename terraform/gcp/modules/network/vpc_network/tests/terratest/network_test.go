package terratest
import (
    "testing"
    "os"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type Firewall struct {
    Name string
    Direction string
    Tags []string
    priority int
    LogConfigMeta string
}

type Rule struct {
    Type string
    Protocol string
    ports string
}

func TestNetwork(t *testing.T) {
	t.Parallel()

    expectedVPCNetworkName := "test"
    expectedSubnetworkNames := []string{"test-tokyo", "test-osaka"}
    expectedFirewallNames := []string{"test-ingress","test-egress"}
    expectedIngressFirewall := Firewall{
        Name: "test-ingress",
        Direction: "INGRESS",
        Tags: []string{"test"},
        LogConfigMeta: "EXCLUDE_ALL_METADATA",
    }

	terraformOptions := &terraform.Options{
		TerraformDir: "../cases/network",
	}

	defer terraform.Destroy(t, terraformOptions)
    
    terraform.WorkspaceSelectOrNew(t, terraformOptions, os.Getenv("GCP_PROJECT"))
	terraform.InitAndApply(t, terraformOptions)

	testNetworkName := deleteQuotation(terraform.Output(t, terraformOptions, "test"))
    testSubnetsName := terraform.OutputList(t, terraformOptions, "subnet")
    testFirewallName := terraform.OutputList(t, terraformOptions, "fw_name")
    testIngressFWDirection := deleteQuotation(terraform.Output(t,terraformOptions, "input_fw_direction"))
    testIngressFWTargetTags := terraform.OutputList(t, terraformOptions, "input_fw_target_tags")

	assert.Equal(t, expectedVPCNetworkName, testNetworkName)
    assert.Equal(t, expectedSubnetworkNames, testSubnetsName)
    assert.Equal(t, expectedFirewallNames, testFirewallName)
    assert.Equal(t, expectedIngressFirewall.Direction, testIngressFWDirection)
    assert.Equal(t, expectedIngressFirewall.Tags, testIngressFWTargetTags)
}

func deleteQuotation(config string) string {
    return config[1: len(config)-1]
}
