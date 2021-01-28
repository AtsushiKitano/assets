package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformGcpHelloWorldExample(t *testing.T) {
	t.Parallel()


	terraformOptions := &terraform.Options{
		TerraformDir: ".",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

    instanceName := terraform.Output(t, terraformOptions, "gce_name")

    assert.Equal(t, "test", instanceName)
}
