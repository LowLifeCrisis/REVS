
$Global:outputFolder = "C:\temp\" 
$Global:logType
$Global:logName
$Global:computerName
$Global:logInput
$Global:Target
$Global:fullpath

clear-host
#Ask user how they would like to search
function selectLog {

    clear-host
    write-host "How will you find your logs?"
    write-host "[1] for Log Name Search"
    write-host "[2] for Provider Search"
    $logSelect = Read-Host -Prompt "Make a selection"

    if ($LogSelect -eq 1) {
        clear-host
        $Global:logType = 'LogName'
        $Global:logInput = Read-Host -Prompt "Log name?"
        $Global:logName = "*$logInput*"
        

    } elseif ($LogSelect -eq 2) {
        clear-host
        $Global:logType = 'ProviderName'
        $Global:logInput = Read-Host -Prompt "Provider name?"
        $Global:logName = "*$logInput*"
        
    }
    else {
        Clear-Host
        write-host "$logSelect is not a valid response!" -foregroundcolor red
        Read-Host -Prompt "Press Enter to Retry"
        
    }
}

function verifyLog {

    if (!($Global:logName)){
        Clear-Host
        $confirm = "n"
        Write-Host "Log provider/name is blank! This will pull all Event Viewer logs for the specified period." -ForegroundColor Red
        $confirm = read-host -Prompt "Are you sure you want to continue? (y/n)"

        if ($confirm -ne 'y') {
            selectLog
        }
    } 
}

function verifyLogLength($logName) {
    if ($Global:logName.length -lt 4) {
        Write-Host "Log provider/name is less than 4 characters! This will likely pull a large amount of logs" -ForegroundColor Red
        $confirm = read-host -Prompt "Are you sure you want to continue? (y/n)"

        If ($confirm -ne 'y') {
            selectLog
        }
        
    } 
}

function selectDateRange {
    do {
        Clear-Host
        $DateInput = Read-Host "How many days back?"
        $Global:Target = (Get-Date).AddDays(-"$DateInput") 
        Clear-Host
        $Global:ComputerName = Read-Host "Computer name?"
        Clear-Host
        Write-Host "Computer Name: $Global:computerName"
        Write-Host "$Global:logType: $Global:logInput"
        Write-Host "Log Age: Starting from $Global:Target"
        $Confirm = Read-Host -Prompt "Is this Correct? (y/n)"
        
    } while ($Confirm -ne 'y')  # Loop through until user confirms
    
    $filename = "{0}_{1}_{2}.csv" -f ($Global:computerName -replace '\.',""),($Global:logInput -replace '\.',""),(Get-Date -Format "yyyyMMddHHmmss")
    $Global:fullpath = Join-Path $Global:outputFolder $filename  
}

#Acivate the functions to run the script 
selectLog
verifyLog 
verifyLogLength
selectDateRange