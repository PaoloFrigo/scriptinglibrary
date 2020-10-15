#requires -module azuread

# Paolo Frigo, https://www.scriptinglibrary.com

# THIS SCRIPT REQUIRES A CSV FILE WITH A LIST OF GUEST USERS AND IT WILL SEND AN INVITATION
# EMAIL WITH A CUSTOMISED MESSAGE BODY.

# I've modified the script that I found in the Microsoft Learn pages (docs.microsoft.com)
# https://docs.microsoft.com/en-us/learn/modules/create-users-and-groups-in-azure-active-directory/2-user-accounts-azure-ad

# SETTINGS
$GuestUserCSVlist   = "D:\bulkinvite\invitations.csv"
$CustomMessage      = "Hello. You are invited to the Contoso organization."



#Connect to your Azure AD tenant
Connect-AzureAD

#Load the list of guest users to invite
$invitations = import-csv $GuestUserCSVlist

#Change the message
$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = $CustomMessage

foreach ($email in $invitations)
   {New-AzureADMSInvitation `
      -InvitedUserEmailAddress $email.InvitedUserEmailAddress `
      -InvitedUserDisplayName $email.Name `
      -InviteRedirectUrl https://myapps.microsoft.com `
      -InvitedUserMessageInfo $messageInfo `
      -SendInvitationMessage $true
   }