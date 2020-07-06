# Tested on Lubuntu 18.04
#
# To compile and run code, you need libcdf.so and libccmc.so.6.1.0.0
# compiled using http://github.com/rweigel/kameleon and
#
# SWIG is also needed. Install using
#   sudo apt install swig
# 
# After editing the variables CDF_LIB, CDF_SO, and PYTHON_INCLUDE in this Makefile execute
#   make

RELEASE=kameleonV-0.2.0

KAMELEON_ROOT=$(CURDIR)/../ccmc-software/kameleon-plus/trunk/kameleon-plus-working
KAMELEON_INCLUDE=$(KAMELEON_ROOT)/src
KAMELEON_LIB=$(KAMELEON_ROOT)/lib/ccmc
KAMELEON_SO=$(KAMELEON_LIB)/libccmc.so.6.1.0.0

CDF_DIR=$(CURDIR)/../$(KAMELEON_DIR)/deps/cdf36_4-dist
CDF_LIB=${CDF_DIR}/src/lib
CDF_SO=$(CDF_LIB)/libcdf.so

CONDA=/home/user/miniconda3
CONDA_ACTIVATE=source $(CONDA)/etc/profile.d/conda.sh; conda activate

SHELL=/bin/bash
TMPDIR=/tmp

TESTURL=http://mag.gmu.edu/git-data/bcurtiswx/Differences/data/Sean_Blake_081318_1/GM_CDF/
TESTFILE=3d__var_1_e20120723-120000-000.out.cdf

PYTHON_VER=3.7
PYTHON=python
# Determine name of output .so file
ifeq ($(PYTHON_VER),2.7)
	OUT_SO_FILE=_kameleon.so
	OUT_SO=build/lib.linux-x86_64-2.7/$(OUT_SO_FILE)
else
#	Remove dot in PYTHON_VER
	V=$(subst .,,$(PYTHON_VER))m
	ifeq ($(PYTHON_VER),3.8)
		V=$(subst .,,$(PYTHON_VER))
#	What determines if m appears after version, e.g.,
#	 _kameleon.cpython-3.7m-... vs _kameleon.cpython-3.8m?
	endif
	OUT_SO_FILE=_kameleon.cpython-$(V)-x86_64-linux-gnu.so
	OUT_SO=build/lib.linux-x86_64-$(PYTHON_VER)/$(OUT_SO_FILE)
endif


# TODO: Use loop over Python versions
all:
	make test_so PYTHON_VER=2.7
	make test_so PYTHON_VER=3.5
	make test_so PYTHON_VER=3.6
	make test_so PYTHON_VER=3.7
	make test_so PYTHON_VER=3.8
	make release
	make test_release PYTHON_VER=2.7
	make test_release PYTHON_VER=3.5
	make test_release PYTHON_VER=3.6
	make test_release PYTHON_VER=3.7
	make test_release PYTHON_VER=3.8
#	make kameleon_cl

test:
	make test_so PYTHON_VER=$(PYTHON_VER)
#	make test_cl

testfile:
	make $(TMPDIR)/$(TESTFILE)

$(TMPDIR)/$(TESTFILE):
	- cd $(TMPDIR); wget -N $(TESTURL)$(TESTFILE)

test_so: $(OUT_SO_FILE) kameleonV_test.py
	make testfile
	$(CONDA_ACTIVATE) $(PYTHON_VER); $(PYTHON) kameleonV_test.py

patchelf:
	make /usr/bin/patchelf

/usr/bin/patchelf:
	sudo apt install patchelf

out_so:
	make $(OUT_SO_FILE)

$(OUT_SO_FILE): kameleon_so.cpp kameleon.h kameleon.i $(KAMELEON) $(CONDA)/envs/$(PYTHON_VER)
	make patchelf
	$(CONDA_ACTIVATE) $(PYTHON_VER); \
	$(PYTHON) setup.py build_ext --swig-opts=-c++ \
		-lccmc \
		-L${KAMELEON_LIB} -I${KAMELEON_INCLUDE}
	./relativize_libs.sh $(KAMELEON_SO) lib/
	cp $(KAMELEON_SO) lib/
	./relativize_libs.sh $(OUT_SO) lib/
	cp $(OUT_SO) .
	patchelf --set-rpath "\$$ORIGIN/lib" $(OUT_SO_FILE)
	cd lib/; ls -1 | xargs -i ../relativize_libs.sh {} .
	cd lib/; ls -1 | xargs -i patchelf --set-rpath "\$$ORIGIN/" {}
	chmod 644 _*.so
	chmod 644 lib/*.so*

x:
	- mkdir -p lib/
	cp $(CDF_SO) lib/
	- cp $(KAMELEON_SO).orig $(KAMELEON_SO)
	cp $(KAMELEON_SO) $(KAMELEON_SO).orig

	patchelf --set-rpath "\$$ORIGIN/lib" $(OUT_SO)

	patchelf --set-rpath "\$$ORIGIN/." lib/libccmc.so.6.1.0.0
	chmod 644 _*.so
	chmod 644 lib/*.so

$(CONDA):
	echo ""
	echo ""
	echo "Select y for all questions"
	echo ""
	echo ""
	cd /tmp; wget \
		https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	cd /tmp; bash Miniconda3-latest-Linux-x86_64.sh

$(CONDA)/envs/$(PYTHON_VER): $(CONDA)
	$(CONDA_ACTIVATE); \
		$(CONDA)/bin/conda create -y --name $(PYTHON_VER) python=$(PYTHON_VER) numpy

kameleon_cl: kameleon_cl.cpp $(KAMELEON_INCLUDE)
	g++ kameleon_cl.cpp -Wno-deprecated -o kameleon_cl \
		-I${KAMELEON_INCLUDE} \
		-L$(KAMELEON_LIB) \
		-lccmc \
		-I$(PYTHON_INCLUDE) \
		-lboost_system -lboost_python -lpython2.7
# Last two lines above needed for Boost's wrap_python.hpp (based on error message without it)

test_cl: kameleon_cl
	make testfile
	LD_LIBRARY_PATH=$(KAMELEON_LIB) ./kameleon_cl $(TESTFILE) 1000000

test_release:
	cd release/$(RELEASE); \
		$(CONDA_ACTIVATE) $(PYTHON_VER); $(PYTHON) kameleonV_test.py

release:
	echo $(RELEASE)
	mkdir -p release
	make $(RELEASE)

$(RELEASE): _*.so release/
	- mkdir -p release/$(RELEASE)
	cp kameleonV_test.py kameleonV.py _*.so release/$(RELEASE)
	cp -r lib release/$(RELEASE)
	cd release; tar zcvf $(RELEASE).tgz $(RELEASE)

clean:
	-@rm -rf build/
	-@rm -rf *.so
	-@rm -f kameleon_wrap.cpp
	-@rm -f kameleon.py
	-@rm -f kameleon_cl
	-@rm -f *.pyc
	-@rm -f *~
	-@rm -rf __pycache__/

distclean:
	make clean
	-@rm -f *.so
	-@rm -rf lib/
	- rm -f $(TMPDIR)/3d__var_3_e20031120-070000-000.out.cdf

######################################################################
# Failed attempts at using libraries and header files from a previously
# installed Kameleon package from
# https://ccmc.gsfc.nasa.gov/Kameleon/Quick_start.html instead of
######################################################################
X_KAMELEON=/home/osboxes/kameleon
X_KAMELEON_INCLUDE=$(X_KAMELEON)/include
X_KAMELEON_LIB=$(X_KAMELEON)/lib/ccmc
X_KAMELEON_SO=$(X_KAMELEON_LIB)/libccmc.so.6.1.0.0

# Compiles but execution of test python script fails with error:
#Traceback (most recent call last):
#  File "kameleonA_test.py", line 1, in <module>
#    import _kameleon as kameleon
#ImportError: /home/osboxes/git/swig-and-ctypes/swig/kameleon/_kameleon.so: undefined symbol: _ZN4ccmc8Kameleon12loadVariableERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
# Adding flag -lboost_filesystem
# gives undefined symbol associated with doesVariablExist

# I suspect this is due to a mis-match between the boost linked
# against in the previously installed Kameleon package (1.59.0) and
# the boost installed by apt-get (1.67.0 for Lubuntu 18.04). If so,
# the fix is to compile and link to boost 1.59.0 (which take a very
# long time)
x_kameleon.so: kameleon_so.cpp kameleon.h kameleon.i $(X_KAMELEON)
	make clean
	$(PYTHON) setup.py build_ext --swig-opts=-c++ -lccmc \
		-L${X_KAMELEON_LIB} -I${X_KAMELEON_INCLUDE}
	ldd $(OUT_SO)
	mkdir -p lib/
	- cp $(X_KAMELEON_SO).orig $(X_KAMELEON_SO)
	cp $(X_KAMELEON_SO) $(X_KAMELEON_SO).orig
	./relativize_libs.sh $(X_KAMELEON_SO)
	patchelf --set-rpath "\$$ORIGIN/lib" $(OUT_SO)
	cp $(OUT_SO) .
	ldd _*.so
	chmod 644 _*.so
	chmod 644 lib/*.so
	make testfile
	$(PYTHON) kameleonV_test.py
