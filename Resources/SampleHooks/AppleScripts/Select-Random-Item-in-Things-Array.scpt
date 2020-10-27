tell application id "com.culturedcode.ThingsMac"
	set readingListItems to to dos of area "🤓 Reading List"
	set randomItemNum to random number from 1 to count of readingListItems
	set result to item randomItemNum of readingListItems
	show result	
end tell
