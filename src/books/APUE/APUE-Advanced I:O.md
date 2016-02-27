# APUE -- Advanced I/O

## Nonblocking I/O
System calls: "slow" one and all the others. "Slow" meaning possibly blocking forever, include:

1. Reads that can block the caller forever if data isn’t present with certain file types
2. Writes that can block the caller forever if the data can’t be accepted immediately by these same file types
3. Opens that block until some condition occurs on certain file types
4. Reads and writes of files that have mandatory record locking enabled
5. Certain `ioctl` operations
6. Some of the interprocess communication functions

> Disk I/O is not considered "slow"

Two ways to specify nonblocking I/O for a given descriptor:

1. `open` with `O_NONBLOCK` flag
2. For opened ones, use `fcntl` to turn on `O_NONBLOCK` flag

## Record Locking
*Record Locking* is the ability of a process to prevent other processes from modifying a region of a file while the first process is reading or modifying that portion of the file.

> However, a better name is "byte-range" locking

### `fcntl` record locking
```c
#include<fcntl.h>
int fcntl(int fd, int cmd, ... /* struct flock *flockptr */);
```

For record locking, `cmd` is `F_GETLK`, `F_SETLK`, or `F_SETLKW`.

```c
struct flock {
    short  l_type;   /* F_RDLCK, F_WRLCK, or F_UNLCK */
    short  l_whence; /* SEEK_SET, SEEK_CUR, or SEEK_END */
    off_t  l_start;  /* offset in bytes, relative to l_whence */
    off_t  l_len;    /* length, in bytes; 0 means lock to EOF */
    pid_t  l_pid;    /* returned with F_GETLK */
};
```

* The type of lock desired: `F_RDLCK` (a shared read lock), `F_WRLCK` (an exclusivewrite lock), or `F_UNLCK` (unlocking a region)
* The starting byte offset of the region being locked or unlocked (`l_start` and`l_whence`)
* The size of the region in bytes (`l_len`)
* The ID (`l_pid`) of the process holding the lock that can block the current process (returned by `F_GETLK` only)

### Implied Inheritance an Release of Locks
1. Locks are associated with a process and a file.
2. Locks are never inherited by the child across a `fork`.

### Locks at End of File
Caution when locking or unlocking byte ranges relative to the end of file. But we can't call `fstat` to obtain the current file size if we don't have a lock on the file. 
> We may leave one byte locked at the original end of the file

### Advisory versus Mandatory Locking

Mandatory locking causes the kernel to check every open, read, and write to verify that the calling process isn’t violating a lock on the file being accessed. Mandatory locking is sometimes called enforcement-mode locking.

## I/O multiplexing
> What if we have to read from two descriptors?

> Nonblocking I/O = Polling + Async + Multiplexing

Problems of asynchronous I/O:

1. Portability can be an issue
2. the limited forms use only one signal per process (`SIGPOLL` or `SIGIO`).


Principles of I/O multiplexing: build a list of the descriptors that we are interested in, and call a function that doesn’t return until one of the descriptors is ready for I/O. Three functions `poll`, `pselect`, and `select` allow us to perform I/O multiplexing

For their usage, see `man`.

## Asynchronous I/O
Costs:

1. three sources of errors for every asynchronous operation: one associated with the submission of the operation, one associated with the result of the operation itself, and one associated with the functions used to determine the status of the asynchronous operations.
2. extra setup and processing rules
3. Recovering from errors can be difficult.

### POSIX Async I/O Interface
```c
struct aiocb {  int             aio_fildes;       /* file descriptor */  off_t           aio_offset;       /* file offset for I/O */  volatile void  *aio_buf;          /* buffer for I/O */  size_t          aio_nbytes;       /* number of bytes to transfer */  int             aio_reqprio;      /* priority */  struct sigevent aio_sigevent;     /* signal information */  int             aio_lio_opcode;   /* operation for list I/O */};```


### `readv` and `writev` functions
The `readv` and `writev` functions let us read into and write from multiple noncontiguous buffers in a single function call. These operations are called scatter read and gather write.
### `readn` and `writen` Functions
Pipes, FIFOs, and some devices like terminals and networks, have the following two properties:

1. A `read` operation may return less than wanted. We should simply continue
2. A `write` operation may write less than wanted. We should continue to write from the remainder.

```c
#include "apue.h"ssize_t readn(int fd, void *buf, size_t nbytes);
ssize_t writen(int fd, void *buf, size_t nbytes);
```

These two functions will keep read/write until the `nbytes` of amount is satisfied.

### Memory-Mapped I/O
Memory-mapped I/O lets us map a file on disk into a buffer in memory so that, when we fetch bytes from the buffer, the corresponding bytes of the file are read. And same for writing.

```c
void *mmap(void *addr, size_t len, int prot, int flag, int fd, off_t off );```

Here, the `addr` is starting address in memory. `fd` is the file to be mapped. `len` is the number of bytes to map. And the `off` is the starting offset in the field of the bytes to map. The `prot` specifies the protection of the mapped region, like read-only or executable et cetera. The mapped memory is somewhere between the heap and the stack. The `flag` argument affects various attributes of the mapped region, such as:

* `MAP_SHARED`: The store operations modify the mapped file.
* `MAP_PRIVATE`: A private copy will be created in case of store operations.

A memory-mapped region is inherited by a child across a `fork` (since it’s part of the parent’s address space), but for the same reason, is not inherited by the new program across an `exec`.

Exactly when the data is written to the file depends on the system’s page management algorithms. Some systems have daemons that write dirty pages to disk slowly over time. If we want to ensure that the data is safely written to the file, we need to call `msync` with the `MS_SYNC` flag before exiting.




