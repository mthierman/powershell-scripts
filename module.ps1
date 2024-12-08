param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Function
)

Start-Job -ScriptBlock {
    param([String]$function)

    Import-Module -Name (Get-Item module).FullName -Verbose
    $function.Length
    &$function
} -ArgumentList $Function | Wait-Job | Receive-Job
