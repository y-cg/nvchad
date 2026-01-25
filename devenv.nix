{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
  ];

  scripts.nvim.exec = ''
    NVIM_APPNAME=nvchad-dev                                   \
    XDG_DATA_HOME=${config.devenv.dotfile}/state/nvim/data    \
    XDG_STATE_HOME=${config.devenv.dotfile}/state/nvim/state  \
    XDG_CACHE_HOME=${config.devenv.dotfile}/state/nvim/cache  \
    ${pkgs.neovim}/bin/nvim "$@"
  '';

  # https://devenv.sh/languages/
  languages.lua.enable = true;

  # https://devenv.sh/basics/
  enterShell = ''
    ${pkgs.neovim}/bin/nvim --version
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    hooks = {
      stylua.enable = true;
    };
    package = pkgs.prek;
  };

  # See full reference at https://devenv.sh/reference/options/
}
