# reference https://man7.org/linux/man-pages/man5/proc.5.html
# << define function >>

function USAGE(){
	echo "sh process_dump.sh [--show-fd] [--show-maps] [--show_task] [-h, --help]"
	echo "All information are extract from /proc/<pid>"
	echo "reference proc manual: https://man7.org/linux/man-pages/man5/proc.5.html"
	echo "github repo: https://github.com/TUNGHUAYU/process_info_dump"
}

# << variable setting >>

flag_show_fd=0
flag_show_map=0
flag_show_task=0

# << parse argument >>

if [[ $# -eq 0 ]]; then
	USAGE
	exit 0
fi

for arg in $@
do
	case "${arg}" in
		-h | --help)
			USAGE
			exit 0
			;;
	
		--show-fd)
			flag_show_fd=1
			echo "show fd -- ON"
			;;
			
		--show-maps)
			flag_show_map=1
			echo "show map -- ON"
			;;
			
		--show-task)
			flag_show_task=1
			echo "show task -- ON"
			;;
			
		*)
			echo "Syntax Error"
			USAGE
			exit 1
			;;
	esac
done

# <<< main >>>

for proc in $(ls -d /proc/[0-9]*)
do
	echo "=============================================================================="
	printf "%-10s : %s\n" "proc" "${proc}"
	printf "%-10s : %s\n" "cmdline" "$(cat ${proc}/cmdline)"
	printf "%-10s : %s\n" "exe" "$(ls -l ${proc}/exe | awk '{print $(NF-2)$(NF-1)$(NF)}')"
	
	if [[ ${flag_show_task} -eq 1 ]];then
	
		echo ""
		echo "[task]"
		ls -l ${proc}/task  | awk \
		'
		NR>1{
			print $NF
		}
		'
		
	fi

	if [[ ${flag_show_fd} -eq 1 ]];then
	
		echo ""
		echo "[fd]"
		ls -l ${proc}/fd/[0-9]* | awk \
		'
		{
			print $(NF-2)$(NF-1)$(NF)
		}
		'
	
	fi
	
	if [[ ${flag_show_map} -eq 1 ]];then
	
		echo ""
		echo "[map]"
		cat ${proc}/maps
		
		echo ""
	
	fi
	
done