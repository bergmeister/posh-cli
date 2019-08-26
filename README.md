# posh-cli [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![posh-cli](https://img.shields.io/powershellgallery/v/posh-cli.svg?style=flat-square&label=posh-cli)](https://www.powershellgallery.com/packages/posh-cli/)

[![Build Status](https://dev.azure.com/christophbergmeister/posh-cli/_apis/build/status/bergmeister.posh-cli?branchName=master)](https://dev.azure.com/christophbergmeister/posh-cli/_build/latest?definitionId=41&branchName=master)

A meta module to bootstrap CLI tab completion PowerShell modules.

## Usage

```pwsh
Install-Module -Name posh-cli -Repository PSGallery
Install-TabCompletion
```

Install the `posh-cli` module and calling `Install-TabCompletion` installs required modules that tab completion to the CLIs available on your system. It also imports the module so that you can start using it and adds such a call to your PowerShell $PROFILE as well.

You can call the `Install-TabCompletion` cmdlet also to update those modules at a later time. The list of modules is stored remotely in the [cli-modules-v1.json](./source/cli-modules-v1.json) file, therefore you should not need to update `posh-cli` itself unless new capabilities become available that you want to use. Only non-breaking changes will be made to this JSON file.

## Overview

The module analyses the installed CLIs and installs modules from the PSGallery that help with the tab completion. It automatically executes and adds the necessary calls for initialisation of the installed tab completion modules to your `$PROFILE`.

Currently it is aware of the following modules.

| CLI    | PowerShell tab completion module                                                      | Remarks                         |
| ------ | ------------------------------------------------------------------------------------- | ------------------------------- |
| cargo  | [posh-cargo](https://www.powershellgallery.com/packages/posh-cargo)                   |                                 |
| dcos   | [posh-dcos](https://www.powershellgallery.com/packages/posh-dcos)                     |                                 |
| dotnet | [posh-dotnet](https://www.powershellgallery.com/packages/posh-dotnet)                 |                                 |
| docker | [DockerCompletion](https://www.powershellgallery.com/packages/DockerCompletion)       |                                 |
| git    | [posh-git](https://www.powershellgallery.com/packages/posh-git)                       |                                 |
| mvn    | [MavenAutoCompletion](https://www.powershellgallery.com/packages/MavenAutoCompletion) | Minimum PowerShell Version: 6.0 |
| npm    | [npm-completion](https://www.powershellgallery.com/packages/npm-completion)           |                                 |
| scoop  | [scoop-completion](https://www.powershellgallery.com/packages/scoop-completion)       |                                 |
| vsts   | [posh-vsts-cli](https://www.powershellgallery.com/packages/posh-vsts-cli)             |                                 |
| yarn   | [yarn-completion](https://www.powershellgallery.com/packages/yarn-completion)         |                                 |

Should new modules be added to the list, then just calling `Install-TabCompletion` is sufficient as the list is stored remotely and does not require an update of `posh-cli` itself.
