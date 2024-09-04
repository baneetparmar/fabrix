{ pkgs, ... }:
{
  projectRootFile = ".git/config";
  programs.nixfmt.enable = true;
  programs.ruff.enable = true;
  settings.formatter.ruff = {
    command = "${pkgs.ruff}/bin/ruff";
    includes = [ "*.py" ];
    options = [ "format" ];
  };
}
