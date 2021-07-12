function Edit-Profile { code $PROFILE }
Set-Alias -Name profile -Value Edit-ProfilE

### readline settings

# the edit mode $DEITY intended
Set-PSReadLineOption -EditMode emacs

# predictive intellisense, similar to e.g. fish shell
# needs psreadline >= 2.1.0 (included in powershell 7.1+)
Set-PSReadLineOption -PredictionSource history

# fish-like history search with up/down arrow
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -key uparrow -Function historysearchbackward
Set-PSReadLineKeyHandler -key downarrow -Function historysearchforward

### custom functions and aliases

function Get-Version {
  Get-CimInstance -ClassName win32_operatingsystem |
  Select-Object @{expression = { $_.caption + " (" + $_.buildnumber + ")" } } |
  Format-Table -HideTableHeaders
}
Set-Alias -Name version -Value Get-Version

function measure-time {
  param(
    [parameter(mandatory = $true)]
    $cmd
  )
  Measure-Command { Invoke-Expression $cmd | Out-Default } |
  Select-Object -ExpandProperty totalmilliseconds
}
Set-Alias -Name time -Value measure-time

function update-file {
  param(
    [parameter(mandatory = $true)]
    $file
  )

  if (Test-Path $file) {
    (Get-ChildItem $file).lastwritetime = Get-Date
  }
  else {
    New-Item -ItemType file $file
  }
}
Set-Alias -Name touch -Value update-file

function get-download {
  param(
    [parameter(mandatory = $true)]
    $url
  )

  $prog = (Get-Command aria2c).source
  $opts = '--file-allocation=none', $url
  & $prog $opts
}
Set-Alias -Name down -Value get-download
function get-ip {
  (Invoke-WebRequest 'https://api.ipify.org').content
}

Set-Alias -Name ip -Value get-ip

# unix-like aliases/functions

Set-Alias -Name ll -Value get-childitem
Set-Alias -Name which -Value get-command

Set-Alias -Name open -Value invoke-item
Set-Alias -Name g -Value git

### misc

# prompt
Invoke-Expression (&starship init powershell)
