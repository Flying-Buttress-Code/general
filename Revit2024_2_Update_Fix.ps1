# Network path to Revit installation files- make sure it's the x64\RVT subfolder, not the specific RVT.msi
$networkPath = "\\path\to\Revit\installation\\Revit 2024\Revit_2024_G1_Win_64bit_dlm\x64\RVT"

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
