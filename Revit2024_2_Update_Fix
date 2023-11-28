# Network path to Revit installation files
$networkPath = "\\path\to\Revit\installation\files"

# Revit registry key
$revitRegKey = "Registry::HKEY_CLASSES_ROOT\Installer\Products\[Revit Product Key]"

try {
    # Update registry for updater path
    Set-ItemProperty -Path "$revitRegKey\SourceList" -Name "LastUsedSource" -Value "n;2;$networkPath"
    Set-ItemProperty -Path "$revitRegKey\SourceList\Net" -Name "2" -Value $networkPath
    Write-Host "Registry paths updated for Revit updater."
} catch {
    Write-Host "Error encountered: $_"
}

# Run with admin rights; always backup registry first.
