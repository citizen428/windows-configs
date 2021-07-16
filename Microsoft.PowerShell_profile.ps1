Import-Module posh-git
function Edit-Profile { code $PROFILE }
Set-Alias -Name profile -Value Edit-Profile

### readline settings

Set-PSReadlineOption -BellStyle None

# the edit mode $DEITY intended
Set-PSReadLineOption -EditMode emacs

# predictive intellisense, similar to e.g. fish shell
# needs psreadline >= 2.1.0 (included in powershell 7.1+)
Set-PSReadLineOption -PredictionSource history

# fish-like history search with up/down arrow
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

### custom functions and aliases

function Get-Version {
  Get-CimInstance -ClassName win32_operatingsystem |
  Select-Object @{expression = { $_.caption + " (" + $_.buildnumber + ")" } } |
  Format-Table -HideTableHeaders
}
Set-Alias -Name version -Value Get-Version

function Measure-Time {
  param(
    [Parameter(Mandatory = $true)]
    $cmd
  )
  Measure-Command { Invoke-Expression $cmd | Out-Default } |
  Select-Object -ExpandProperty totalmilliseconds
}
Set-Alias -Name time -Value Measure-Time

function Update-File {
  param(
    [Parameter(Mandatory = $true)]
    $file
  )

  if (Test-Path $file) {
    (Get-ChildItem $file).lastwritetime = Get-Date
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

  $prog = (Get-Command aria2c).source
  $opts = '--file-allocation=none', $url
  & $prog $opts
}
Set-Alias -Name down -Value Get-Download

function Get-Ip {
  (Invoke-WebRequest 'https://api.ipify.org').content
}
Set-Alias -Name ip -Value Get-Ip

function New-Directory {
  param(
    [Parameter(Mandatory = $true)]
    $directory
  )

  New-Item -ItemType "directory" -Path $directory && Set-Location $directory
}
Set-Alias -Name mcd -Value New-Directory

# unix-like aliases/functions

Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name which -Value Get-Command

Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name g -Value git

### misc

# prompt
Invoke-Expression (&starship init powershell)
