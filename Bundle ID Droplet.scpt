on open droppedItems
	repeat with anItem in droppedItems
		try
			-- Vérifier si l'élément est une application
			tell application "System Events"
				set itemInfo to info for anItem
				set fileType to file type of itemInfo
			end tell
			
			if fileType is "APPL" then
				-- Obtenir le bundle ID de l'application
				set bundleID to (do shell script "mdls -name kMDItemCFBundleIdentifier -raw " & quoted form of POSIX path of anItem)
				
				-- Afficher le résultat
				if bundleID is not "(null)" and bundleID is not "" then
					display dialog "Bundle ID:" & return & bundleID buttons {"Copier", "OK"} default button "Copier" with icon note
					
					if button returned of result is "Copier" then
						set the clipboard to bundleID
						display notification "Bundle ID copié dans le presse-papier" with title "Bundle ID Droplet"
					end if
				else
					display dialog "Impossible de récupérer le bundle ID pour cette application." buttons {"OK"} default button "OK" with icon caution
				end if
			else
				display dialog "Veuillez glisser une application (.app) sur ce droplet." buttons {"OK"} default button "OK" with icon stop
			end if
			
		on error errorMessage
			display dialog "Erreur : " & errorMessage buttons {"OK"} default button "OK" with icon stop
		end try
	end repeat
end open

-- Message d'information si le droplet est ouvert directement
on run
	display dialog "Drag an application (.app) onto this droplet’s icon in the Dock to get its bundle ID.
Glissez une application (.app) sur l’icône de ce droplet dans le Dock pour obtenir son bundle ID." buttons {"OK"} default button "OK" with icon note
end run
