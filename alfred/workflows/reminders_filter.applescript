on run argv
	tell application "Reminders"
		set array to {}
		set listNames to name of lists

		repeat with listName in listNames
			set end of array to "{\"title\": \"" & listName & "\", \"arg\": \"" & listName & "\"}"
		end repeat

		set AppleScript's text item delimiters to ","

		return "{\"items\": [" & array & "]}"
	end tell
end run
