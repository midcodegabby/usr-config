# gdb requires permission for auto-loading a .gdbinit file
set auto-load local-gdbinit on

# gdb auto-loads .gdbinit file from these paths (no permission needed)
set auto-load safe-path ~/workspace/projects
