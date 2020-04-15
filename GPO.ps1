function GetOU-LinkedToGP
{
<#
.Synopsis
   This function will get the OUs where a group policy is linked.
.DESCRIPTION
   This function will the OUs where a group policy is linked. You can output the results to a text file or a csv file as required.
.EXAMPLE
   GetOU-LinkedToGP -GPOName GPO1 -Domain lab.local -server DC1.lab.local 
.EXAMPLE
   GetOU-LinkedToGP -GPOName (Get-Content C:\Temp\GPOlist.txt) -Domain lab.local -server DC1.lab.local 
#>
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Input the GPO Name to check which OUs it is linked to
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [string]$GPOName,
        # Input the Domain Name of the GPO
        [Parameter(Mandatory=$true)]
        [string]$Domain,
        [Parameter(Mandatory=$true)]
        [string]$Server
    )
    Process
    {
        [xml]$gpoxml=Get-GPOReport -Name $GPOName -ReportType Xml -Server $server -Domain $domain
        if($gpoxml.GPO.LinksTo -ne $null)
        {
            $links=$gpoxml.GPO.LinksTo
            foreach($link in $links)
                {
                  [pscustomobject][ordered]@{
                  GPOName=$gpoxml.GPO.Name
                  Location=$link.SOMName
                  Path=$link.SOMPath
                                   }
                }
         } #if block
         else { Write-Output "GPO: $($gpo.DisplayName) is not linked to any OU" }
     } #Process block
} # function
