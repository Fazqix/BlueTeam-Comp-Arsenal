#Purpose: Generates random AD users, each with their own unique username/passwords and places them into OU of your choosing

#Prompt user for amount of random users and OU placement
$NumberOfUsers = Read-Host "How many users do you want to generate?"
$OUName = Read-Host "Which OU do you want them placed in?"

#Get current domain name
$DomainName = (Get-WmiObject Win32_ComputerSystem).Domain

#Break domain name down to OU
$SplitDomain = $DomainName.Split(".")
$DC1 = "DC=" + $SplitDomain[0]
$DC2 = "DC=" + $SplitDomain[1]
$DC3 = "DC=" + $SplitDomain[2] #comment out if only 2
$OUDomain = <#'$DC1,$DC2"#> "$DC1,$DC2,$DC3"

#Generate random usernames
$RandomUsernames = (1..$NumUsers).ForEach{[char[]](97..122|Get-Random -Count 8) -join ''}

#Generate random passwords
$RandomPassword = (1..$NumUsers).ForEach{[char[]](48..122|Get-Random -Count 25) -join ''}

#Check if OU exists, if not, create new OU
if(!(Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'"))
{
New-ADOrganizationalUnit -Name $OUName -Path $OUDomain
Write-Output "OU '$OUName' was created"
} else {
Write-Output "OU '$OUName' already exists"
}

#Create path using new OU and domain
$Path = "OU=" + $OUName + "," + "$OUDomain"
Write-Output $Path

#Creates the users
for ($i=0; $i -lt $NumberofUsers; $i++)
{
New-ADUser -Name "$($RandomUsernames[$i])" -SamAccountName "$($RandomUsernames[$i])" -UserPrincipalName "$($RandomUsernames[$i])@$DomainName" -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText $RandomPassword[$i] -Force) -Enabled $true
}
