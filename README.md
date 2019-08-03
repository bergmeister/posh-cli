# posh-cli

A meta module to bootstrap CLI tab completion PowerShell modules.

# Usage

This is an early prototype with some manual setup action like adding the correct `Import-Module` calls to your `$PROFILE`. At the moment, it analyses the CLIs that you have installed and installs modules from the PSGallery that help with the tab completion.

```pwsh
Install-Module -Name posh-cli -Repository PSGallery
Install-TabCompletion
# Add Import-Module calls to your $PROFILE
```

It will look at which CLIs are available and if any of the following are available, then the corresponding PowerShell tab completion module is installed from the PSGallery.

| CLI        | PowerShell tab completion module |
| ---------- | ---------------------------------|
| cargo      | posh-cargo                       |
| dcos       | posh-dcos                        |
| dotnet     | posh-dotnet                      |
| docker     | posh-docker                      |
| git        | posh-git                         |
| mvn        | MavenAutoCompletion              |
| npm        | npm-completion                   |
| scoop      | scoop-completion                 |
| vsts       | posh-vsts-cli                    |
| yarn       | yarn-completion                  |
