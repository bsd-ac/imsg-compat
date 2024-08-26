project('imsg-compat', 'c',
	version: '8.0.0',
	license: 'ISC',
	default_options: [
		'warning_level=3',
	]
)

compiler = meson.get_compiler('c')

have_getdtablecount = compiler.has_function('getdtablecount')
have_recallocarray = compiler.has_function('recallocarray')

proc_environ = run_command('/bin/sh', '-c', 'cat /proc/self/environ', check: false)
have_proc_pid = proc_environ.returncode() == 0

message(
	'Checking for /proc mount:',
	have_proc_pid ? 'yes' : 'no',
)

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
