function IsEmpty($Param){
    If ($Param -eq "All" -or $Param -eq "" -or $Param -eq $Null -or $Param -eq 0) {
        Return $True
    } Else {
        Return $False
    }
}

Function Get-UtilCPU {
    [CmdLetBinding(DefaultParameterSetName = "NormalRun")]
    Param(
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "NormalRun")][int]$Interval=1,
        [Parameter(Mandatory = $false, Position = 2, ParameterSetNAme = "NormalRun")][int]$NumberOfSamples=5,
        [Parameter(Mandatory = $false, Position = 3, ParameterSetName = "NormalRun")][string[]]$Computers = $env:COMPUTERNAME,
        [Parameter(Mandatory = $false, Position = 4, ParameterSetName = "NormalRun")][string]$OutputFile
    )
    
    #Avoiding using external function for the current function - testing if $OutputFile has been specified or not
    If ($OutputFile -eq "" -or $OutputFile -eq $Null -or $OutputFile -eq 0) {$OutputFile = ($env:UserProfile) + "\Documents" + "\$(get-date -f yyyy-MM-dd-hh-mm-ss).csv"}
    
    Get-Counter -ComputerName $Computers -Counter "Processor(_Total)\% Processor Time" -MaxSamples $NumberOfSamples -SampleInterval $Interval | ForEach-Object {
        $path = $_.CounterSamples.path
        $PropertyHash=@{
            DateTime=(Get-Date -format "yyyy-MM-d hh:mm:ss")
            ComputerName=($Path -split "\\")[2];
            CounterCategory = ($path  -split "\\")[3];
            CounterName = ($path  -split "\\")[4];
            WholeCounter = $path;
            Instance = $_.CounterSamples.InstanceName ;
            Value = [Math]::Round($_.CounterSamples.CookedValue,2) 
        }
    
    $TempObject = New-Object PSObject -Property $PropertyHash 
    $TempObject | Select datetime, ComputerName, countercategory, CounterName,Value
    $TempObject | Export-CSV -Path $OutputFile -Append -NoTypeInformation
    }

}