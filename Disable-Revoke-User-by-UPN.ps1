#Connect to Azure AD
Connect-AzureAD

#Get current user status
Get-AzureADUser -ObjectId userUPNhere@flyingbuttress.com | fl

#Disable account
Set-AzureADUser -ObjectId userUPNhere@flyingbuttress.com -AccountEnabled $false

#Revoke all current access tokens
Revoke-AzureADUserAllRefreshToken -ObjectId userUPNhere@flyingbuttress.com


