VERSION =       7.4.0

STATICLIB =     libimsg.a
SONAME =        libimsg.so
LIBRARY =       libimsg.so.${VERSION}

INSTALL_LIB =   install -m0755
INSTALL_DATA =  install -m0644

DESTDIR =
PREFIX =        /usr
INCLUDEDIR =    ${PREFIX}/include
LIBDIR =        ${PREFIX}/lib
MANDIR =        ${PREFIX}/share/man

SRCS =          src/imsg.c src/imsg-buffer.c
OBJS =          ${SRCS:.c=.o}

TESTSRCS =      imsg_sendrcv ibuf_test
TESTOBJS =      ${TESTSRCS:.c=.test}

all: ${LIBRARY} ${STATICLIB} libimsg.pc

${LIBRARY}: ${OBJS}
	${CC} -shared -o ${LIBRARY} ${OBJS} -Wl,--soname,${SONAME} ${LDFLAGS}

${STATICLIB}: ${OBJS}
	${AR} rcs ${STATICLIB} ${OBJS}

libimsg.pc: libimsg.pc.in
	sed -e "s|@VERSION@|${VERSION}|" \
	    -e "s|@PREFIX@|${PREFIX}|" \
	    -e "s|@LIBDIR@|${LIBDIR}|" \
	    libimsg.pc.in > libimsg.pc

.c.o:
	${CC} -D_XOPEN_SOURCE -D_DEFAULT_SOURCE ${CFLAGS} -fPIC -c $< -o $@

install: all
	mkdir -p ${DESTDIR}${MANDIR}/man3 ${DESTDIR}${INCLUDEDIR} ${DESTDIR}${LIBDIR}/pkgconfig

	${INSTALL_DATA} -t ${DESTDIR}${MANDIR}/man3 man/imsg_init.3
	${INSTALL_DATA} -t ${DESTDIR}${INCLUDEDIR} src/imsg.h
	${INSTALL_DATA} -t ${DESTDIR}${LIBDIR}/pkgconfig libimsg.pc

	${INSTALL_LIB} -t ${DESTDIR}${LIBDIR} ${STATICLIB}
	${INSTALL_LIB} -t ${DESTDIR}${LIBDIR} ${LIBRARY}
	ln -sf ${LIBRARY} ${DESTDIR}${LIBDIR}/${SONAME}

check: test

test: all ${TESTOBJS}

${TESTOBJS}: ${TESTSRCS}
	${CC} ${CFLAGS} -Isrc test/$@.c ${STATICLIB} -o $@
	./$@

clean:
	rm -f ${LIBRARY} ${STATICLIB} ${OBJS} ${TESTOBJS} libimsg.pc

.PHONY: all check clean install test
