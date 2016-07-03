GDB
=====

## Start arguments
- `-c <name-of-core-file>`
- `-x <gdb-script-file>`
- `-q`: quite
- `--tui`
- `-p <process-id-to-attach>`

## Command

- `help`
- `help <topic>`
- `info threads`: Give information on all current threads
- `thread <n>`: Changes to thread n
- `b <n>`: break at source line n
- `b <n> if x == y`: conditional breakpoint at line n when `x` is `y`
- `bt`: backtrace all
- `bt <depth>`: backtrace to a certain depth
- `r <args>` launch program with args
- `c`: continue
- `p <expr>`: evaluate and print expression
- `p/x`: print in hex
- `p/d`: print as signed integer
- `p/u`: print as unsigned integer
- `p/t`: print in binary
- `p/c`: print as character
- `ptype <variable>`, `ptype <type>`: print type information
- `apropos <keyword>`: search keyword
- `info args`: list program cmd args
- `info breakpoints`: list breakpoints
- `info registers`: list registers in use
- `b <function-name>`
- `b +offset`, `b -offset`
- `b <filename>:<function-name>`
- `b <filename>:<line-no>`
- `b *<addr>`: set breakpoint at address
- `tbreak`: temp breakpoint
- `clear <function-name>`: delete all breakpoints in function
- `clear <line-no>`: delete all breakpoints at line
- `d`: delete all breakpoints
- `disable <breakpoint-num>`
- `finish`: continue to the end of function
- `s`: step into
- `n`: step over
- `until <ident>`: continue until identifier: function name, line number etc.
- `where`: Shows current line number and function
- `frame`: show current stack frame
- `frame <i>`: select frame number
- `up`, `down`: move up/down a single frame
- `info frame`
- `info locals`
- `l`: list source
- `l <ident>`: list source of function, line etc.
- `l <sart-ident>, <end-ident>`: list source at given range
- `info line`: displays position in assembly of current line in source
- `info line <i>`: displays position in assembly of certain line in source
- `si`, `ni`: instruction-level step
- `x 0x<addr>`: show the content of memory at addr
- `x/b 0x<addr>`: show the content of memory at addr in binary
- `kill`: stop program


