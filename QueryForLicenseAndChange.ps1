
#Install MS Graph Powershell SDK / https://docs.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-beta
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope AllUsers
#Verify install
Get-InstalledModule Microsoft.Graph
Get-InstalledModule

#Connect / auth
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

#Connect-MSOLService to pull current license users.
Connect-MsolService

#Display all Subscribed SKUs + SKUId for tenant. Verify SkuPartNumber matches what's expected below / alter if needed. 

Get-AzureADSubscribedSku | Select SkuPartNumber,SKUID


#Set variables to correct part #

$BizVoiceTrial = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'BUSINESS_VOICE_MED2'
$TeamsPhone = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'MCOTEAMS_ESSENTIALS'
$AudioConferencing = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'MTR_PREM'


#Get all users with Biz Voice Assigned / Verify

$AllVoiceUsers = Get-MsolUser | Where-Object {($_.licenses).AccountSkuId -match "BUSINESS_VOICE_MED2"}

#Loop through results and add/remove licenses. View results of $AllVoiceUsers first to verify accuracy.  


Foreach($User in $AllVoiceUsers){

# Unassign Business Voice Trial
Set-MgUserLicense -UserId $User.UserPrincipalName -AddLicenses @{} -RemoveLicenses @($BizVoiceTrial.SkuId)

# Assign Teams Phone and Audio Conferencing
Set-MgUserLicense -UserId $User.UserPrincipalName -AddLicenses @{SkuId = $TeamsPhone.SkuId} -RemoveLicenses @() 
Set-MgUserLicense -UserId $User.UserPrincipalName -AddLicenses @{SkuId = $AudioConferencing.SkuId} -RemoveLicenses @()
}


