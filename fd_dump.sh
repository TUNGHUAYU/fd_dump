
VALID_ARGS=$(getopt -o o:h --long output:,help -- "$@")
if [[ $? -ne 0 ]]; then
	echo $?
	exit 1;
fi

eval set -- "${VALID_ARGS}"
while [ : ]; do
	case "$1" in
		-o | --output)
			echo "output $2"
			output_file_path=$2
			shift 2
			;;
		-h | --help)
			echo "$0 [-o output_file_path] [-h]"
			exit 2
			;;
		--) shift;
			break
			;;
	esac
done


# <<< main >>>

if [[ -z ${output_file_path} ]];then

	ls -ald /proc/[0-9]* | \
	awk \
	'
	{
		proc_loc=$NF
	
		print "=================================================================="
		print $0
		
		cmd = "ls -al " proc_loc "/fd"
		print cmd
		system(cmd)
	
		cmd = "cat " proc_loc "/cmdline"
		print cmd
		system(cmd)
	
		print ""
	}
	'

else 

	ls -ald /proc/[0-9]* | \
	awk \
	'
	{
		proc_loc=$NF
	
		print "=================================================================="
		print $0
		
		cmd = "ls -al " proc_loc "/fd"
		print cmd
		system(cmd)
	
		cmd = "cat " proc_loc "/cmdline"
		print cmd
		system(cmd)
	
		print ""
	}
	' >& ${output_file_path}

fi
