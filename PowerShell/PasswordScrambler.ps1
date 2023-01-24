#Purpose: Loops through all AD users (except current user) scrambles their passwords, and writes new passwords to .txt

$CurrentUser = Get-ADUser -Identity $env:USERNAME

#Variable to store all AD users
$allUsers = Get-ADUser -Filter{Name -ne $CurrentUser.Name}

#Loop through all AD users
foreach ($user in $allUsers) {

    #Generates a random password
    $new_Password = [system.guid]::NewGuid().Guid.Substring(0,30)

    #Sets the new password for the user
    Set-ADAccountPassword -Identity $user -NewPassword (ConvertTo-SecureString $new_Password -AsPlainText -Force)

    #Write the new password to a text file
    $user_Credentials = $user.SamAccountName + ";" + $new_Password
    Add-Content -Value $user_Credentials -Path "C:\NewPasswords.txt"
}

Write-Output "New list of passwords saved to C:\NewPasswords.txt"
