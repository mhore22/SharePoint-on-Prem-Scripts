########## 

# This script removes permission from a site including the subsites

##########  

Add-PSSnapin Microsoft.SharePoint.PowerShell –erroraction SilentlyContinue

# Get all the subsites
Function Get-Subsites($SiteURL){
	# Get all the subsites
	$subsites = ((Get-SPWeb $SiteURL).Site).allwebs | ?{$_.url -like "$SiteURL*"}
	$GroupName="Sample-Group"
	
	foreach($subsite in $subsites) 
	{ 
		if($subsite.url -ne $SiteURL){
			$Web = Get-SPWeb $subsite.url
			$id = ""
			
			foreach ($role in $Web.RoleAssignments)  
			{
				if($role.Member.Name -eq $GroupName)				
				{
					write-host "Removing Members for " $subsite.url
					$id = $role.Member.ID
				}
			}
			
			if($id -ne ""){
				$Web.RoleAssignments.RemoveByID($id)
			}
		}
	}
}


#Variables for Processing
$SiteURL = read-host "Please enter site url"

Get-Subsites $SiteURL