#Find location of windows profile file by running 'echo $PROFILE' in powershell
#PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
Import-Module -Name posh-git

# http://serverfault.com/questions/95431
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
    # https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt
    $origLastExitCode = $LastExitCode
    Write-VcsStatus

    if (Test-Administrator) {  # if elevated
        Write-Host "(A) " -NoNewline -ForegroundColor White
    }

    Write-Host "$env:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    #Write-Host "$env:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    #Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower()))
    {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }
    if ($curPath.ToLower().StartsWith("$FJORDKRAFT/code".ToLower()))
    {
        $curPath = "FK/code" + $curPath.SubString("$FJORDKRAFT/code".Length)
    }

    Write-Host $curPath -NoNewline -ForegroundColor Blue
    #Write-Host " : " -NoNewline -ForegroundColor DarkGray
    #Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    Write-Host ": " -NoNewline -ForegroundColor DarkGray
    $LastExitCode = $origLastExitCode
    "`n$('>' * ($nestedPromptLevel + 1)) "
}

Import-Module Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

$env:node_env="debug"
$ENV:NVM_HOME="$HOME\scoop\apps\nvm\current"
