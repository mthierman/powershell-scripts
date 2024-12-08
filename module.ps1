param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Function
)

Import-Module -Name (Get-Item "run.psm1").FullName -Verbose
&$function
Remove-Module -Name run
