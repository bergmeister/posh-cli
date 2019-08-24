# posh-cli [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![posh-cli](https://img.shields.io/powershellgallery/v/posh-cli.svg?style=flat-square&label=posh-cli)](https://www.powershellgallery.com/packages/posh-cli/)

[![Build Status](https://dev.azure.com/christophbergmeister/posh-cli/_apis/build/status/bergmeister.posh-cli?branchName=master)](https://dev.azure.com/christophbergmeister/posh-cli/_build/latest?definitionId=41&branchName=master)

A meta module to bootstrap CLI tab completion PowerShell modules.

# Usage

This is an early prototype with some manual setup action like adding the correct `Import-Module` calls to your `$PROFILE`. At the moment, it analyses the CLIs that you have installed and installs modules from the PSGallery that help with the tab completion.

```pwsh
Install-Module -Name posh-cli -Repository PSGallery
Install-TabCompletion
# Add Import-Module calls to your $PROFILE
```

It will look at which CLIs are available and if any of the following are available, then the corresponding PowerShell tab completion module is installed from the PSGallery.

| CLI    | PowerShell tab completion module                                                      |
| ------ | ------------------------------------------------------------------------------------- |
| cargo  | [posh-cargo](https://www.powershellgallery.com/packages/posh-cargo)                   |
| dcos   | [posh-dcos](https://www.powershellgallery.com/packages/posh-dcos)                     |
| dotnet | [posh-dotnet](https://www.powershellgallery.com/packages/posh-dotnet)                 |
| docker | [posh-docker](https://www.powershellgallery.com/packages/posh-docker)                 |
| git    | [posh-git](https://www.powershellgallery.com/packages/posh-git)                       |
| mvn    | [MavenAutoCompletion](https://www.powershellgallery.com/packages/MavenAutoCompletion) |
| npm    | [npm-completion](https://www.powershellgallery.com/packages/npm-completion)           |
| scoop  | [scoop-completion](https://www.powershellgallery.com/packages/scoop-completion)       |
| vsts   | [posh-vsts-cli](https://www.powershellgallery.com/packages/posh-vsts-cli)             |
| yarn   | [yarn-completion](https://www.powershellgallery.com/packages/yarn-completion)         |
