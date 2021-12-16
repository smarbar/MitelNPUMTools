function Test-ModuleVersion {
  $mod = 'EactTeamsDr'
  $moduleinstalled = Get-Module -ListAvailable $mod
  $moduleavailable = Find-Module $mod -Repository 'CavcomsPrivate'

  Set-OutputColour "Green" "Checking you are using the latest EactTeamsDr module..."

  if ($moduleinstalled.version -lt $moduleavailable.version){
    Set-OutputColour "Yellow" "You are using an outdated module version."
    do {
      try {
          [ValidatePattern('^y$|^n$')]$choice = Read-Host "Would you like to upgrade now? Y/N"
      } catch {}
    } until ($?)

    switch ($choice) {
      'y' {Update-Module $mod -Force}
      'n' {break}
    }
  }
}