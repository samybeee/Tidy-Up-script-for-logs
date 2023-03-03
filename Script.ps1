#auto with logging folder v3 with foreach, more reliable can add multiple file directories and multiple deletion periods. i.e you can have C\desktop\logs, keep all of the files within 30 days and then another file path D\logs and keep everything from 7 days. All you need to is edit the csv file.

function Log-Message {
    param (
        [string]$Message
    )

    $LogPath = "ENTER WHERE YOU WANT THE LOG  FOR THIS SCRIPT HERE"
    $LogFilePrefix = "TidyUpLog_"

    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $logFilename = "{0}\{1}_{2}.log" -f $LogPath, $LogFilePrefix, $timestamp
    $logMessage = "{0} : {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm"), $Message
    Add-Content -Path $logFilename -Value $logMessage
}

#Currently installed on LSNHSVC01, 02, & 03
# Set the default log path and number of days
$defaultLogPath1 = "C:\Users\SBAdmin\Desktop\logs\LogFiles\W3SVC1"
$defaultNumDays1 = 30
Log-Message -Message "Starting script"

Function Delete-Files {

param (
[string]$defaultLogPath,
[int]$defaultNumDays
)

$freespace ="{0:N2} MBs" -f ((gci $defaultLogPath | measure Length -s).sum / 1Mb)
 Log-Message -Message "Current Size $freespace" 

# Calculate the date X number of days ago
$deleteBeforeDate = (Get-Date).AddDays(-$defaultNumDays)

# Get all the log files older than X days
$logFiles = Get-ChildItem -Path $defaultLogPath -Recurse -File | Where-Object { $_.LastWriteTime -lt $deleteBeforeDate }

# Check if there are any log files to delete
if ($logFiles.Count -eq 0) {
    Write-Host "No log files older than $defaultNumDays days were found in $defaultLogPath."
    return
}

# Prompt the user to confirm before deleting the log files
Write-Host "$($logFiles.Count) log files older than $defaultNumDays days will be deleted from $defaultLogPath."
	# Delete the log files
	$logFiles | Remove-Item -Force
$freespaceNow ="{0:N2} MBs" -f ((gci $defaultLogPath | measure Length -s).sum / 1Mb)

Log-Message -Message "New Size: $freespaceNow"

Log-Message -Message "All $($logFiles.Count) have now deleted"

Log-Message -Message "You have now: $freespaceNow free $defaultLogPath"
}

$var = Get-Content -Path C:\Users\SBAdmin\Desktop\hello.csv | ConvertFrom-Csv 

foreach ($logentry in $var) {

Delete-Files -defaultLogPath $logentry.Path -defaultNumDays $logentry.Days

}