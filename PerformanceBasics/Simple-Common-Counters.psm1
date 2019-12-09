Get-CPUmetrics {
    [CmdLetBinding(DefaultParaeterSetName = "NormalRun")]
    Param(
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "NormalRun")][int]$Interval=1,
        [Parameter(Mandatory = $false, Position = 2, ParameterSetNAme = "NormalRun")][int]$NumberOfSamples=10
    )


    Get-Counter "\Processor(_Total)\% Processor Time" -MaxSamples $NumberOfSamples -SampleInterval $Interval

}