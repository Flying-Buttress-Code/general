#Connect to Exchange Compliance URI

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic –AllowRedirection
Import-PSSession $Session




#Use compliance search commands to delete email. Can use various FROM, TO, Etc, fields in the ContentMatchQuery

New-ComplianceSearch -Name "Ticket#orName" -ExchangeLocation ALL -ContentMatchQuery 'FROM:"*@baylinkusa.com"'

Start-ComplianceSearch -Identity "Ticket#orName"

Get-ComplianceSearch -Identity "Ticket#orName" | Format-Table -Wrap Items,SuccessResults

#Check above and make sure results match what you expect:

New-ComplianceSearchAction -SearchName "ScamEmail1" -Purge -PurgeType SoftDelete


#Remove PS Session
Remove-PSSession $Session