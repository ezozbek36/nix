{...}: {
  nix = {
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
    };
    buildMachines = [
      {
        maxJobs = 100;
        protocol = "ssh-ng";
        system = "x86_64-linux";
        hostName = "eu.nixbuild.net";
        supportedFeatures = ["benchmark" "big-parallel"];
      }
    ];
  };
}
