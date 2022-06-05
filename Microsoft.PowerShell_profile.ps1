Import-Module -Name posh-git
Import-Module -Name Terminal-Icons

function Edit-Profile { code $PROFILE }
Set-Alias -Name profile -Value Edit-Profile

function Open-VS($path) { Start-Process devenv -Args $path }
Set-Alias -Name vs -Value Open-VS

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

### development

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

### misc

# prompt
Invoke-Expression (&starship init powershell)

# dotnet suggest shell start
if (Get-Command "dotnet-suggest" -errorAction SilentlyContinue) {
  $availableToComplete = (dotnet-suggest list) | Out-String
  $availableToCompleteArray = $availableToComplete.Split([Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries)

  Register-ArgumentCompleter -Native -CommandName $availableToCompleteArray -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $fullpath = (Get-Command $commandAst.CommandElements[0]).Source

    $arguments = $commandAst.Extent.ToString().Replace('"', '\"')
    dotnet-suggest get -e $fullpath --position $cursorPosition -- "$arguments" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}
else {
  "Unable to provide System.CommandLine tab completion support unless the [dotnet-suggest] tool is first installed."
  "See the following for tool installation: https://www.nuget.org/packages/dotnet-suggest"
}

$env:DOTNET_SUGGEST_SCRIPT_VERSION = "1.0.2"
# dotnet suggest script end
