#
# Author:	Christopher Strom
# Title:	AnchorCreator.ps1
# Date:     03/11/2019
# Task:		Create an anchor file in each folder
#		to prevent folders from being moved
#  Copyright 2019, Christopher Strom, All rights reserved
#
#



#Starting Directory, Ex "C:\test" or "\\server\share"
[string]$rootDIR = "C:\test"


#File to create
[string]$FileName = ".anchor"


#File to copy permissions from
[string]$PermFile = Join-Path -path $rootDIR -childpath $FileName


#Log File
[string]$Logfile = "$rootDIR\$filename.log"


#Current working File/Folder
[string]$curDIR = ""
[string]$curFileName = ""


#Computer/System Name
[string]$compname = "$(gc env:computername)"







#----------------------------------------------------------------------------------------------------
#FUNCTIONS


#Create an anchor file in the current directory
function mkAnchor {

		New-Item -path $DIR -name $FileName -type "file" -value "Admin"
		Writelog "Created Anchor File $FileName in  $curDIR"
        #set permissions for new file
        Get-ACL $PermFile | Set-ACL $CurDIR
        Writelog "Copied Permissions from $PermFile to $curDIR"

}


#Prompts a dialog to press "Ok" before continuingv - like DOS did with batch files
Function Pause ($Message = "Press any key to continue . . . ") {
    if ((Test-Path variable:psISE) -and $psISE) {
        $Shell = New-Object -ComObject "WScript.Shell"
        $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
    }
    else {     
        Writelog -NoNewline $Message
        [void][System.Console]::ReadKey($true)
        Writelog
    }
}


#Write to Log file
Function Writelog
{
   Param ([string]$logstring)
   $date = (Get-Date).ToString()
   $logstring = "$date            $logstring"
   Add-content $Logfile -value  $logstring
}


#----------------------------------------------------------------------------------------------------

Writelog "Launched"

#Check if template file exists if not exit
#Variable $item will contain the object if found.
if(!($item = Get-Item -Path $PermFile -ErrorAction SilentlyContinue)) {

    $item
    Writelog "Template file $PermFile Does not exist. Create and rerun"
    exit
	
}


#Look in every DIR for the "$FileName" if doesnt exist make one
ForEach ($dir in (Get-ChildItem "$rootDIR\*" -directory | ?{$_.PSIsContainer})){

    $curDIR = join-path -path $DIR -childpath $FileName
 IF(!(Test-Path -Path $curDIR)) {
 
        Writelog "Creating New File"
        mkAnchor
            
    }
}

Writelog Completed
