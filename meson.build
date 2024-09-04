project('imsg-compat', 'c',
	version: '8.0.0',
	license: 'ISC',
	default_options: [
		'warning_level=3',
	]
)

compiler = meson.get_compiler('c')
add_project_arguments('-Wno-unused-function', language: 'c')

have_getdtablecount = compiler.has_function('getdtablecount')
if have_getdtablecount
	add_project_arguments('-DHAVE_GETDTABLECOUNT', language: 'c')
endif

have_recallocarray = compiler.has_function('recallocarray')
if have_recallocarray
	add_project_arguments('-DHAVE_RECALLOCARRAY', language: 'c')
endif

have_freezero = compiler.has_function('freezero')
if have_freezero
	add_project_arguments('-DHAVE_FREEZERO', language: 'c')
endif

have_bits_uio_lim_h = compiler.has_header('bits/uio_lim.h')
if have_bits_uio_lim_h
	add_project_arguments('-DHAVE_BITS_UIO_LIM_H', language: 'c')
endif

have_proc_pid = false
sh = find_program('sh')
if sh.found()
	proc_environ = run_command(sh, '-c', 'cat /proc/self/environ', check: false)
	have_proc_pid = proc_environ.returncode() == 0
endif
message(
	'Checking for /proc mount:',
	have_proc_pid ? 'YES' : 'NO',
)
if have_proc_pid
	add_project_arguments('-DHAVE_PROC_PID', language: 'c')
endif

incdir = 'src'
srcdir = 'src'

headers = [
	srcdir + '/imsg.h',
]

install_headers(headers)

man_pages = [
	'man/imsg_init.3',
	'man/ibuf_add.3',
]

install_man(man_pages)

sources = [
	srcdir + '/imsg.c',
	srcdir + '/imsg-buffer.c',
]

libimsg = both_libraries('imsg', sources: sources, include_directories: incdir, install: true)
pkgconfig = import('pkgconfig')
pkgconfig.generate(libimsg, version: meson.project_version(), name: 'libimsg', description: 'Unofficial OpenBSD imsg port', libraries: libimsg)

tests = [
	'test/ibuf_test.c',
	'test/imsg_sendrcv.c',
]

foreach test: tests
	binary = test.split('.')[0].split('/')[1]
	btest = executable(binary, test, include_directories: incdir, link_with: libimsg)
	test(binary, btest)
endforeach
