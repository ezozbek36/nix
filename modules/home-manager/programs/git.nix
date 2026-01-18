{...}: {
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
    settings = {
      user = {
        name = "Ezozbek";
        email = "git@ezozbek.dev";
      };
    };
  };
}
