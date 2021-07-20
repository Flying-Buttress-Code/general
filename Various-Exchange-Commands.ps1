
#Get user's folder statistics/size per folder. 
Get-MailboxFolderStatistics Username | Select Name,FolderSize,ItemsinFolder


#Enable Moca for a user
Set-OwaMailboxPolicy -Identity OwaMailboxPolicy-Default -ProjectMocaEnabled $True


#Set mailbox size for all users in the tenant
Get-Mailbox | Set-Mailbox -ProhibitSendQuota 99GB -ProhibitSendReceiveQuota 100GB -IssueWarningQuota 98GB


#Set mailbox size for 1 user in tenant
Set-Mailbox Username -ProhibitSendQuota 99GB -ProhibitSendReceiveQuota 100GB -IssueWarningQuota 98GB



#Change default permissions for mailbox calendars. MailboxName:\Calendar   
Set-MailboxFolderPermission "Vacation:\calendar" –User Default –AccessRights Reviewer



#Creates local inbox rule for a user.
New-InboxRule -Mailbox username@domain.com –name VoiceMailForward -From unityconnection@whatever.com -ForwardTo mreeve@whatever.com


#Copies items to one target then, delete items from a source:
Search-Mailbox -Identity "tshumaker" -SearchDumpsterOnly -TargetMailbox "temp-exch" -TargetFolder "tshumaker-RecoverableItems" -DeleteContent
search-mailbox -identity fhyde -searchquery {received:01/01/2010..12/31/2017} -deletecontent



#Enabing briefing for users
Set-UserBriefingConfig -Identity graham@flyingbuttress.com -Enabled $true


#Configuring Shared Calendars for full meeting details view
Set-MailboxFolderPermission "Conf - Fishbowl:\calendar" –User Default –AccessRights Reviewer
Set-MailboxFolderPermission "Conf - Orange:\calendar" –User Default –AccessRights Reviewer
Set-MailboxFolderPermission "Conf - Railyard:\calendar" –User Default –AccessRights Reviewer
Set-MailboxFolderPermission "Conf - Sharktank:\calendar" –User Default –AccessRights Reviewer
Set-MailboxFolderPermission "Conf - Warehouse:\calendar" –User Default –AccessRights Reviewer


#Add Shared Mailbox without automapping. First target mailbox, second is user to add/remove
Remove-MailboxPermission -Identity johnsmith@contoso.onmicrosoft.com -User Heidi@hhendy.com -AccessRights FullAccess

#Confirm
Add-MailboxPermission -Identity SourceUserName -User UserToAddUser -AccessRights FullAccess -AutoMapping $false
Remove-MailboxPermission -Identity	adey@hhendy.com	-User Heidi@hhendy.com -AccessRights FullAccess


#Hide Office 365 Group from GAL
Set-UnifiedGroup -Identity o365-Group-ID-Here -HiddenFromAddressListsEnabled $true



#OnPrem/Hybrid enable - must be ran onprem PS
Enable-RemoteMailbox jbartelt@hhendy.com –Archive


#Complete Exchange migration single move request
Get-MoveRequest "UserName"
Get-MoveRequest "UserName" | Set-MoveRequest -SuspendWhenReadyToComplete:$false
Get-MoveRequest "UserName" | Resume-MoveRequest


#Export Content by date: OnPrem Only
New-MailboxExportRequest -ContentFilter {(Received -lt '12/31/2017') -and (Received -gt '01/01/2010')} -Mailbox “fhyde” -Name FHydeExport –FilePath \\mailserver\PST-Export\FHyde-2010-2017.pst

#Send Email from Local SMTP. If using regular user account to auth then from will need to match.
Send-MailMessage -From fromaddy@localdomain.com -To whoever@remotedomain.com -Subject 'Sending the Test' -Body "Body test message" -SmtpServer '10.1.1.40'


#Check Antispam Block List
Get-MailboxJunkEmailConfiguration -Identity "username@domain.com" | Select-Object -ExpandProperty blocked*


#Start AD Sync and sync all changes
Start-ADSyncSyncCycle -PolicyType Delta


#Set all users to 30 days deleted items retention
Get-Mailbox -ResultSize unlimited -Filter "RecipientTypeDetails -eq 'UserMailbox'" | Set-Mailbox -SingleItemRecoveryEnabled $true -RetainDeletedItemsFor 30


#Store all deleted emails / Exchange online
#    Moves items that are two years or older from a user's primary mailbox to their archive mailbox.

#    Moves items that are 14 days or older from the Recoverable Items folder in the user's primary mailbox to the Recoverable Items folder in their archive mailbox.



#Sync Windows PDC EMULATOR to ntp
w32tm.exe /config /manualpeerlist:"0.pool.ntp.org,0x8 1.pool.ntp.org,0x8 2.pool.ntp.org,0x8" /syncfromflags:manual /update
w32tm /resync













