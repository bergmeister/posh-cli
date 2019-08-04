Describe "Add-CommandToProfile" {
    BeforeAll {
        Import-Module ..\source\posh-cli\posh-cli.psm1
    }

    AfterAll {
        Remove-Module posh-cli
    }
    
    It "Appends command to PROFILE with newline prepended" {
        $randomText = "#$(New-Guid)"
        Add-CommandToProfile $randomText
        Get-Content $PROFILE -Raw | Should -MatchExactly "$([System.Environment]::NewLine)$randomText"
    }
}