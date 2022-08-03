# process info dump
dump process information 

usage:
```bash
chmod +x process_info_dump.sh        # assign executable permission

./process_info_dump.sh --show-fd      # show file descriptor of each process
./process_info_dump.sh --show-task    # show task(thread) information of each process
./process_info_dump.sh --show-maps    # show mapped memory regions of each process

./process_info_dump.sh -h             # show usage message
```

