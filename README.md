# process info dump
dump process information 

usage:
```bash
chmod +x process_info_dump.sh        # assign executable permission

# see usage message
./process_info_dump.sh --help

# see count information of "fds" and "tasks" in each process
./process_info_dump.sh

# see verbose information of "fds" and "task" in each process
./process_info_dump.sh --verbose

# see addtional "maps", memory mapping, information 
./process_info_dump.sh --verbose --show-maps
```

