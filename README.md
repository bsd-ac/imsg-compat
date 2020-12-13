# OpenBSD IMSG
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/bsd-ac/imsg-compat?include_prereleases)](https://github.com/bsd-ac/imsg-compat/releases) [![GitHub license](https://img.shields.io/github/license/bsd-ac/imsg-compat.svg)](https://github.com/bsd-ac/imsg-compat/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues-raw/bsd-ac/imsg-compat)](https://github.com/bsd-ac/imsg-compat/issues) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/bsd-ac/imsg-compat/issues)

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

PS: This port requires *<sys/queue.h>* and if using glibc, then >=2.25.0,
for the `explicit_bzero` function.

## Usage

This port creates both a shared library `libimsg.so` and a static library
`libimsg.a`. To use them, just link with `-limsg`.

## Modifications

This port is as faithful as possible to the OpenBSD implementation.<br>
The only addition is the [src/_imsg_compat.h](src/_imsg_compat.h) header
file which defines static standalone implementations of compat functions.

## Credits

The port has been made possible due to the excellent works of the tmux
team and of course OpenBSD for creating it.

## References

- https://man.openbsd.org/imsg_init.3
