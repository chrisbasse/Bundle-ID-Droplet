on open droppedItems
	set bundleIDList to {}
	
	repeat with anItem in droppedItems
		try
			set thePath to POSIX path of anItem
			
			tell application "System Events"
				set itemInfo to info for anItem
				set fileType to file type of itemInfo
				set utiType to type identifier of itemInfo
			end tell
			
			if fileType is "APPL" or utiType is "com.apple.application-bundle" then
				set bundleID to (do shell script "mdls -name kMDItemCFBundleIdentifier -raw " & quoted form of thePath)
				
				if bundleID is not "(null)" and bundleID is not "" then
					copy {name:thePath, bundle:bundleID} to end of bundleIDList
				else
					copy {name:thePath, bundle:"[Bundle ID introuvable]"} to end of bundleIDList
				end if
			else
				copy {name:thePath, bundle:"[Pas une application]"} to end of bundleIDList
			end if
			
		on error errMsg
			copy {name:thePath, bundle:"[Erreur : " & errMsg & "]"} to end of bundleIDList
		end try
	end repeat
	
	set outputText to "Résultats Bundle ID :" & return & return
	repeat with entry in bundleIDList
		set outputText to outputText & item 1 of entry & return & "→ " & item 2 of entry & return & return
	end repeat
	
	set theResult to display dialog outputText buttons {"Copier", "OK"} default button "Copier" with icon note with title "Bundle ID Droplet"
	
	if button returned of theResult is "Copier" then
		set the clipboard to outputText
		display notification "Bundle ID(s) copié(s) dans le presse-papier" with title "Bundle ID Droplet"
	end if
end open
