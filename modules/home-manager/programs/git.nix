{...}: {
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
      };
    };
  };
}
