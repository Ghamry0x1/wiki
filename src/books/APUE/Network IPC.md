# Network IPC

## Socket Descriptors
A socket is an abstraction of a communication endpoint.

Socket descriptors are implemented as file descriptors in the UNIX System.

```c
#include <sys/socket.h>int socket(int domain, int type, int protocol);
```

Domain:

* `AF_INET`: IPv4 Internet domain* `AF_INET6`: IPv6 Internet domain* `AF_UNIX`: UNIX domain* `AF_UNSPEC`: unspecified

Types:

* `SOCK_DGRAM`: fixed-length, connectionless, unreliable messages
* `SOCK_RAW`: datagram interface to IP (optional in POSIX.1)
* `SOCK_SEQPACKET`: fixed-length, sequenced, reliable, connection-oriented messages
* `SOCK_STREAM`: sequenced, reliable, bidirectional, connection-oriented byte streams


When multiple protocols are supported for the same domain and socket type, we can use the `protocol` argument to select a particular protocol.

A `SOCK_RAW` socket provides a datagram interface directly to the underlying network layer. Applications are responsible for building their own protocol headers when using this interface.

You can’t use a socket descriptor with every function that accepts a file descriptor argument. For example, `lseek` doesn’t work with sockets, since sockets don’t support the concept of a file offset.

Communication on a socket is bidirectional. We can disable I/O on a socket with the `shutdown` function.

```c
int shutdown(int sockfd, int how);
```
## Addressing
Four functions are provided to convert between the processor byte order and the network byte order for TCP/IP applications.```c#include <arpa/inet.h>uint32_t htonl(uint32_t hostint32);uint16_t htons(uint16_t hostint16);
uint32_t ntohl(uint32_t netint32); 
uint16_t ntohs(uint16_t netint16);
```
Generic `sockaddr` address structure:

```cstruct sockaddr {    sa_family_t sa_family; /* address family */    char sa_data[]; /* variable-length address */
    // ...};
```

Pretty-printing

```c
#include <arpa/inet.h>const char *inet_ntop(int domain, const void *restrict addr,
                      char *restrict str, socklen_t size);int inet_pton(int domain, const char *restrict str,
              void *restrict addr);```

The hosts known by a given computer system are found by calling `gethostent`.

```c
#include <netdb.h>struct hostent *gethostent(void);void sethostent(int stayopen);
void endhostent(void);
```

We can get network names and numbers with a similar set of interfaces.

```c
#include <netdb.h>struct netent *getnetbyaddr(uint32_t net, int type);
struct netent *getnetbyname(const char *name);
struct netent *getnetent(void);void setnetent(int stayopen);
void endnetent(void);
```

We can map between protocol names and numbers with the following functions.

```c
#include <netdb.h>struct protoent *getprotobyname(const char *name);
struct protoent *getprotobynumber(int proto);
struct protoent *getprotoent(void);void setprotoent(int stayopen);
void endprotoent(void);
```
Beyond all that, we also have:

* map a service name to a port number with `getservbyname`, map a port number to a service name with `getservbyport`, or scan the services database sequentially with `getservent`.
* map from a host name and a service name to an address, and vice versa. They are `getaddrinfo`, `freeaddrinfo`.

We use the `bind` function to associate an address with a socket.

```c
int bind(int sockfd, const struct sockaddr *addr, socklen_t len);
```

We can use the `getsockname` function to discover the address bound to a socket.

```c
int getsockname(int sockfd, struct sockaddr *restrict addr, socklen_t *restrict alenp);```

## Connection Establishment

```c
int connect(int sockfd, const struct sockaddr *addr, socklen_t len);
```

However, it won't guarantee to success, so we can write a wrapper:

```c
#include "apue.h"
#include <sys/socket.h>

#define MAXSLEEP 128

int connect_retry(int domain, int type, int protocol,
                  const struct sockaddr *addr,
                  socklen_t alen) {
    int numsec, fd;
    
    for (numsec = 1; numsec <= MAXSLEEP; numsec <<= 1) {
        if ((fd = socket(domain, type, protocol)) < 0)
            return (-1);
        if (connect(fd, addr, alen) == 0) {
            return fd;
        }
        close(fd);
                
        if (numsec <= MAXSLEEP / 2)
            sleep(numsec);
    }
    
    return (-1);
}
```

A server announces that it is willing to accept connect requests by calling the `listen` function.

```c
int listen(int sockfd, int backlog);
```

The `backlog` argument provides a hint to the system regarding the number of outstanding connect requests that it should enqueue on behalf of the process.

We use the `accept` function to retrieve a connect request and convert it into a connection.

```c
int accept(int sockfd, struct sockaddr *restrict addr,           socklen_t *restrict len);
```

If we don’t care about the client’s identity, we can set the `addr` and `len` parameters to `NULL`.


## Data Transfer

Although we can exchange data using `read` and `write`, that is about all we can do with these two functions. If we want to specify options, receive packets from multiple clients, or send out-of-band data, we need to use one of the six socket functions designed for data transfer.

```c
ssize_t send(int sockfd, const void *buf, size_t nbytes, int flags);
```

`sendto` allows us to specify a destination address to be used with connectionless sockets.

```c
ssize_t sendto(int sockfd, const void *buf, size_t nbytes,
               int flags, const struct sockaddr *destaddr,
               socklen_t destlen);
```
We can call `sendmsg` with a `msghdr` structure to specify multiple buffers from which to transmit data.

```c
ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
```

Also the receiver end's:

```c
ssize_t recv(int sockfd, void *buf, size_t nbytes, int flags);
```

We can use `recvfrom` to obtain the source address from which the data was sent.

```c
ssize_t recvfrom(int sockfd, void *restrict buf, size_t len,
                 int flags, struct sockaddr *restrict addr,                 socklen_t *restrict addrlen);
```

To receive data into multiple buffers, or if we want to receive ancillary data, we can use `recvmsg`.

```c
ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);
```

## Socket Options
Two interfaces: get, set

Three kinds of options:

1. Generic options that work with all socket types
2. Options that are managed at the socket level, but depend on the underlying protocols for support3. Protocol-specific options unique to each individual protocol

```c
int setsockopt(int sockfd, int level, int option,
               const void *val, socklen_t len);```

The `level` argument identifies the protocol to which the option applies. Such as generic one `SOL_SOCKET` or specific ones `IPPROTO_TCP` and `IPPROTO_IP`.

For a level, there are many socket options specified by `option`. For example. `SOL_SOCKET` has:

* `SO_ACCEPTCONN`: Return whether a socket is enabled for listening
* `SO_BROADCAST`: Broadcast datagrams if *val is nonzero.

and et cetera.

```c
int getsockopt(int sockfd, int level, int option,
               void *restrict val, 
               socklen_t *restrict lenp);```

## Out-of-band Data
OOB allowing higher-priority delivery of data than normal. Out-of-band data is sent ahead of any data that is already queued for transmission. TCP supports this, but UDP doesn't.

## Nonblocking and Async I/O
Nonblocking: These functions will fail instead of blocking, setting `errno` to either `EWOULDBLOCK` or `EAGAIN`.

Async IO: Arrange to be sent the `SIGIO` signal. Enabling:

* Establish socket ownership so signals can be delivered to the proper processes.
* Inform the socket that we want it to signal us when I/O operations won’t block.

They can be accomplished in a various ways, using `fcntl` or `ioctl`.


## Exercises
### 16.1
> Write a program to determine your system’s byte ordering.```c
int x = 1;
char *lsb = (char *) &x + sizeof(x) - 1;

if(*lsb == 1) {
    printf("big endian\n");
} else {
    printf("little endian\n");
}
```### 16.2
> Write a program to print out which `stat` structure members are supported for sockets on at least two different platforms, and describe how the results differ.<mark>FIXME: No idea</mark>### 16.3
> The program in Figure 16.17 provides service on only a single endpoint. Modify the program to support service on multiple endpoints (each with a different address) at the same time.SOLUTION: For each endpoint we will be  listening on, we need to bind the proper address and record an entry in an `fd_set` structure. We will use `select` to wait for connect requests to arrive on multple endpoints.### 16.4
> Write a client program and a server program to return the number of processes currently running on a specified host computer.JUMPED### 16.5
> In the program in Figure 16.18, the server waits for the child to execute the uptime command and exit before accepting the next connect request. Redesign the server so that the time to service one request doesn’t delay the processing of incoming connect requests.Use async IO and pooled connections.

SOLUTION: In the `main` procedure, we need to arrange to catch `SIGCHLD`. Remove `waitpid`, after forking the child, the parent closes the new file descriptor and resume listening. Also, a `SIGCHLD` handler:

```c
void sigchld(int signo) {
    while (waitpid((pid_t)-1, NULL, WNOHANG) > 0)
        ;
}
```### 16.6
> Write two library routines: one to enable asynchronous (signal-based) I/O on a socket and one to disable asynchronous I/O on a socket. Use Figure 16.23 to make sure that the functions work on all platforms with as many socket types as possible.


* establish socket ownership using the `F_SETOWN` `fcntl` command
* enable asynchronous signaling using the `FIOASYNC` `ioctl` command.
* To disable asynchronous socket I/O, we simply need to disable asynchronous signaling.



