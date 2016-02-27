# Virtual Machines


## Intro to VMs
* Language VM, e.g. JVM
* Process VM
* System VM, like VMware
* Co-designed VM

Taxonomy:

* Process VMs
    + Same ISA
        + Threads
        + Dynamic bin optimizers
    + Diff ISA
        + Dyn Translators
        + HLL VMs -- Interpreter, Compilers
* Sys VMs
    + Same ISA
        + Classic-Sys VMs -- VMM
        + Hosted VMs
    + Different ISA
        + Whole-Sys VMs -- Emulation
        + Co-designed VMs -- Hardware optimizations

Portability? Functionality? Or even better performance?


## Emulation: Interpretation and Binary Translation
Startup cost v.s. continuous cost

Interpreter: manages the state (mem, ctx, code ...)

* Decode-and-dispatch interpretation
* Threaded interpretation
* Pre-decoding
* Direct threaded -- code replacing

RISC v.s. CISC: Only some instructions in CISC are commonly used? Any pattern or skeleton of decoding (instruction template)? Partial decoding (dispatch on first byte)?

Precoding and portability?

Binary translation: how does the mapping work? Register mapping? Other special things?

Dynamic: Code discovering problem in static translation and dyn-translation (akin JIT), code cache (hit, replacement algo...), code map, any inconsistency?

Other issues: self-modifying code, self-ref code, precise traps (debug?)

Same-ISA VM: code management, program shepherding, monitoring (security)

Translation chaining (link translated blocks together)

SPC (Source PC), TPC (Translated PC)


Software indirect jump predication.

Shadow Stack: optimization for lookup overhead

ISA issues: number/property of registers (simulated registers), condition code (lazy eval, compatibility), alignment, endianess, addressing modes ...

Shade: A simulation tool




## Process VMs
ABI: Application binary interface

Proc VM: Loader, signals, os call emulation, exception emulation, code caching, translation + interpretation, profiling..

Compatibility: state correspondence when control transfers (to and from user program and host os)

runtime binary: RT data, RT code ..

memory mapping: translation tables (indirect v.s. direct), arch(segmentation, page sizes ...), access privilege supporting difference, protection/allocation granularity ..

memory protection: `mmap()`, `mprotect()`

self-mod, self-ref code: write-protect -> cache flashing

protect runtime -> two modes: RT mode, emu mode

staged emulation: mixed methods, profiling, hotspot etc.

* Linux: OS-app communication through ABI and signals
* Windows: callbacks, async call, exceptions

I/O simulation: side effect, irrelevant to Turing completeness

code cache v.s. HW cache: no fixed size, presence dep caused by chaining, no backing store (once deleted, only re-translation)

replacement algos: LRU, flush when full, preemptive flush (detect the program phase change), fine-grained FIFO, coarse-grained FIFO

FX!32: Transparent execution of IA-32 apps on Alpha platforms running on Windows.

## Dynamic Binary Translation

Performance becomes the first concern.

Compiler techniques: code motion, reordering, blocked translation (trace, superblock, tree group).

Stages: Interpretation, basic block translation (with chaining or not), optimized translation (larger blocks), highly optimized translation (with profiling information)

Behaviors: backward branch tendency, same-value production ...

Profiling: HW or Software? Probes, interrupts. HotSpot detection (region based), control flow predicability (edge based). Instrumentation v.s. Sampling.

Larger blocks: Locality.

Super block formation: starting points, continuation, end points. Threshold. -> Code relayout

Compatibility issues: register consistency (renaming ... code motion ...), trap consistency (code reordering...), Compensate code

Code patching

Example: HP Dynamo system.


## HLL VM arch
Think process VM is a "after-the-fact" method, while HLL VM is a well-designed plan aimed at portability.

Virtual ISA + APIs

Metadata in V-ISA => Data Set Architecture: describes the data structures, attributes, and relationships


**HLL Program** --- *compiler* ---> **Portable Code** --- *VM loader* ---> **V-ISA memory image** -- *Interpreter/Translator* --> **Execution**


* P-code: Pascal IR
* JVM: Spec, designed with Java in mind
* CLI: Spec, more HLL-general (Instruction part: MSIL)

### P-code
* On-stack op -- short code, better register-mapping friendly
* Mem cells
* Mem stack & heap abstraction
* Common interface to OS (hiding diff OS)


OO HLL VM

Sandbox: Managed code, access control, auto GC, ref checking, OS interface, namespacing, etc.. => Loaders + Runtime

Native Interface: Convention, APIs, FFI, e.g. JNI


Performance -- JIT

Constant Pool

Operand Stack Tracking: At any given point in the program, the operands stack must have the same number and types of operands in the same order. (path insensitivity)

Binary format for distribution (`Class` in Java, `Module` in CLI) consists of: Magic num, version info, constant pool with size, access flags, this class, super class, interface count, field count, field info, methods count, methods, attributes count, attributes.


Java: J2EE, J2SE, J2ME

Java APIs: `java.lang` -- core package, including types, system, security, process, and `Class` for reflection; `java.util` -- data structures and supporting utils ...; `java.io`, `java.net`, `java,awt` ...


Module-based programming -- *Serializability and Reflection*. RMI, platform-indep format for repr of internal ds. (For net or persistenet storage)

Multi-threading -- `Thread` class, `monitor` for lock, `wait` and `notify` for sync.

CLI: more flexible

Verifiable, cross-lang interpretation

## HLL VM impl

JVM:

* Class loader subsys
* mem sys
    + GC heap
    + Native stack
    + Java Stack
    + Method area
* Execution engine

Dynamic Class Loading: access right, scoping property, access right.

Loading: parsing and translate into internal data structure. Format correctness sanity checking.

Casting: upcast is down statically, down-cast is checked dyn

Malicious resource-demanding detection: Turing halting 

Security with binary hashing & pub/priv signing

Method call -- stack inspection, done by security manager.

JIT -- akin binary translation.

OO prog -- frequent use of addressing indirection, use of small methods.

Optimization: Profiling + interpreter/simple-compiler/optimizing-compiler

Howto: code-relayout, methods inlining (trap: virtual methods => profiling, multi-versioning, specialization), On-stack replacement, scalar replacement, null-check motion

Example: Jikes RVM

Whether to compile: cost-benefit analysis, heuristics & experimentally derived parameters.

Jikes three level optimization framework:

* Level 0: conventional, incluing copy/const prop, common-subexpr elim, dead-code elim, branch opt, trivial inlining/relayout ...
* Level 1: More aggressive inlining/relayout based on profile
* Level 2: global optimization based on SSA form, loop unrolling ...


## Co-designed VM
VM tech => General purpose CPU design

Co-design: VM software and host hardware

high-level semantics

IBM Sys/38, IBM Daisy, AS/400, Transmeta Crusoe...


* Source-ISA, visible memory
* Target-ISA, canceled memory

VMM: VM monitor

Code translation methods:

* Context-free translation
* Context-sensitive translation

Register state mapping: guest sys regs + VMM used regs

Memory state mapping: concealed memory (VMM code & data, code cache ..)

VMM control from boot

Memory mapping schemes:

* Shared logical memory space (too large to fit)
* Separated logic memory space
* Concealed memory is real addressing

VMM part: Diskless, no paging, no secondary concealing needed

Issues:

* Self-modifying code: Fine-grained Write-protection methods for source code regions
* I/O to guest code memory: Caught and keep code cache's durability.

Indirect-jump: Probably the greatest source of performance loss in a software-only code cache system.

JTLB: Jump TLB -- Direct mapping from SPC to TPC.

Procedure return jump: Hard to predict => RAS (Return Address Stack), mimics soft-proc-stack => For VM ctx, a Dual-address RAS (DRAS) is used. (like hard-impl of shadow stack)


Precise trap: Hardware Checkpoints => relax restriction on code motion optimization

* Checkpoints are set at every translation block entry point
* When there is a trap, the checkpoint is restored, and interpretation begins at the beginning of the source ode that formed the trapping translation block

Checkpoint -- Gated stores methods

* At commit point, make shadow copy, release gated stores, and establish new gate stores
* On exception, restore from shadow copy, squash gated stores, and establish new gate for stores.

Page fault compatibility

* Active page fault detection
* Lazy ...: When the translated code is actually used?

Flush: page table mapping is modified. Flush both translation block and related side tables.

Guest's mem-mapped IO

VLIW: parallelism

Simplify inst issue logic

* Transmeta Crusoe
    + VLIW = 4 insts
    + Branch unit, FPU, CPU, load/store U
    + IA-32 => RISC like micro-ops => Parallelize and rescheduling
* AS/400
    + New ISA
    + MI: Machine Interface
    * Mem: objects (persistent or temporary)
    * sys vm rather than proc vm



## Sys VM
Src of sys vm: time-sharing

Host platform --shared by--> guest sys VMs, with a layer of software (VMM)

* Multi-processor virtualization
* Shared-memory multi-processors => Memory model => Memory coherence and memory consistency

Outward appearance: Multiple machine illusion; hardware switch; resource subset replication

reg file state maintenance: copying

Resource control: some resource sensitive instructions need special treatment (interval timer etc.); Prevent starvation and unfairness -- Override the req

system mode v.s. user mode

IBM VM/370 -- CP/CMS design -- separation of resource management and service function

Processor: direct native execution + emulation special instruction

S = <E, M, P, R>

* E: Executable image
* M: Mode of operation
* P: PC counter
* R: Memory relocation bounds register

* Privileged instructions: Load PSW / Set CPU Timer
* Sensitive instruction: Control / Behavior
* Critical instruction: Sens - Pri, e.g. `LRA` and `POPF`


VMM: dispatcher + allocator + interpreter routines

True VMM: efficiency, resource control, and equivalence (efficiency is always compromised for the latter two)

Theorem 1: 3rd computer, valid VMM <=> Sens \subst pri

Recursive virtualization: timing dep, resource shrinking

critical instructions => patching => caching the actions

memory's two-level mapping: virtual -> real -> physical, shadow page tables


To virtualize TLB, the VMM maintains a copy of TLB guest's contents and also manages the real TLB => keep copies up-to-date

ASID: Address Space ID, included in TPL entry (Allow TLB to be management-efficient, compared with TLB rewrite)

Difficulty in virtualizing IO devices: a lot of sorts + keep growing

+ Dedicated devices
+ Partitioned devices
+ Spooled devices
+ Nonexistent

I/O => Through instruction `in`, `out`; through sys-call interface; through driver-interface level

VMM-n (native), VMM-u (user), VMM-d (driver)

Emulation assists:

* Ctx switch
* Decoding of priv instructions
* Virtual interval timer
* Adding special instructions to the ISA

Performance improving:

* Non-paged mode
* Pseudo-page-fault handling
* Spool files
* IVC

Para-virtualization: interface

* V=R VM
* Shadow table bypass assist
* Preferred-machine assist
* Segment sharing

IBM's IEF: Support for VM







