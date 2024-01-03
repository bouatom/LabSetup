# Import Active Directory module for running AD cmdlets
Import-Module activedirectory
#Store the data from your file in the $ADUsers variable
$ADUsers = Import-csv "INSERT CSV PATH HERE"
#Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers)
{
#Read user data from each field in each row and assign the data to a variable as below
$Username = $User.username
$Password = $User.password
$Firstname = $User.firstname
$Lastname = $User.lastname
$OU = $User.ou
$email = $User.email
$streetaddress = $User.streetaddress
$city = $User.city
$zipcode = $User.zipcode
$state = $User.state
$country = $User.country
$telephone = $User.telephone
$jobtitle = $User.jobtitle
$company = $User.company
$department = $User.department
$Password = $User.Password

#Check to see if the user already exists in the AD

if (Get-ADUser -F {SamAccountName -eq $Username})
{
#If the user does exist, give a warning
Write-Warning "A user account with username $Username already exists in Active Directory."
}
else
{
#User does not exist then proceed to create the new user account
#Account will be created in the OU provided by the $OU variable read from the CSV file
New-ADUser `
-SamAccountName $Username `
-UserPrincipalName "$Username@INSERTDOMAINHERE" `
-Name "$Firstname $Lastname" `
-GivenName $Firstname `
-Surname $Lastname `
-Enabled $True `
-DisplayName "$Lastname, $Firstname" `
-Path $OU `
-City $city `
-Company $company `
-State $state `
-StreetAddress $streetaddress `
-OfficePhone $telephone `
-EmailAddress $email `
-Title $jobtitle `
-Department $department `
-AccountPassword (convertto-securestring $Password -AsPlainText -Force)
}
}

#Store the data from your file in the $ADUsers variable
$ADUsers = Import-csv "INSERTPATHHERE"
#Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers)
{
#Read user data from each field in each row and assign the data to a variable as below
$Username = $User.Username
$Manager = $User.Manager
if (Get-ADUser -F {SamAccountName -eq $Username})
{
#If the user does exist, set the manager
Set-ADUser -Identity $Username -Manager $Manager
}
else
{
#Do Nothing Here
}
}
   
$wsh = New-Object -ComObject Wscript.Shell

$wsh.Popup("Script Completed. Please Check For Errors")