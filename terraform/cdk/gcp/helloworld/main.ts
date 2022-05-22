import { Construct } from "constructs";
import { App, TerraformStack } from "cdktf";
import {ComputeNetwork,GoogleProvider} from "@cdktf/provider-google"

class MyStack extends TerraformStack {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    new GoogleProvider(this, "google", {});
    
    new ComputeNetwork(this, "vpcResarch", {
      name: "sample123",
      project: process.env.TF_VAR_default_project,
    });
  }
}

const app = new App();
new MyStack(app, "helloworld");
app.synth();
