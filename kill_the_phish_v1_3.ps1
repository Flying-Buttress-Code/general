## Kill The Fish 1.1 brought to you by jon@flyingbuttress.com and ChatGPT4

$banner = @"
 ____ ____ ____ ____ _________ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
||K |||I |||L |||L |||       |||T |||H |||E |||       |||P |||H |||I |||S |||H ||
||__|||__|||__|||__|||_______|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|                                                                              
                                                                                 
"@



Write-Host $banner

function Update-ExchangeModule {
    # Check if ExchangeOnlineManagement module is installed
    $EOModule = Get-Module -ListAvailable -Name ExchangeOnlineManagement
    if (-not $EOModule) {
        $UserInput = Read-Host "Exchange Online Management module is not installed. Would you like to install it now? (Y/N)"
        if ($UserInput -eq "Y") {
            Install-Module -Name ExchangeOnlineManagement -RequiredVersion 3.1.0 -AllowClobber -Force
        }
        else {
            Write-Host "You chose not to install the Exchange Online Management module. Continuing without installation..."
        }
    }
    else {
        # Check if the installed version is less than 3.1.0
        if ($EOModule.Version -lt '3.1.0') {
            $UserInput = Read-Host "An outdated version of the Exchange Online Management module is installed. Would you like to update it now? (Y/N)"
            if ($UserInput -eq "Y") {
                Update-Module -Name ExchangeOnlineManagement -RequiredVersion 3.1.0 -AllowClobber -Force
            }
            else {
                Write-Host "You chose not to update the Exchange Online Management module. Continuing with the currently installed version..."
            }
        }
    }
}

# Update ExchangeOnlineManagement module
Update-ExchangeModule

# Connect to Exchange Online PowerShell
Connect-ExchangeOnline -ShowBanner:$false 

# Connect to Compliance PowerShell
Connect-IPPSSession 

$continueSearch = $true

do {

# Define Compliance Search
# Prompt user for input

$searchName = read-host "Enter a unique search name (use Help ticket number?)"
$senderEmail = Read-Host "Enter sender email address (leave blank to skip)"
$subject = Read-Host "Enter message subject (leave blank to skip)"


# switch statement to only include subject in query when one is given
 
if (-not [string]::IsNullOrEmpty($subject)) {
    $searchQuery = "subject:$subject AND from:$senderEmail"
} else {
    $searchQuery = "from:$senderEmail"
}

New-ComplianceSearch -Name $searchName -exchangelocation all -ContentMatchQuery $searchQuery | Start-ComplianceSearch 

# Wait for Search to complete
$searchStatus = Get-ComplianceSearch -Identity $searchName
while ($searchStatus.Status -ne "Completed") {
    Write-Host "Search Status: $($searchStatus.Status)"
    Start-Sleep -Seconds 30
    $searchStatus = Get-ComplianceSearch -Identity $searchName
}

# Get Search results
$searchResults = Get-ComplianceSearch -Identity $searchName

# Display matching messages to user
if ($searchResults.Count -eq 0) {
    Write-Host "No matching messages found."
}
else {
    Write-Host "Matching Messages:"
    get-compliancesearch $searchname | Select-Object -Property Items, SuccessResults | Format-Table -Wrap -AutoSize
      # Display total number of messages found
    $totalMessages = $searchResults.Items.Count
    Write-Host "Total matching messages found: $totalMessages"
}
    # Prompt user for actions to take
   
    $addToBlockList = Read-Host "Add sender/domain to block list? (y/n)"

  # $reportToMicrosoft = Read-Host "Report matching messages to Microsoft for analysis? (y/n)" 
  # if ($reportToMicrosoft -eq "y") {
  #  # Set up email parameters
  #  $fromAddress = read-host "Please enter e-mail e.g your-email@example.com"
  #  $toAddress = "phish@office365.microsoft.com"
  #  $subjectLine = "Phishing Report: $senderEmail"
  #  $body = "Attached is a phishing email for analysis."
    # Create the phishing folder if it doesn't exist
#    $phishingFolderPath = "C:\temp\phishiing"
#    if (-not (Test-Path $phishingFolderPath)) {
#        New-Item -ItemType Directory -Path $phishingFolderPath | Out-Null
#   }
#
#    # Download each matching message as EML and send it to Microsoft
#    $searchResults | ForEach-Object {
#        # Download message as EML
#        $messageId = $_.Id
#       $emlFilePath = "C:\temp\phishing\phishing-$messageId.eml"
#        Export-Message -Identity $messageId -FilePath $emlFilePath
#
#        # Send email to Microsoft with the EML file attached
#        Send-MailMessage -From $fromAddress -To $toAddress -Subject $subjectLine -Body $body -Attachments $emlFilePath -Credential $M365Cred -UseSsl -Port 587 -SmtpServer "smtp.office365.com"
#
#        # Remove the EML file
#        Remove-Item $emlFilePath
#    }
#    Write-Host "Matching messages reported to Microsoft for analysis."
#}

 <#   
 ## This method using new-tenantallowblocklistitems appears to be broken or work inconsistently.
 if ($addToBlockList -eq "y") {
        # Add sender/domain to block list
     

        $senderDomain = $senderEmail.Split("@")[1]
     
         $blocktype = read-host "Block domain or sender (d/s)?"
        if ($blocktype -eq "d") {
        $toblock = $senderdomain
        }
    if ($blocktype -eq "s") {
    $toblock = $senderEmail
    }
        New-TenantAllowBlockListItems -Block -listtype sender -Entries "$toblock"
        Write-Host "Sender/domain added to block list."
    }
    #>

   $addToBlockList = Read-Host "Add sender/domain to block list? (y/n)"

 if ($addToBlockList -eq "y") {
        # Add sender/domain to block list
        $senderDomain = $senderEmail.Split("@")[1]

        $blockType = Read-Host "Block domain or sender (d/s)?"
        $policy = Get-HostedContentFilterPolicy -Identity "default"

        if ($blockType -eq "d") {
            $blockedDomains = $policy.BlockedSenderDomains + $senderDomain
            Set-HostedContentFilterPolicy -Identity $policy.Identity -BlockedSenderDomains $blockedDomains
        } elseif ($blockType -eq "s") {
            $blockedSenders = $policy.BlockedSenders + $senderEmail
            Set-HostedContentFilterPolicy -Identity $policy.Identity -BlockedSenders $blockedSenders
        }

        Write-Host "Sender/domain added to block list."
    }


    # Delete matching messages
    $deleteMessages = Read-Host "Delete matching messages? (y/n)"
    if ($deleteMessages -eq "y") {
        $searchResults | ForEach-Object { New-ComplianceSearchAction -Searchname $searchName -Purge -PurgeType SoftDelete }
        Write-Host "Matching messages deleted."
    }

  # Ask user if they want to perform another search
    $anotherSearch = Read-Host "Do you want to perform another search? (y/n)"
    if ($anotherSearch -ne "y") {
        $continueSearch = $false
    }
} while ($continueSearch)
