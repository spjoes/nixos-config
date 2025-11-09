# Joey's NixOS Config

## What is this repository?
These are the configuration files for my NixOS setup(s).

## Install
1)
```
git clone https://git.aserver.online/Joey/nixos-config.git ~/.dotfiles
```

2)
```
sudo nixos-rebuild switch --flake ~/.dotfiles/#[host]
```
> Note: "[host]" here should be replaced with any defined host (currently "vm" and "alaska")