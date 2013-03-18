#!/bin/zsh -f

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
	[[ "$MNTPNT" = "" ]] && exit 1

		# if something was mounted, give the /Volumes/path/to/it
	echo "${MNTPNT}"

else

		# if the filename does not exist, return an error
	exit 1
fi

exit
#EOF
