#Rename o365 account UPN

#Connect to MSOL Service
Connect-MsolService

#Verify current user's properties
Get-MsolUser -UserPrincipalName current-username@domain.onmicrosoft.com |select DisplayName,SignInName,UserPrincipalName

#Rename user account
Set-msoluserprincipalname -userprincipalname current-username@domain.onmicrosoft.com.com -newuserprincipalname new-username@whateverdomain.com