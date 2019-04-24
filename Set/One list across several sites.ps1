#  Sets a SINGLE LIST across several subsites to new or classic experience. Scroll down to enter the correct data and choose "NewExperience",
# "ClassicExperience","Auto" experience option 
#
# Scenario example:
# In HRDept site collection there are several subsites: Hiring, Benefits, Career Paths, etc. Each subsite has a list called Contacts 
# which has been highly customized and not adapted yet for modern experience. The tenant uses default modern experience, but in all of 
# these subsites, the Contacts list has to be switched to classic look.

function Set-ExperienceOptions
{
param (
        [Parameter(Mandatory=$true,Position=1)]
		[string]$Username,
	[Parameter(Mandatory=$true,Position=2)]
		[string]$Url,
    	[Parameter(Mandatory=$true,Position=3)]
		$Password,
    	[Parameter(Mandatory=$true,Position=4)]
		[string]$ListTitle,
    	[Parameter(Mandatory=$true,Position=5)]
		[bool]$IncludeSubsites,
    	[Parameter(Mandatory=$true, Position=6)]
    	[ValidateSet("NewExperience", "ClassicExperience","Auto")]
    	$ExperienceOption
		)

  $ctx=New-Object Microsoft.SharePoint.Client.ClientContext($url)
  $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $password)
  $ctx.Load($ctx.Web)
  $ctx.Load($ctx.Web.Webs)
  $ctx.ExecuteQuery()
 # get the list where experience needs to be changed
  $ll=$ctx.Web.Lists.GetByTitle($ListTitle)
  $ctx.Load($ll)
  $ctx.ExecuteQuery()

  $ll.ListExperienceOptions = $ExperienceOption
  $ll.Update()
  $ctx.ExecuteQuery() 
  
  if($ctx.Web.Webs.Count -gt 0 -and $IncludeSubsites)
  {
     Write-Host "--"-ForegroundColor DarkGreen
     for($i=0;$i -lt $ctx.Web.Webs.Count ;$i++)
     {
        Set-ExperienceOptions -Username $Username -Url $ctx.Web.Webs[$i].Url -Password $AdminPassword -ExperienceOption NewExperience -ListTitle $ListTitle -IncludeSubsites $IncludeSubsites
     }
  }
}


#Paths to SDK
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.Office.Client.Policy.dll"

 
#Enter the data
$AdminPassword=Read-Host -Prompt "Enter password" -AsSecureString
$username="t@testova365.onmicrosoft.com"
$Url="https://testova365.sharepoint.com/sites/STS"
$ListTitle = "MyList"
$IncludeSubsites = $true

Set-ExperienceOptions -Username $username -Url $Url -password $AdminPassword -ExperienceOption NewExperience -ListTitle $ListTitle -IncludeSubsites $IncludeSubsites
