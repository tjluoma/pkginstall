
## `mntdmg` as zsh function (will probably work for bash too)


mntdmg () {

	FILENAME="$@"

	if [[ -r "$FILENAME" ]]
	then

		EXT="$FILENAME:e"

		MNTPNT=$(echo "Y" |\
					hdid -plist "$FILENAME" 2>/dev/null |\
					fgrep -A 1 '<key>mount-point</key>' |\
					tail -1 |\
					sed 's#</string>.*##g ; s#.*<string>##g')


			# if nothing was mounted, return an error
		[[ "$MNTPNT" = "" ]] && return 1

			# if something was mounted, give the /Volumes/path/to/it
		echo "${MNTPNT}"

	else

			# if the filename does not exist, return an error
		return 1
	fi

}

