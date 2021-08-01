# Download latest dotnet/codeformatter release from github

$repo = "microsoft/winget-cli"
$filenamePattern = "Microsoft.DesktopAppInstaller*.msixbundle"
$Prereq = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
$pathExtract = "C:\Appx\"
$preRelease = $false

new-Item -Name Appx -Path c:\ -ItemType Directory |out-null

if ($preRelease) {
    $releasesUri = "https://api.github.com/repos/$repo/releases"
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri)[0].assets | Where-Object name -like $filenamePattern ).browser_download_url
}
else {
    $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $filenamePattern ).browser_download_url
}

$pathpreq = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $(Split-Path -Path $Prereq -Leaf)
$pathZip = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $(Split-Path -Path $downloadUri -Leaf)

Invoke-WebRequest -Uri $downloadUri -Out $pathZip
Invoke-WebRequest -Uri $Prereq -Out $pathpreq


Move-Item -Path $pathZip -Destination $pathExtract -Force
Move-Item -Path $pathpreq -Destination $pathExtract -Force

$filealls = Get-ChildItem -Path $pathExtract

$PrereqFile = $pathExtract + $($filealls[1]).Name
$Terminalfile = $pathExtract + $($filealls[0]).Name

Add-AppxProvisionedPackage -Online -PackagePath "$PrereqFile" -SkipLicense
Add-AppxProvisionedPackage -Online -PackagePath "$Terminalfile" -SkipLicense

Remove-Item -Path $pathExtract -Recurse -Force -Confirm:$false