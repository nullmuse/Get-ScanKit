$ta = [PSObject].Assembly.GetType(
      'System.Management.Automation.TypeAccelerators'
    )
	
$ta::Add('Marshal', [Runtime.InteropServices.Marshal])

Add-Type -Assembly "System.Net.NetworkInformation"





Function Nping([String]$Target, [Int]$Count, [Int]$Ttl, [bool]$Frag, [Int]$Timeout, [String]$Data, [Int]$Delay, [switch]$Murica) { 

if($Target -eq 0) { 
Write-Host "No target Specified"
return 
}

Write-Host $Data

$nping = New-Object System.Net.NetworkInformation.Ping

if (($Target[0].ToInt32($null)) -gt 57) { 
$Target = $nping.Send($Target).Address.IPAddressToString
}

$Targets = 1
$cnt = 1
if ($Count -ne 0) { 
$cnt = $Count
}
$to = 1000
$TargetPtr = [Marshal]::AllocHGlobal(20) 
$rangestart = $Target.Substring(($Target.LastIndexOf('.') + 1), ($Target.Length) - ($Target.LastIndexOf('.') + 1))

$k = 0
for($i=0;$i -lt $Target.Length; $i++) {
if($Target[$i] -eq '-') {
$range = [Marshal]::AllocHGlobal(4)
$rangestart = $Target.Substring(($Target.LastIndexOf('.') + 1), (($Target.LastIndexOf('-') - 1)) - ($Target.LastIndexOf('.')))
#$TargetPtr = ($TargetPtr + ($i - 1))
$i++
$k = $i - ($Target.LastIndexOf('.') + 1)

 }
[Marshal]::WriteByte($TargetPtr, ($i - $k), $Target[$i])


 }
[Marshal]::WriteByte($TargetPtr, ($i - $k), $null)
$rangeinit = $Target.Substring(0,($Target.LastIndexOf('.') + 1))
if($k -ne 0) {
$rangeend = [Marshal]::PtrToStringAnsi($TargetPtr)
$dstart = ($rangeend.LastIndexOf('.') + 1)
$rangeinit = $rangeend.Substring(0,$dstart)
$selection = $rangeend.split('.')
$selection
$Targets = ($selection[-1].ToInt32($null) - $rangestart.ToInt32($null))
Write-Host "target count $Targets " $Targets.gettype()
}
[Marshal]::FreeHGlobal($TargetPtr)


$op = New-Object System.Net.NetworkInformation.PingOptions
if($Ttl -or $Frag ) { 
if($Ttl) { 
$ops.Ttl = $Ttl 
}
if($Frag -eq $true) {
$ops.DontFragment = $true

}

}

if($Timeout -ne 0) {
$to = $Timeout 
}
$new = @()
if($Data) {
$new = @()
for($i = 0; $i -lt $Data.Length; $i++) { 
$new += $Data[$i]
}

 }
if ($new.Length -eq 0){ 
$new = @()
$thia = 97..119
$thib = 97..105
$new = $thia + $thib
}

$cmd = {
param($a,$b)
Add-Type -Assembly "System.Net.NetworkInformation"
$nping = New-Object System.Net.NetworkInformation.Ping

$nping.Send($a,$b)
}

if($Murica -eq $true) {
Write-Host "MURICA MODE ENGAGED"
for($i = 0; $i -lt $Targets; $i++) { 
$cnt = 1
$to = 10
$thost = ($rangeinit + $rangestart)
Start-Job -scriptblock $cmd -ArgumentList $thost,$to
$rangestart = ($rangestart.ToInt32($null) + 1)
$rangestart = $rangestart.ToString()
}
$Complete = Get-Date

While ($(Get-Job -State Running).count -gt 0){
    $Jobsrunning = ""
    ForEach ($item  in $(Get-Job -state running)){$Jobsrunning += ", $($item.name)"}
    $Jobsrunning = $Jobsrunning.Substring(2)
    Write-Progress  -Activity "Scanning" -Status "$($(Get-Job -State Running).count) threads remaining" -CurrentOperation "$Jobsrunning" -PercentComplete ($(Get-Job -State Completed).count / $(Get-Job).count * 100)
    If ($(New-TimeSpan $Complete $(Get-Date)).totalseconds -ge 600){"Killing all jobs still running . . .";Get-Job -State Running | Remove-Job -Force}
    Start-Sleep -Milliseconds 2000
}
Get-Job | Receive-Job | Select-Object * -ExcludeProperty RunspaceId | out-gridview -Title "Merica Vision"

}

if($Murica -ne $true) {
for($i = 0; $i -lt $Targets; $i++) { 
$thost = ($rangeinit + $rangestart)
for($m = 0;$m -lt $cnt; $m++) {
$responses = $nping.Send($thost,$to,$new,$op)
Write-Host $thost ":" $responses.Status 
if($Delay -gt 0) { 
Start-Sleep -s $Delay
}
 }
$rangestart = ($rangestart.ToInt32($null) + 1)
$rangestart = $rangestart.ToString()


}
}
}

