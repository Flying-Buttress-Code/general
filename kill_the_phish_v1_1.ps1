## Kill The Fish 1.1 brought to you by jon@flyingbuttress.com and ChatGPT4
$banner = @"
 ____ ____ ____ ____ _________ ____ ____ ____ _________ ____ ____ ____ ____ ____ 
||K |||I |||L |||L |||       |||T |||H |||E |||       |||P |||H |||I |||S |||H ||
||__|||__|||__|||__|||_______|||__|||__|||__|||_______|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|                                                                              
                        <><  <><  <><   ><>  ><>  ><>                                                                            
"@

Write-Host $banner
# Connect to Exchange Online PowerShell
$M365Cred = Get-Credential
Connect-ExchangeOnline -Credential $M365Cred -ShowBanner:$false

# Connect to Compliance PowerShell
Connect-IPPSSession -Credential $M365Cred

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
    } else {
        Write-Host "Matching Messages:"
        get-compliancesearch $searchname | Select-Object -Property Items, SuccessResults | Format-Table -Wrap -AutoSize
        # Display total number of messages found
        $totalMessages = $searchResults.Items.Count
        Write-Host "Total matching messages found: $totalMessages"
    }

    # Prompt user for actions to take

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