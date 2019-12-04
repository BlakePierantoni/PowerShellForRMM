#################################################################
# Title: Setup local service accounts
# Author: Blake Pierantoni
# Date: 2019/06/06
# Description: Check for and add Local Service Account Administrators. You will need to Set Environment Variables in your RMM Tool
#################################################################

#Defining the ErrorActionPreference
$ErrorActionPreference = 'Stop'

#Defining the Password input from AEM and Converting it to a secure string
#The input from AEM is equal to the variable $Env:Password
#PowerShell requires secure strings to be used as passwords

#Converting the Password for Software account to a secure string 
#You can create a custom Environment variable in your RMM tool
$PlainPassword = $Env:SoftwarePassword #Change this to your own Environment Variable set in your RMM

$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

#Converting Password for MyTechPro Account as secure string
$PlainPassword2 = $Env:MyTechProPassword #Change this to your own Environment Variable set in your RMM

$SecurePassword2 = $PlainPassword2 | ConvertTo-SecureString -AsPlainText -Force

#User to search for
$USERNAME = "Software"
$USERNAME2 = "MyTechPro"
#Declare LocalUser Object
$ObjLocalUser = $null
$ObjLocalUser2 = $null

#Using Try to search for $USERNAME
Try {
    Write-Host "Searching for $("$USERNAME and $USERNAME2") in Local Users"
    $ObjLocalUser = Get-LocalUser $USERNAME
    Write-Host "User $($USERNAME) was found"

    $ObjLocalUser2 = Get-LocalUser $USERNAME2
    Write-Host "User $($USERNAME2) was found"
}



#Catching the account doesnt exist error and reports back to console
Catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    "Local Account $($USERNAME) was not found" | Write-Host
}



#Stops PowerShell if there is an error 
Catch {
    "An unspecifed error occured" | Write-Error
    Exit 
}

#Enable Disabled Users
#Retrieves the list of Disabled Users and Re-enables the user if the username is an exact match to "MyTechPro" or "Software"
#If the account doesn't have Admin rights, It adds the user to the local admin Group
$DisabledUsers = get-wmiobject -Class win32_useraccount -filter "localaccount='true'" | Select Name, Disabled
 
 Foreach ($user in $DisabledUsers){ 

Get-LocalUser |?{$_.Name -Match "$USERNAME"} | Enable-LocalUser 
    Add-LocalGroupMember -Group "Administrators" -Member $USERNAME -ErrorAction SilentlyContinue

Get-LocalUser |?{$_.Name -Match "$USERNAME2"} | Enable-LocalUser 
    Add-LocalGroupMember -Group "Administrators" -Member $USERNAME2 -ErrorAction SilentlyContinue
 }



#Create local Software account if the username is not found.
#if the username is found the script sets the password to what is defined in AEM
#Makes user Local Admin and password never expires 
If ($ObjLocalUser) {
 
 Set-LocalUser -Name $USERNAME -Password $SecurePassword -AccountNeverExpires -PasswordNeverExpires 1
 
#If the Software account doesn't exist then it is created and added to the local admin group
}Else {
        Write-Host "Creating Local Admin Account $($USERNAME)"
New-LocalUser -Name $USERNAME -Password $SecurePassword -AccountNeverExpires -PasswordNeverExpires -ErrorAction SilentlyContinue
Add-LocalGroupMember -Group "Administrators" -Member $USERNAME -ErrorAction SilentlyContinue
}



#Create local MyTechPro account if the username is not found.
#if the username is found the script sets the password to what is defined in AEM
#Makes user Local Admin and password never expires 
If ($ObjLocalUser2) {
 
 Set-LocalUser -Name $USERNAME2 -Password $SecurePassword2 -AccountNeverExpires -PasswordNeverExpires 1
 #if the MyTechPro account doesnt exist then it is created and added to the local admin group
}Else {
        Write-Host "Creating Local Admin Account $($USERNAME2)"
New-LocalUser -Name $USERNAME2 -Password $SecurePassword2 -AccountNeverExpires -PasswordNeverExpires -ErrorAction SilentlyContinue
Add-LocalGroupMember -Group "Administrators" -Member $USERNAME2 -ErrorAction SilentlyContinue
}

