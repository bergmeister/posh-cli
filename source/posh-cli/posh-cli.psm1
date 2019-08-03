function Install-TabCompletion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
    )
    
    # Get available CLIs
    $applications = (Get-Command -CommandType Application) | ForEach-Object { $_.Name.TrimEnd($_.Extension) }
    
    # Store available CLI completion modules remotely so that user's do not have to update this module when checking for updates
    $completionSourceUri = 'https://raw.githubusercontent.com/bergmeister/posh-cli/master/source/posh-module.json'
    $completionModules = (Invoke-RestMethod -Uri $completionSourceUri).PSObject.Properties
    
    foreach ($completionModule in $completionModules) {
        $cliName = $completionModule.Name
        if (-not ($applications.Contains($cliName))) {
            continue;
        }
        $moduleName = $completionModule.Value
        if (Get-Module -Name $moduleName -ListAvailable) {
            Write-Verbose "Module '$moduleName' is already installed, skipping"
            continue;
        }
        if ($PSCmdlet.ShouldProcess("Installing module '$moduleName' from PSGallery")) {
            Write-Verbose "Installing module '$moduleName' from PSGallery with Scope 'CurrentUser'" -Verbose
            Install-Module -Name $moduleName -Repository PSGallery -Scope CurrentUser -Force
        }
    }
}