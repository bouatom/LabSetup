***CUSTOMIZE YOUR CSV***
1. Change the CSV to match the domain
2. Change the email addresses to match


***CUSTOMIZE THE SCRIPT***
In the ps1 script, you will need to change on line 38 to match your domain

-UserPrincipalName "$Username@INSERTDOMAINHERE" 

You will also need to change the location of where the user csv is location under the line 4 and 59
$ADUsers = Import-csv "INSERT CSV PATH HERE" 


***Errors that need to be fixed***
Misty is the CEO so she does not have a manager. She will create an error in the script but everyone else will be updated.
