function Edit-Profile { code $PROFILE }
Set-Alias -Name profile -Value Edit-Profile

### Readline settings

# The edit mode $DEITY intended
Set-PSReadLineOption -EditMode Emacs

# Predictive Intellisense, similar to e.g. Fish shell
# Needs PSReadLine >= 2.1.0 (included in Powershell 7.1+)
Set-PSReadLineOption -PredictionSource History

# Fish-like history search with up/down arrow
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

### Custom functions and aliases

function Get-Version {
  Get-CimInstance -ClassName Win32_OperatingSystem |
  Select-Object @{Expression = { $_.Caption + " (" + $_.BuildNumber + ")" } } |
  Format-Table -HideTableHeaders
}
Set-Alias -Name version -Value Get-Version

function Measure-Time {
  param(
    [Parameter(Mandatory = $true)]
    $Cmd
  )
  Measure-Command { Invoke-Expression $cmd | Out-Default } |
  Select-Object -ExpandProperty TotalMilliseconds
}
Set-Alias -Name time -Value Measure-Time

function Update-File {
  param(
    [Parameter(Mandatory = $true)]
    $file
  )

  if (Test-Path $file) {
    (Get-ChildItem $file).LastWriteTime = Get-Date
  }
  else {
    New-Item -ItemType file $file
  }
}
Set-Alias -Name touch -Value Update-File

function Get-Download {
  param(
    [Parameter(Mandatory = $true)]
    $url
  )

  $prog = (Get-Command aria2c).Source
  $opts = '--file-allocation=none', $url
  & $prog $opts
}
Set-Alias -Name down -Value Get-Download

# Unix-like aliases/functions

Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name which -Value Get-Command

Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name g -Value git

function Get-IP {
  (Invoke-WebRequest 'https://api.ipify.org').Content
}
Set-Alias -Name ip -Value Get-IP

### Misc

# Prompt
Invoke-Expression (&starship init powershell)
