VERSION ?=      6.8.0

STATICLIB ?=    libimsg.a
SONAME ?=       libimsg.so
LIBRARY ?=      libimsg.so.${VERSION}

DESTDIR ?=
PREFIX ?=       /usr
INCLUDEDIR ?=   ${PREFIX}/include
LIBDIR ?=       ${PREFIX}/lib
MANDIR ?=       ${PREFIX}/share/man

SRCS =          src/imsg.c src/imsg-buffer.c
OBJS =          ${SRCS:.c=.o}

TESTSRCS =      test/imsg_sendrcv.c
TESTOBJS =      ${TESTSRCS:.c=.test}

all: ${LIBRARY} ${STATICLIB}

${LIBRARY}: ${OBJS}
	${CC} -shared -o ${LIBRARY} ${OBJS} -Wl,--soname,${SONAME}

${STATICLIB}: ${OBJS}
	${AR} rcs ${STATICLIB} ${OBJS}

.c.o:
	${CC} -D_XOPEN_SOURCE -D_DEFAULT_SOURCE ${CFLAGS} -fPIC -c $< -o $@

install: all
	mkdir -p ${DESTDIR}${MANDIR}/man3 ${DESTDIR}${INCLUDEDIR} ${DESTDIR}${LIBDIR}
	install -t ${DESTDIR}${MANDIR}/man3 man/imsg_init.3
	install -t ${DESTDIR}${INCLUDEDIR} src/imsg.h
	install -t ${DESTDIR}${LIBDIR} ${LIBRARY}
	ln -sf ${LIBRARY} ${DESTDIR}/${SONAME}
	install -t ${DESTDIR}${LIBDIR} ${STATICLIB}

check: test

test: all ${TESTOBJS}

${TESTOBJS}: ${TESTSRCS}
	${CC} ${CFLAGS} -Isrc -static $< -o $@ -L. -limsg
	./$@

clean:
	rm -f ${LIBRARY} ${STATICLIB} ${OBJS} ${TESTOBJS}

.PHONY: all check clean install test
