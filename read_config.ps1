function Read-Config
{
    [OutputType([hashtable])]
    param([String]$config_file)

    Import-PowerShellDataFile $config_file -SkipLimitCheck
}
