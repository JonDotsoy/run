#!/bin/sh

function usage() {
	echo "Usage: $(basename $0) [-n <script_name] - make a new script"
	echo "   or: $(basename $0) <script_name>     - run a script"
	echo "   or: $(basename $0)                   - list the scripts"
}

function run() {
	pwd=$(pwd)
	scripts_dir=$pwd/.scripts
	out="false"
	new_script=""

	while getopts "n:h" o
	do
		case $o in
			n) new_script=$OPTARG ;;
			h) usage; out="true" ;;
			*) ;;
		esac
	done

	if [[ $out == "true" ]]
	then
		return 0;
	fi

	if [[ ! -z $new_script ]]
	then
		mkdir -p $scripts_dir
		echo "#!/bin/sh" > $scripts_dir/$2
		echo "" >> $scripts_dir/$2
		chmod -x $scripts_dir/$2
		return 0;
	fi

	if [[ -z $1 ]]
	then
		if [[ -d $scripts_dir ]]
		then
			items=$(ls $scripts_dir)

			for f in $items
			do
				if [[ -f $scripts_dir/$f ]]
				then
					echo "  $f         - "
				fi
			done
		fi
	else
		script_name=$scripts_dir/$1
		if [[ ! -f $script_name ]]
		then
			echo "Cannot found script $1"
			return 1
		fi

		source $script_name ${@:2} 
	fi
}

run $*

