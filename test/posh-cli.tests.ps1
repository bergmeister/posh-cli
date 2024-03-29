Describe "Install-TabCompletion" {
    BeforeAll {
        Import-Module (Join-Path  $PSScriptRoot ..\source\posh-cli\posh-cli.psm1)
        if (Get-Module posh-git -ListAvailable) {
            $uninstalledPoshGit = $true
            Uninstall-Module posh-git
        }
    }

    AfterAll {
        Remove-Module posh-cli -Force
        if ($uninstalledPoshGit) {
            Install-Module posh-git -Scope CurrentUser -Force
        }
    }
    
    It "Installs posh-git if missing" {
        # Check pre-requisites first
        Get-Command -Name git -CommandType Application | Should -Not -BeNullOrEmpty
        Get-Module posh-git -ListAvailable | Should -BeNullOrEmpty
        Install-TabCompletion -Verbose
        Get-Module posh-git -ListAvailable | Should -Not -BeNullOrEmpty
        Get-Content $PROFILE -Raw | Should -MatchExactly "$([System.Environment]::NewLine)Import-Module posh-git"
    }
}