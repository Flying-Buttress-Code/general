#Disable Self-Service for all products in the Tenant. 

#Install MSCommerce Module

Install-Module -Name MSCommerce

#Import MSCommerce Module

Import-Module -Name MSCommerce

#Get all self service purchases and disable self service ability

$allproducts=Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase

Foreach($ProductName in $allproducts){
Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductID $ProductName.ProductID -Enabled $False
}













