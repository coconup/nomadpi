#!/bin/sh

LOG_DATE_FORMAT="%m-%d %H:%M:%S"

[ -z $NC_USER ] && echo "[ error run.sh ]: Username NC_USER (required) is empty." | ts "${LOG_DATE_FORMAT}"
[ -z $NC_PASS ] && echo "[ error run.sh ]: Password NC_PASS (required) is empty." | ts "${LOG_DATE_FORMAT}"
[ -z $NC_URL ] && echo "[ error run.sh ]: Nextcloud URL NC_URL (required) is empty." | ts "${LOG_DATE_FORMAT}"

if [ -z $NC_USER ] || [ -z $NC_PASS ] || [ -z $NC_URL ]; then
  echo "[ error run.sh ]: Configuration is incomplete. Exit." | ts "${LOG_DATE_FORMAT}"
  exit 1
fi

getent group $USER_GID > /dev/null || addgroup -g $USER_GID $USER
getent passwd $USER_UID > /dev/null || adduser -u $USER_UID $USER -D -H -G $USER

[ -d /settings ] || mkdir -p /settings
chown -R $USER_UID:$USER_GID /settings

# check exclude file exists
if [ -e "/settings/exclude" ]; then
	EXCLUDE="/settings/exclude"
else
	echo "[ info run.sh ]: exclude file not found!" | ts "${LOG_DATE_FORMAT}"
fi
# check unsyncedfolders file exists
if [ -e "/settings/unsyncfolders" ]; then
	UNSYNCEDFOLDERS="/settings/unsyncfolders"
else
	echo "[ info run.sh ]: unsync file not found!" | ts "${LOG_DATE_FORMAT}"
fi

[ "$NC_PATH" ] && echo "[ info run.sh ]: Remote root folder overriden to $NC_PATH" | ts "${LOG_DATE_FORMAT}"

[ "$NC_SILENT" == true ] && echo "[ info run.sh ]: Silent mode enabled" | ts "${LOG_DATE_FORMAT}"
[ "$NC_HIDDEN" == true ] && echo "[ info run.sh ]: Sync hidden files enabled" | ts "${LOG_DATE_FORMAT}"
[ "$NC_TRUST_CERT" == true ] && echo "[ info run.sh ]: Trust any SSL certificate" | ts "${LOG_DATE_FORMAT}"

while true
do
	[ "$NC_SILENT" == true ] && echo "[ info run.sh ]: Start sync from $NC_URL to $NC_SOURCE_DIR" | ts "${LOG_DATE_FORMAT}"

	set --
	[ "$NC_HIDDEN" ] && set -- "$@" "-h"
	[ "$NC_SILENT" == true ] && set -- "$@" "--silent"
	[ "$NC_TRUST_CERT" == true ] && set -- "$@" "--trust"
	[ "$NC_PATH" ] && set -- "$@" "--path" "$NC_PATH"
	[ "$EXCLUDE" ] && set -- "$@" "--exclude" "$EXCLUDE"
	[ "$UNSYNCEDFOLDERS" ] && set -- "$@" "--unsyncedfolders" "$UNSYNCEDFOLDERS"
	set -- "$@" "--non-interactive" "-u" "$NC_USER" "-p" "$NC_PASS" "$NC_SOURCE_DIR" "$NC_URL"
	sudo -u \#$USER_UID -g \#$USER_GID nextcloudcmd "$@"

	[ "$NC_SILENT" == true ] && echo "[ info run.sh ]: Sync done" | ts "${LOG_DATE_FORMAT}"

	#check if exit!
	if [ "$NC_EXIT" = true ] ; then
		if [  ! "$NC_SILENT" == true ] ; then
			echo "[ info run.sh ]: NC_EXIT is true so exiting... bye!" | ts "${LOG_DATE_FORMAT}"
		fi
		exit
	fi
	echo "[ info run.sh ]: Wait ${NC_INTERVAL}s until next sync" | ts "${LOG_DATE_FORMAT}"
	sleep $NC_INTERVAL
done
