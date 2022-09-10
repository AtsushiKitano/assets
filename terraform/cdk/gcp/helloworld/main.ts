import { Construct } from "constructs";
import { App, TerraformStack } from "cdktf";
import {ComputeNetwork,GoogleProvider} from "./.gen/providers/google"

interface MyStackConfig {
  name: string;
}

class MyStack extends TerraformStack {
  constructor(scope: Construct, id: string, config: MyStackConfig) {
    super(scope, id);

    new GoogleProvider(this, "google", {});
    
    new ComputeNetwork(this, "vpcResarch", {
      name: config.name,
      project: process.env.TF_VAR_default_project,
    });
  }
}

const app = new App();
new MyStack(app, "test1", { name: "test1"});
new MyStack(app, "test2", { name: "test2"});
app.synth();
