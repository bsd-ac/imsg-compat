# OpenBSD IMSG

This is an unofficial port of OpenBSD's imsg[1] interface to linux.

## Installation

The port has been tested to compile and install with GCC 9.3.0 and
Clang 11.0.0, with both GNU Make and BSD Make.

```
make
make test
make install
man imsg_init
```

PS: This port requires *<sys/queue.h>*

## Credits

The port has been made possible due to the excellent works of the tmux
team and of course OpenBSD for creating it.

## References

[1] https://man.openbsd.org/imsg_init.3
