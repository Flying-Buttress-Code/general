
#Connect to both services / verify environment 

Connect-ExchangeOnline
Connect-MsolService



#Start Collect Shared Mailboxes.
 
$Users = Get-Mailbox -ResultSize unlimited -Filter "(RecipientTypeDetails -eq 'SharedMailbox')" | select PrimarySmtpAddress

#List Shared Mailboxes
 
foreach ($user in $Users){

Get-MsolUser -UserPrincipalName $user.PrimarySmtpAddress | select UserPrincipalName,BlockCredential

}

read-host -Prompt “**Press ENTER to continue to block sign-in for these accounts...**” 

#Set all to blocked

foreach ($user in $Users){

Set-MsolUser -UserPrincipalName $user.PrimarySmtpAddress -BlockCredential $true

}


#End Setting

write-host "**New Block Credential Settings**" -ForegroundColor Green

foreach ($user in $Users){

Get-MsolUser -UserPrincipalName $user.PrimarySmtpAddress | select UserPrincipalName,BlockCredential

}


