package test

import(
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformHelloWorldExample(t *testing.T) {
    terraformOptions := &terraform.Options {
        TerraformDir: "./",
    }

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    output := terraform.Output(t, terraformOptions, "hello_world")
    assert.Equal(t, "Hello, World!", output)
}
