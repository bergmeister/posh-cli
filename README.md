# posh-cli

A meta module to bootstrap CLI tab completion PowerShell modules.

# Usage

This is an early prototype with some manual setup action like adding the correct `Import-Module` calls to your `$PROFILE`. At the moment, it analyses the CLIs that you have installed and installs modules from the PSGallery that help with the tab completion.

```pwsh
git clone https://github.com/bergmeister/posh-cli
cd posh-cli
Import-Module .\source\posh-cli.psd1
Install-TabCompletion
# Add Import-Module calls to your $PROFILE
```
