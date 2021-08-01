#Declare Winget Applications Id

    $Applications =(
        "7zip.7zip",
        "Git.Git",
        "Microsoft.PowerShell"
    )
    
    $Parameters = "install -e --id "
    
foreach ($item in $Applications) {
    
    Start-Process winget -ArgumentList "$Parameters $item"
}
