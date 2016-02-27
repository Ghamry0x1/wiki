### 如何看待 PL 和 Web 的关系？

Web is built on the solid foundation laid by the ancestors in CS, in which PL should play a big role. What's more, the Web is also stimulating some PL research such as Ur/Web and typescript and cutting-edge PL-related engineering efforts, such as Rust Engine and so on.

A lot of programming language are used to make designing a web page and empower designer with even more dynamic power and computation power. We can see HTML5, CSS3, and ES6 are all representing some PL efforts.

The more backend/engine technology, such as V8 and Servo, such as Node.js and Yesod, or the more advanced WebAssembly are all depending on some research efforts from PL, such as JIT compilation, code generation, stack-based IR code, etc.

So, PL can make Web a better place, and web can give PL students some interesting problems to solve.


### Web 相关的 system 原理和特点？
一般的 web 开发指 client end + server end, 但是客户端不同于广义的前端（还有界面、交互设计的部分），客户端技术主要解决的是和服务器沟通数据，将数据分发到页面元素中，以及承担一定程度的本地计算任务（参见网页应用和 MVC）。而后端也一般不包含运维和基础设施（如操作系统、文件系统）开发的部分，更多地是承担处理前端发回的用户请求的任务，其中主要是由数据库访问组成（I/O），也有可能一些计算量比较大的请求，当然处理完请求后的返回页面 HTML 渲染等也有时是后端的责任。不过基于 Web API 的服务一般并不需要涉及 HTML，只要 JSON 等格式返回数据即可。

所以，Web 涉及到的系统主要是：

* 浏览器（DOM tree，Cookie，Script API etc）
* 服务器软件（node.js，Django etc）

一般来说，client 端编程限制比较大，和 DOM Tree 交互较多，是渲染页面的主要场地；服务器端编程限制少，主要是和文本、结构数据等打交道，可以采用多种计算模型。

#### V8 JS Engine 的架构


#### AngularJS 的架构

#### Node.js 的架构


#### Nginx 的架构
* Focus: High performance, high concurrency, low memory usage
* Additional features: load balancing, caching, access control, bandwidth ctrl
* Modern web arch: Robustness & Scalability
* Diff:
    + Old: slow, homogenous, separated connection, static, single connection`
    + Today: fast, heterogenous, persistent connection, dynamic, multi-connection (load-speed opt by browser)
* Apache's old model: single phy machine, running single apache instance
    + Even for concurrency: Fork => bad scalability
* Nginx's new model: Event-driven, solving C10K problem
* Key features: Offload concurrency, latency processing, SSL, static content, compression and caching, connections and requests throttling ...
* Integration with `memcached` and `Redis` ...
* Arch:
    + Modular, event-driven, async, single-threaded, non-blocking
    + Multiplexing & Event notif
    + `Worker` A single-threaded run-loop process
    + Worker contains the core and modules.
        + Module: R/W to/from net/store, transform content, outbound filtering, apply server-side include actions, pass the reqs to the upstream servers (proxying)
        + Nginx's notif mechanism: `epoll`, `kqueue`, and `event ports` etc.
        + `Worker` accept new reqs from a shared `listen` socket
        + A separate `worker` per core: prevent threads thrashing & locking, better IO scalability
    + Other process: master process, cache manager, cache loader ...
    + Master process: config, socket binding, work spawning, upgrade
    + Nginx caching: fs hierarc
+ Nginx's config is rather centralized. Config has several different ctxs for `main`, `http`, `server`, `upstream`, `location` and also `mail`. Contexts never overlap.
+ Nginx has a C-style convention.
+ Rewrite rules
+ `try_files` directives
+ A typical HTTP req:
    * Client: send HTTP Req
    * Select the phase handler based on the configured location
    * Load balancer picks upstream server for proxying
    * Phase handler does the job and passes each output to a filter
    * Filters filter in a chained manner
    * Final response is sent to the client
* Run-loop actions
    * Begin `ngx_worker_process_cycle()`
    * Process events with OS specific mechanism, such as `epoll` or `kqueue`
    * Accept events and dispatch the relevant actions
    * Process/proxy request header and body
    * Generate response content (header and body) and stream it to the client     * Finalize req
    * Re-initialize timers & events
* Body filters
* Writer filters
* Sub-req
* ...









