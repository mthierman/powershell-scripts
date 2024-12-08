param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$mod_cmd
)

function Import-CustomModule
{
    param([String]$cmd)

    Import-Module -Name (Get-Item module).FullName -Verbose
    # $cmd.Length
    # &$cmd
    # $cmd
    # Invoke-Expression $cmd
}

$command = Import-CustomModule $mod_cmd

pwsh -nop -nol -noni -Command $command $mod_cmd

# pwsh -nop -nol -noni -Command $module($Command)

# pwsh -nop -nol -noni -Command {
#     Import-Module -Name (Get-Item module).FullName
#     $Command
#     # Invoke-Expression $Command
# }
