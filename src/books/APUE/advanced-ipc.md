# Advanced IPC

Unix domain sockets: communication within processes on the same machine. *It is efficient*, because it only copies data, without any overhead from protocol headers et cetera.

Unix domain sockets provide both *stream and datagram* interfaces.

```c
#include <sys/socket.h>
int socketpair(int domain, int type, int protocol, int sockfd[2]);
```
This kind of socket pair is also called "fd-pipes" (Full-duplex pipes).

### Naming

```c
struct sockaddr_un {
    sa_family_t sun_family;     // AF_UNIX, sun -- Socket Unix Name ?
    char        sun_path[108];  // pathname
};
```

## Unique Connections

```c
#include "apue.h"

int serv_listen(const char *name);
// Returns file descriptor to listen on if OK, negative value on error

int serv_accept(int listenfd, uid_t *uidptr);
// Returns new file descriptor if OK, negative value on error

int cli_conn(const char *name);
// Returns file descriptor if OK, negative value on error

```

The `name` above is a "well-known" name, e.g. some pathname in the system.

## Passing file descriptors
```c
#include "apue.h"

int send_fd(int fd, int fd_to_send);

int send_err(int fd, int status, const char *errmsg);

int recv_fd(int fd, ssize_t (*userfunc)(int, const void *, size_t));
```

A process (normally a server) that wants to pass a descriptor to another process calls either `send_fd` or `send_err`. The process waiting to receive the descriptor (the client) calls `recv_fd`.

Besides, to exchange file descriptor using UNIX domain sockets, we call the `sendmsg(2)` and `recvmsg(2)` functions. The message structure is like:

```c
struct msghdr {
    void         *msg_name;         /* optional address */
    socklen_t    msg_namelen;       /* address size in bytes */
    struct iovec *msg_iov;          /* array of I/O buffers */
    int          msg_iovlen;        /* number of elements in array */
    void         *msg_control;      /* ancillary data */
    socklen_t    msg_controllen;    /* number of ancillary bytes */
    int          msg_flags;         /* flags for received message */
};
```

## Overall problems
> This kind of book is like "technical reference". You need to be very conscious of the problem you are dealing with to be able to learn something from it. That is not easy. Now, let's see if you can tell or ask something.

The advanced IPC is composed of three parts:

1. UNIX socket domain
2. Unique connections
3. Passing descriptor

For 1, I don't understand why it should be special. The socket is a classical concept used in network (not on the same machine), while IPC has so many available forms so I don't understand why such a mixture exist. Or is it a mixture at all.

The special things about it are: passing descriptors, naming file descriptors passed, and use names to do rendezvous. Also a unique IPC channel per client.

> Why are they NOT AVAILABLE in the pipes, TCP sockets, or FIFOs et cetera

First, TCP socket has larger overhead. Second, pipes et cetera might not provide both STREAM and DATAGRAM interfaces, so you must program in a lower level of abstraction.

Second, the special thing about passing the descriptor here, is that we are having two processes to share the file table entry.

## Exercises
### 17.1
We need to explicitly specify the length of messages through either globally defined value, or some special marks in the stream of information. To avoid message copying, we should not use message queues.

> SOLUTION: regular pipes provide a byte stream interface. To detect message boundaries, we'd have to add a header to each message to indicate the length. However, we still have to copy to/from the pipe. A more efficient approach is to use the pipe only to signal the main thread that a new message is available. At the same time, we need to move the `mymesg` structure to the `threadinfo` structure and use a mutex and a condition variable to prevent the helper thread from reusing the `mymesg` structure until the main thread is done with it.

### 17.2
<del>I'd like to see how this program should be written.</del>

### 17.3
Defining is internal. Declaration is used by outside users.

> SOLUTION: A *declaration* specifies the attributes of a set of declaration also causes storage to be allocated, it is called a *definition*.


### 17.4
<del>Looks not very interesting.</del>

### 17.5
> SOLUTION: Both `select` and `poll` return the number of ready descriptors as the value of the function. The loop that foes through the `client` array can terminate when the number of ready descriptors has been processed.







