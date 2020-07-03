from distutils.core import *
from distutils      import sysconfig

_kameleon = Extension("_kameleon", ["kameleon.i","kameleon_so.cpp"])

_DEBUG = False
_DEBUG_LEVEL = 0

# Common flags for both release and debug builds.
extra_compile_args = sysconfig.get_config_var('CFLAGS').split()
extra_compile_args += ["-std=c++11", "-Wall", "-Wextra"]
if _DEBUG:
    extra_compile_args += ["-g3", "-O0", "-DDEBUG=%s" % _DEBUG_LEVEL, "-UNDEBUG"]
else:
    extra_compile_args += ["-DNDEBUG", "-O3", "-w"]

extra_compile_args = ' '.join(extra_compile_args)
os.environ['CFLAGS'] = extra_compile_args

setup(  name        = "kameleonV",
        description = "",
        author      = "R.S. Weigel",
        version     = "0.0.1",
        ext_modules = [_kameleon]
        )


    
