# OpenBSD IMSG

This is an unofficial port of OpenBSD's imsg interface to linux.

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

## Modifications

This port is as faithful as possible to the OpenBSD implementation.<br>
The only addition is the [src/_imsg_compat.h](src/imsg_compat.h) header
file which defines static standalone implementations of compat functions.

## Credits

The port has been made possible due to the excellent works of the tmux
team and of course OpenBSD for creating it.

## References

- https://man.openbsd.org/imsg_init.3
