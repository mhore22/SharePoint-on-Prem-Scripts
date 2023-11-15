########## 

# This script copies all files from a source document library to another.

##########

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Custom Function to Copy Files from Source Folder to Target
Function Copy-Files($SourceFolder, $TargetFolder, $Web)
{
    write-host "Copying Files from:$($SourceFolder.URL) to $($TargetFolder.URL)"
    #Get Each File from the Source 
    $SourceFilesColl = $SourceFolder.Files
 
    #Iterate through each item from the source
    Foreach($SourceFile in $SourceFilesColl) 
    {
		#Copy File from the Source
			$NewFile = $TargetFolder.Files.Add($SourceFile.Name, $SourceFile.OpenBinary(),$True)
	  
			#Copy Meta-Data from Source
			Foreach($Field in $SourceFile.Item.Fields)
			{
				If(!$Field.ReadOnlyField)
				{
					if($NewFile.Item.Fields.ContainsField($Field.InternalName))
					{
						$NewFile.Item[$Field.InternalName] = $SourceFile.Item[$Field.InternalName]
						$NewFile.Item["Modified"] = $SourceFile.Item['Modified']
						$NewFile.Item["Author"] = $SourceFile.Item['Author']
						$NewFile.Item["Modified By"] = $SourceFile.Item['Modified By']
						$NewFile.Item["Created By"] = $SourceFile.Item['Created By']
						$NewFile.Item["Created"] = $SourceFile.Item['Created']
					}
				}
			}
			#Update
			$NewFile.Item.UpdateOverwriteVersion()
		 
			Write-host "Copied File:"$SourceFile.Name -ForegroundColor Green
    }
}
 
#Variables for Processing
$WebURL = read-host "Please enter web url"

$SourceLibrary ="######"
$TargetLibrary = "######"
 
#Get Objects
$Web = Get-SPWeb $WebURL
$SourceFolder = $Web.GetFolder($SourceLibrary)
$TargetFolder = $Web.GetFolder($TargetLibrary)

 
#Call the Function to Copy All Files
Copy-Files $SourceFolder $TargetFolder $Web