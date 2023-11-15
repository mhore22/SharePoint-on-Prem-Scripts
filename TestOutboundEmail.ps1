########## 

# This script is to test the outbound email

##########

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Configuration Parameters
$SiteURL="########"
$Email = "########"
$Subject = "Test Email from SharePoint"
$Body = "Test Email Body"
 
#Get the Web 
$Web = Get-SPWeb $SiteURL
 
#Send Email using SPUtility SendEmail method
[Microsoft.SharePoint.Utilities.SPUtility]::SendEmail($Web ,0,0,$Email,$Subject,$Body)