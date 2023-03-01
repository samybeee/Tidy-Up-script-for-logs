#auto with logging folder 

function Log-Message {
    param (
        [string]$Message,
        [string]$LogPath = "", #
        [string]$LogFilePrefix = "script" ##enter the name you want your log files to be names. It will also add the time and date
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $logFilename = "{0}\{1}_{2}.log" -f $LogPath, $LogFilePrefix, $timestamp
    $logMessage = "{0} : {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -Path $logFilename -Value $logMessage
}

########################################################

Log-Message -Message "Starting script"
Log-Message -Message "Deleting all of the logs from $defaultLogPath not within $defaultNumDays days" 

######################################################

# Set the default log path and number of days
$defaultLogPath = "" #find the path where your files are you want to continusly delete
$defaultNumDays = #Enter the amount of days you want the script to ignore

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
Log-Message -Message "$($logFiles.Count) log files older than $defaultNumDays days will be deleted from $defaultLogPath."
Log-Message -Message "Script completed successfully"
