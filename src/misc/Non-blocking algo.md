# Non-blocking algorithm

Non-blocking: Failure of suspension of any thread cannot cause failure of another thread.

Two categories

* Lock-free: Guaranteed sys-wide progress
* Wait-free: Guaranteed per-thread progress

Implementation:

* atomic R/M/W pritives, like CAS
* Software transactional memory

simple DS: SRSW Ring FIFO

The `lock` is not necessarily the mutex, but the possibility to lock the whole system up

Sequential Consistency: all threads agree on the order in which memory operations occurred, and that order is consistent with the order of operations in the program source code.


C++ atomic types guarantee sequential consistency.

If on multi-core, and no sequential consistency guarantee, mem reordering should be considered.

* Lightweight sync or fence instruction
* Full memory fence instruction
* Memory ops with acquire and release semantics


