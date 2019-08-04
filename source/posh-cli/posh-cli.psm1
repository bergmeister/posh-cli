function Install-TabCompletion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Updates already installed modules
        [switch]
        $Update
    )

    # Get available CLIs
    $applications = (Get-Command -CommandType Application) | ForEach-Object { $_.Name.Replace($_.Extension, '') }

    # Store available CLI completion modules remotely so that user's do not have to update this module when checking for updates
    $completionSourceUri = 'https://raw.githubusercontent.com/bergmeister/posh-cli/master/source/cli-modules-v1.json'
    $completionModules = (Invoke-RestMethod -Uri $completionSourceUri).PSObject.Properties

    foreach ($completionModule in $completionModules) {
        $cliName = $completionModule.Name
        if (-not ($applications.Contains($cliName))) {
            continue;
        }
        $moduleName = $completionModule.Value.PSModuleName
        if (Get-Module -Name $moduleName -ListAvailable) {
            Write-Verbose "Module '$moduleName' is already installed, skipping"
            $moduleAlreadyInstalled = $true
            if (-not $Update.IsPresent) {
                continue;
            }
        }
        if ($PSCmdlet.ShouldProcess("Installing module '$moduleName' from PSGallery")) {
            Write-Verbose "Installing module '$moduleName' from PSGallery with Scope 'CurrentUser'" -Verbose
            # posh-git has a clobber, hence the used switch
            Install-Module -Name $moduleName -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
            if (-not $moduleAlreadyInstalled) {
                Add-CommandToProfile -Command "Import-Module $moduleName"
            }
        }
    }
}


function Test-Administrator {
    if ($IsWindows -or $PSVersionTable.PSEdition -eq 'Desktop') {
        ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    }
    # TODO: find a way of determing that on Unix systems
    $true
}


<#
.SYNOPSIS
    Configures your PowerShell profile (startup) script to import the posh-git
    module when PowerShell starts.
.DESCRIPTION
    Checks if your PowerShell profile script is not already importing posh-git
    and if not, adds a command to import the posh-git module. This will cause
    PowerShell to load posh-git whenever PowerShell starts.
.PARAMETER AllHosts
    By default, this command modifies the CurrentUserCurrentHost profile
    script.  By specifying the AllHosts switch, the command updates the
    CurrentUserAllHosts profile (or AllUsersAllHosts, given -AllUsers).
.PARAMETER AllUsers
    By default, this command modifies the CurrentUserCurrentHost profile
    script.  By specifying the AllUsers switch, the command updates the
    AllUsersCurrentHost profile (or AllUsersAllHosts, given -AllHosts).
    Requires elevated permissions.
.PARAMETER Force
    Do not check if the specified profile script is already importing
    posh-git. Just add Import-Module posh-git command.
.EXAMPLE
    PS C:\> Add-PoshGitToProfile
    Updates your profile script for the current PowerShell host to import the
    posh-git module when the current PowerShell host starts.
.EXAMPLE
    PS C:\> Add-PoshGitToProfile -AllHosts
    Updates your profile script for all PowerShell hosts to import the posh-git
    module whenever any PowerShell host starts.
.INPUTS
    None.
.OUTPUTS
    None.
#>
function Add-CommandToProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]
        $Command,
        
        [switch]
        $AllHosts,

        [switch]
        $AllUsers
    )

    if ($AllUsers -and !(Test-Administrator)) {
        throw 'Adding commands to an AllUsers profile requires an elevated host.'
    }

    $profileName = $(if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' }) `
        + $(if ($AllHosts) { 'AllHosts' } else { 'CurrentHost' })
    Write-Verbose "`$profileName = '$profileName'"

    $profilePath = $PROFILE.$profileName
    Write-Verbose "`$profilePath = '$profilePath'"
    if (!$profilePath) { $profilePath = $PROFILE }

    if (!$profilePath) {
        Write-Warning "Skipping add of command to profile; no profile found."
        Write-Verbose "`$PROFILE              = '$PROFILE'"
        Write-Verbose "CurrentUserCurrentHost = '$($PROFILE.CurrentUserCurrentHost)'"
        Write-Verbose "CurrentUserAllHosts    = '$($PROFILE.CurrentUserAllHosts)'"
        Write-Verbose "AllUsersCurrentHost    = '$($PROFILE.AllUsersCurrentHost)'"
        Write-Verbose "AllUsersAllHosts       = '$($PROFILE.AllUsersAllHosts)'"
        return
    }

    # If the profile script exists and is signed, then we should not modify it
    if (Test-Path -LiteralPath $profilePath) {
        if (!(Get-Command Get-AuthenticodeSignature -ErrorAction SilentlyContinue)) {
            Write-Verbose "Platform doesn't support script signing, skipping test for signed profile."
        }
        else {
            $sig = Get-AuthenticodeSignature $profilePath
            if ($null -ne $sig.SignerCertificate) {
                Write-Warning "Skipping adding of command to profile; '$profilePath' appears to be signed."
                Write-Warning "Add the command '$Command' to your profile and resign it."
                return
            }
        }
    }

    $profileContent = "$([System.Environment]::NewLine)$Command"

    # Make sure the PowerShell profile directory exists
    $profileDir = Split-Path $profilePath -Parent
    if (!(Test-Path -LiteralPath $profileDir)) {
        if ($PSCmdlet.ShouldProcess($profileDir, "Create current user PowerShell profile directory")) {
            New-Item $profileDir -ItemType Directory -Force -Verbose:$VerbosePreference > $null
        }
    }

    if ($PSCmdlet.ShouldProcess($profilePath, "Add command '$Command' to profile")) {
        Add-Content -LiteralPath $profilePath -Value $profileContent -Encoding UTF8
    }
}
