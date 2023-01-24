#Purpose: Deletes any newly created users that are not on the initial list

#Set the file path for original list of users
$FilePath = "C:\UserOld.txt"
$FileExists = Test-Path $FilePath

#Check if the file already exists
if($FileExists -eq $false){
#If it doesnt exist, it will generate list of users and create file
$OriginalUsers = Get-ADUser -Filter *
Set-Content -Value $OriginalUsers -Path $FilePath
Write-Host -ForegroundColor Green "File $FilePath not found, creating...`n"
} else {
#If it does, continue
Write-Host -ForegroundColor Green "File $FilePath detected, continuing program`n"
}

#Grabs list of new users
$NewUsers = Get-ADUser -Filter *
Set-Content -Value $NewUsers -Path "C:\UserNew.txt"

#Compares old list and new list and stores difference
$CompareUsers = Compare-Object -ReferenceObject $OriginalUsers -DifferenceObject $NewUsers
Set-Content -Value $CompareUsers -Path "C:\UserDifference.txt"

#Displays results
Write-Host -ForegroundColor Yellow "New Users:" $CompareUsers -Separator "`n"
Write-Host "If blank, no new users detected`n"

#Confirms if users should be deleted
$ConfirmDelete = Read-Host -Prompt "Do you want to delete these new users? (y/n)"
#If yes, it will loop through each new user
if ($ConfirmDelete -eq "y") {
    foreach ($User in $CompareUsers) {
        #Double checks SideIndicator to make sure it is new, then deletes
        if($User.SideIndicator -eq '=>') {
            Remove-ADUser -Identity $User.InputObject -Confirm:$false
        }
    }
    Write-Host -ForegroundColor Red "Users deleted, program ending"
} else {
Write-Host -ForegroundColor Red "No users deleted, program ending"
}
