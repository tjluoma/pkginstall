#!/bin/zsh
#
#	Author:		Timothy J. Luoma
#	Email:		luomat at gmail dot com
#	Date:		2011-07-20
#
#	Purpose: 	install a pkg
#
#	URL:

#	MAKE_PUBLIC:YES

NAME="$0:t"

# We're going to make a temp file, but we'll make sure no one else can read it
umask 077

REBOOT=no
AUTO_REBOOT=no
ERROR=0

if [ "$1" = "-r" ]
then

	# if you call `pkginstall.sh -r` it will automatically reboot after completion
	# BUT only if one of the installation pkgs requested a reboot

		AUTO_REBOOT=yes
		shift
elif [ "$1" = "-R" ]
then

	# if you call `pkginstall.sh -R` it will automatically reboot 1 minute after completion
	# REGARDLESS of whether any packages requested a reboot

		AUTO_REBOOT=yes
		REBOOT=yes
fi

for FILE in $@
do

	if [[ -r "$FILE" ]]
	then
			# $FILE exists and is readable

		# zsh - get extension
		EXT="$FILE:e"

		if [ "$EXT" = "pkg" -o "$EXT" = "mpkg" ]
		then

				# zsh - get filename without `dirname` or extension.
				#			i.e. /path/to/foo.bat becomes "foo"
			SHORT="$FILE:r:t"

				# Create a log for each package
				# LOGNAME is username
				# NAME:r is the name of this script without path
				# $SHORT is package name without path or extension
			LOG="/tmp/$LOGNAME.$NAME:r.$SHORT.log"


				# tell the user what we are doing
				# especially why they might be asked for their password
			MSG="$NAME: Installing $FILE\n\tLogging to $LOG\n(Note: sudo may ask for your administrator password)"

				# here's where the actual installation happens
				# the 'tee' line saves the output to the logfile
			echo "$NAME: Preparing to install $FILE on /"

			sudo installer -allowUntrusted -verboseR -pkg "$FILE" -target / -lang en 2>&1 | tee -a "$LOG"

				# see how 'installer' exits
			EXIT="$?"

			if [ "$EXIT" = "0" ]
			then
					# the installation succeeded
				echo "$NAME: $FILE was installed successfully."

					# check the log to see if it said anything about rebooting
					# and if it did, toggle REBOOT variable which we'll test later
				fgrep -q 'installer: The install recommends restarting now.' "$LOG" && REBOOT=should

				fgrep -q 'installer: The install requires restarting now.'   "$LOG" && REBOOT=must

			else
					# If installation did not succeed, tell the user where to find the log
					# and stop, even if we have other things to try to install
				echo "$NAME: failed (\$EXIT = $EXIT). See $LOG for details"

				exit 1
			fi

		else

				# if the file extension isn't pkg or mpkg then this isn't a package
				# don't try to install it

			echo "$FILE is not a package, \$EXT is $EXT."

				# we don't exit immediately because we might be able to install other packages
			ERROR=1

		fi # file extension check

	else
			echo "$NAME: $FILE does not exist or isn't readable"
			# we don't exit immediately because we might be able to install other packages
			ERROR=1
	fi
done





if [ "$REBOOT" = "no" ]
then
		echo "$NAME: rebooting is not necessary after this install"


elif [ "$REBOOT" = "should" ]
then


	if [ "$AUTO_REBOOT" = "yes" ]
	then
				# Reboot in two minuts this should (hopefully!) give the
				# user a chance to save anything they are working on
			sudo shutdown -r +2


			if (( $+commands[growlnotify] ))
			then

				growlnotify  \
				--appIcon "Terminal"  \
				--identifier "$NAME"  \
				--sticky \
				--message "The system is rebooting in two minutes from `date" \
				"$NAME"
			fi
	else
			echo "\n\n\n\t\t$NAME: Rebooting is RECOMMENDED.\n\n"

	fi

elif [ "$REBOOT" = "must" ]
then

	if [ "$AUTO_REBOOT" = "yes" ]
	then
			# Reboot in one minute
			# this should (hopefully!)
			# give the user a chance to save anything
			# they are working on
			sudo shutdown -r +2
			growlnotify --sticky --message "The system is rebooting in two minutes from `date" "$NAME"

	else
			echo "\n\n\n\t\t$NAME: Rebooting is REQUIRED.\n\n"

	fi

fi



# if we were asked to install any non packages or packages that don't exist, we'll exit with code = 1
exit $ERROR

#EOF
