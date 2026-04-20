{...}: {
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        maxJobs = 100;
        system = "x86_64-linux";
        hostName = "eu.nixbuild.net";
        supportedFeatures = ["benchmark" "big-parallel"];
      }
    ];
  };
}
