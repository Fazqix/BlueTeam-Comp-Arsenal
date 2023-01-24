#Purpose: Loops through all AD users (except you) and removes groups

$CurrentUser = Get-ADUser -Identity $env:USERNAME

#Initialize variable to store all AD users
$allUsers = Get-ADUser -Filter{Name -ne $CurrentUser.Name}

#Loop through all AD users
foreach($user in $allUsers)
{
    #Get the groups that the user is a member of
    $userGroups = Get-ADPrincipalGroupMembership -Identity $user.SamAccountName

    #Loop through all groups associated with AD user
    foreach($group in $userGroups)
    {
        #Remove the user from each group
        Write-Output $user.SamAccountName ";" $group.SamAccountName
        Remove-ADGroupMember -Identity $group.Name -Member $user.SamAccountName -Confirm:$false
        $RemovedGroup = $user.SamAccountName + ";" + $group.SamAccountName
        Add-Content -Value $RemovedGroup -Path "C:\RemovedGroups.txt"
    }
}
Write-Output "Removed all groups from all users (except you)"
