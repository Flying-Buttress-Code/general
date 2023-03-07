$keypath = "HKCU:\Software\Autodesk\ODIS"
$valuename = "DisableManualUpdateInstall"
$value = 1
try {
    get-itemproperty -path $keypath -name $valuename -erroraction stop
}
catch [System.Management.Automation.ItemNotFoundException] {
    new-item -path $keypath -force
    new-itemproperty -path $keypath -name $valuename -type dword -value $value -force
}

catch {
    new-itemproperty -path $keypath -name $valuename -type dword -value $value -force
}
