# Import CSV file
$csvPath = "C:\temp\UserNumbers.csv"
$users = Import-Csv -Path $csvPath
$domain = "@mydomain.com"
$plus = "+"
$locationidUID = "LocationID"

# Log file path
$logFilePath = "C:\temp\PhoneNumberAssignmentLog.csv"

# Create the log file with headers if it doesn't already exist
if (-not (Test-Path -Path $logFilePath)) {
    "UserPrincipalName,PhoneNumber,Status,ErrorMessage" | Out-File -FilePath $logFilePath
}

# Loop through each user in the CSV
foreach ($user in $users) {
    $userPrincipalName = $user.UserPrincipalName + $domain
    $phoneNumber = $plus + $user.PhoneNumber

    # Initialize log entry
    $logEntry = New-Object PSObject -property @{
        UserPrincipalName = $userPrincipalName
        PhoneNumber = $phoneNumber
        Status = ""
        ErrorMessage = ""
    }

    # Assign Phone Number (if applicable)
    if ($phoneNumber) {
        try {
            # Assign the phone number
            Set-CsPhoneNumberAssignment -Identity $userPrincipalName -PhoneNumber $phoneNumber -PhoneNumberType CallingPlan -LocationId e0af592e-0f39-45ee-8ed0-60aa976e9baf

            # Update log entry on success
            $logEntry.Status = "Success"
            $logEntry.ErrorMessage = ""
            Write-Host "Assigned phone number $phoneNumber to $userPrincipalName" -ForegroundColor Green

        } catch {
            # Update log entry on failure
            $logEntry.Status = "Failed"
            $logEntry.ErrorMessage = $_.Exception.Message
            Write-Host "Failed to assign phone number to $userPrincipalName" -ForegroundColor Red
        }

        # Append the log entry to the CSV
        $logEntry | Export-Csv -Path $logFilePath -Append -NoTypeInformation
    }
}





