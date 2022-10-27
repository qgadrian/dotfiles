(* For using in Script Editor *)
--alfred_script("xxx;;14;Wishlist")

on alfred_script(q)
	set noDate to "no"
	set theDayArray to {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

	(* Explode query input *)
	set myList to explode(";", q)

	(* get the Title of the Reminder *)
	set theReminder to item 1 of myList

	(* try to get Date, tomorrow or next week on error set to "none" *)
	set queryDay to item 2 of myList
	if queryDay is "" then set queryDay to "none"

	(* Replace . with : <OLD:Set default Reminder Time 8:00> *)
	set queryTime to item 3 of myList
	--	if queryTime is "" then set queryTime to "8:00"
	set queryTime to replace_chars(queryTime, ".", ":")

	set thePriority to item 4 of myList

	(* Get List of for Reminder *)
	set queryList to trim(item 5 of myList)

	(* try to get entered time. if only hours are provided at the missing ":00" *)
	if queryTime is not "" and queryTime does not contain ":" then
		set queryTime to queryTime & ":00"
	end if

	(* calculate due date when "today" was entered. If time string is emptpy, add 3 hours from now *)
	if queryDay contains "today" then
		if queryTime is not equal to "" then
			set theDate to date string of (current date)
			set DueDate to date (theDate & " " & queryTime)
		else
			set DueDate to ((current date) + (3 * hours))
		end if

		(* calculate tomorrow's due date. If time string is empty get current time *)
	else if queryDay contains "tomorrow" then
		if queryTime is equal to "" then
			set queryTime to time string of (current date)
		end if
		set theDate to date string of ((current date) + (1 * days))
		set DueDate to date (theDate & " " & queryTime)

		(* Calculate next weeks due date. If time string is empty get current time *)
	else if queryDay contains "next week" then
		if queryTime is equal to "" then
			set queryTime to time string of (current date)
		end if
		set theDate to date string of ((current date) + (1 * weeks))
		set DueDate to date (theDate & " " & queryTime)

		(* if weekday was provided set due date to the next weekday*)
	else if theDayArray contains queryDay then

		set theNext to list_position(queryDay, theDayArray)
		set theNextWeekday to date string of (nextWeekday(theNext))
		set DueDate to date (theNextWeekday & " " & queryTime)

		(* if no day was provided set noDate flag to "yes" *)
	else if queryDay contains "none" then
		set noDate to "yes"

		(* In case date where provided check if only DD and MM was provided and add current year *)
	else if queryDay contains "." then
		if queryTime is equal to "" then
			set queryTime to time string of (current date)
		end if
		set expDate to explode(".", queryDay)
		if (count of expDate) is equal to 2 then
			set theYear to year of (current date)
			set queryDay to queryDay & "." & theYear
		end if
		set DueDate to date (queryDay & " " & queryTime)

	end if

	(* Create reminder without a DueDate *)
	if noDate is equal to "yes" then
		tell application "Reminders"
			-- get default list set in Reminders
			if queryList is equal to "" then
				set listName to name of default list
			else
				set listName to queryList
			end if

			set availList to name of lists

			if availList does not contain listName then
				set listName to name of default list
			end if

			tell list listName
				make new reminder with properties {name:theReminder, priority:thePriority}
			end tell
		end tell
		set output to theReminder & ", in List: " & listName

		(* Create reminder with DueDate *)
	else
		tell application "Reminders"
			-- get default list set in Reminders
			if queryList is equal to "" then
				set listName to name of default list
			else
				set listName to queryList
			end if

			set availList to name of lists

			if availList does not contain listName then
				set listName to name of default list
			end if

			tell list listName
				make new reminder with properties {name:theReminder, remind me date:DueDate}
			end tell

		end tell
		set output to theReminder & "
Due: " & DueDate & ", in List: " & list
	end if

end alfred_script

(* explode string with given delimter *)
on explode(delimiter, input) -- explode(delimiter (String),input (String)) (Array)
	local delimiter, input, ASTID
	set ASTID to AppleScript's text item delimiters
	try
		-- save delimiters to restore old settings
		set oldDelimiters to AppleScript's text item delimiters
		set AppleScript's text item delimiters to delimiter
		set input to text items of input
		set AppleScript's text item delimiters to ASTID
		set AppleScript's text item delimiters to oldDelimiters
		return input --> list
	on error eMsg number eNum
		set oldDelimiters to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ASTID
		set AppleScript's text item delimiters to oldDelimiters
		error "Can't explode: " & eMsg number eNum
	end try
end explode

(* calculates next weekday as an integer *)
on nextWeekday(wd)
	set today to current date
	set twd to weekday of today
	if twd is wd then
		set d to 7
	else
		set d to (7 + wd - twd) mod 7
	end if
	return today + (d * days)
end nextWeekday

(* returns position in a list *)
on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return 0
end list_position

(*Replaces a character witin a text*)
on replace_chars(this_text, search_string, replacement_string) -- (string,char,char)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

(* =======================================================
FUNTION: Trim trailing whitespaces from a string
RETURNS: String
======================================================== *)
on trim(str)
	set cmd to "echo \"" & str & "\" |  sed 's/ //g'"
	set trimmed to do shell script cmd
	return trimmed
end trim
