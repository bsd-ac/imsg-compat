project('imsg-compat', 'c',
	version: '8.0.0',
	license: 'ISC',
	default_options: [
		'warning_level=3',
	]
)

compiler = meson.get_compiler('c')

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

proc_environ = run_command('/bin/sh', '-c', 'cat /proc/self/environ', check: false)
have_proc_pid = proc_environ.returncode() == 0
message(
	'Checking for /proc mount:',
	have_proc_pid ? 'yes' : 'no',
)
if have_proc_pid
	add_project_arguments('-DHAVE_PROC_PID', language: 'c')
endif

incdir = 'src'
srcdir = 'src'

headers = [
	srcdir + '/imsg.h',
]

sources = [
	srcdir + '/imsg.c',
	srcdir + '/imsg-buffer.c',
]

libimsg = both_libraries('imsg', sources: sources, include_directories: incdir, install: true)

tests = [
	'test/ibuf_test.c',
	'test/imsg_sendrcv.c',
]

foreach test: tests
	binary = test.split('.')[0].split('/')[1]
	btest = executable(binary, test, include_directories: incdir, link_with: libimsg)
	test(binary, btest)
endforeach
