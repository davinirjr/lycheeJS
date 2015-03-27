#!/bin/bash


LYCHEEJS_ROOT=$(cd "$(dirname "$0")/../"; pwd);
NODEJS=`which nodejs`;
SORBET_PID="$LYCHEEJS_ROOT/sorbet/.pid";
SORBET_LOG="/var/log/sorbet.log";
SORBET_ERR="/var/log/sorbet.err";
SORBET_USER=`whoami`;


if [ "$NODEJS" == "" ]; then
	NODEJS=`which node`;
fi;


case "$1" in

	start)

		cd $LYCHEEJS_ROOT;

		if [ "$SORBET_USER" == "root" ]; then 
			$NODEJS ./bin/sorbet.js start "$2" >> $SORBET_LOG 2>> $SORBET_ERR &
		else
			$NODEJS ./bin/sorbet.js start "$2";
		fi;

	;;

	status)

		if [ -f "$SORBET_PID" ]; then

			sorbet_pid=$(cat $SORBET_PID);
			sorbet_status=$(ps -e | grep $sorbet_pid | grep -v grep);

			if [ "$sorbet_status" != "" ]; then
				echo -e "Running";
				exit 0;
			else
				echo -e "Not running";
				exit 1;
			fi;

		else

			echo -e "Not running";
			exit 1;

		fi;

	;;

	stop)

		cd $LYCHEEJS_ROOT;
		$NODEJS ./bin/sorbet.js stop;

	;;

	restart)

		cd $LYCHEEJS_ROOT;
		$NODEJS ./bin/sorbet.js stop;

		if [ "$SORBET_USER" == "root" ]; then 
			$NODEJS ./bin/sorbet.js start "$2" >> $SORBET_LOG 2>> $SORBET_ERR &
		else
			$NODEJS ./bin/sorbet.js start "$2";
		fi;

	;;

	*)

		cd $LYCHEEJS_ROOT;
		$NODEJS ./bin/sorbet.js help;

	;;

esac;
