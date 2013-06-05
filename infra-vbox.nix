{
  builder =
    { deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024;
    };
  host =
    { deployment.targetEnv = "virtualbox";
      deployment.virtualbox.memorySize = 1024;
    };
}
