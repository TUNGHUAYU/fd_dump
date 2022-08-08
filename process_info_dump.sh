# reference https://man7.org/linux/man-pages/man5/proc.5.html

# << define function >>

function USAGE(){
	echo "sh process_info_dump.sh [-v, --verbose][--show-maps][-h, --help]"
	echo ""
	echo "Example 1. display count information of \"fds\" and \"tasks\" in each process"
	echo "sh proccess_dump.sh"
	echo ""
	echo "Example 2. display detail information of \"fds\" and \"tasks\" in each process"
	echo "sh proccess_dump.sh --verbose"
	echo ""
	echo "Example 3. display detail information of \"fds\", \"tasks\", and additional \"maps\" in each process"
	echo "sh proccess_dump.sh --verbose --show-maps"
	echo ""
	echo "reference proc manual: https://man7.org/linux/man-pages/man5/proc.5.html"
	echo "github repo: https://github.com/TUNGHUAYU/process_info_dump"
}

function FUNC_parse_argument(){

	for arg in $@
	do
		case "${arg}" in
			-h | --help)
				USAGE
				exit 0
				;;
				
			--show-maps)
				if [[ ${flag_verbose} == 1 ]];then
					flag_show_map=1
					echo "show map -- ON"
				else
					echo "the --show-maps only support on verbose mode."
					echo "please enter --verbose first"
					USAGE
					exit 1
				fi
				;;
				
			-v|--verbose)
				flag_verbose=1
				echo "verbose -- ON"
				;;
				
			*)
				echo "Syntax Error"
				USAGE
				exit 1
				;;
		esac
	done
}

function FUNC_get_cmdline(){
	
	local proc_path=$1
	local cmdline_path="${proc_path}/cmdline"
	
	if [[ ! -e ${cmdline_path} ]];then
		echo "not found"
	elif [[ ! -r ${cmdline_path} ]]; then
		echo "permission denied"
	else
		echo $(cat ${cmdline_path} | tr -d '\0')
	fi

}

function FUNC_get_exe(){
	
	local proc_path=$1
	local exe_path="${proc_path}/exe"
	
	if [[ ! -e ${exe_path} ]];then
		echo "not found"
	elif [[ ! -r ${exe_path} ]]; then 
		echo "permission denied"
	else 
		echo $(ls -l ${exe_path} | awk 'NF==11{print $(NF-2) $(NF-1) $(NF)} NF==9{print $NF" -> (null)"}')
	fi
}

function FUNC_get_nbr_fds(){
	
	local proc_path=$1
	local fd_path="${proc_path}/fd"

	if [[ ! -e ${fd_path} ]];then
		echo "not found"
	elif [[ ! -r ${fd_path} ]]; then 
		echo "permission denied"
	else 
		echo $(ls ${fd_path} | wc -w)
	fi

}

function FUNC_get_nbr_tasks(){

	local proc_path=$1
	local task_path="${proc_path}/task"

	if [[ ! -e ${task_path} ]];then
		echo "not found"
	elif [[ ! -r ${task_path} ]]; then 
		echo "permission denied"
	else 
		echo $(ls ${task_path} | wc -w)
	fi

}

# << variable setting >>

flag_show_map=0
flag_verbose=0

# << parse argument >>

if [[ $# -ne 0 ]]; then
	FUNC_parse_argument $@
fi

# <<< main >>>

# define format 
if [[ ${flag_verbose} == 1 ]]; then
	
	format='=======pid %s -> %s========\n'
	
else 
	
	format="| %-10s | %-50s | %20s | %20s |\n" # pid exe #fd #task
	
	printf "${format//d/s}" "pid" "exe" "#fd" "#task"
	
fi

# show information
for proc in $(ls -d /proc/[0-9]*)
do

	# filter out unavaliable process
	if [[ ! -e ${proc} ]]; then
		continue
	fi
	
	# get the information
	pid=${proc##*/}
	cmdline=$(FUNC_get_cmdline ${proc})
	exe=$(FUNC_get_exe ${proc})
	nbr_fds=$(FUNC_get_nbr_fds ${proc})
	nbr_tasks=$(FUNC_get_nbr_tasks ${proc})
	
	
	# show information ( simple and verbose version )
	
	if [[ ${flag_verbose} == 1 ]]; then
	
		printf "${format}" "${pid}" "${exe}"
			
		# show fds ( file descriptors )
		echo ""
		echo "[fd]"
		ls -l ${proc}/fd | awk \
		'
		NR>1{
			print $(NF-2)$(NF-1)$(NF)
		}
		'
		echo ""
		
		# show tasks
		echo ""
		echo "[task]"
		ls -l ${proc}/task  | awk \
		'
		NR>1{
			print $NF
		}
		'
	
		# show memory mapping information when flag turn on.
		if [[ ${flag_show_map} == 1 ]];then
		
			echo ""
			echo "[map]"
			cat ${proc}/maps
			
			echo ""
		fi
	
	else 
		
		printf "${format}" "${pid}" "${exe}" "${nbr_fds}" "${nbr_tasks}"
	
	fi
	
done
