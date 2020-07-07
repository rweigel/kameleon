KAMELEON_DIR=$(CURDIR)/ccmc-software/kameleon-plus/trunk/kameleon-plus-working

CDF_DIR=$(CURDIR)/deps/cdf36_4-dist
CDF_TGZ=cdf36_4-dist-all.tar.gz
CDF_LIB=${CDF_DIR}/src/lib/libcdf.so
CDF_INCLUDES=${CDF_DIR}/src/include

# This should match boost version installed by apt, but has worked with 1.64 installed
# by apt.
BOOST_URL=http://sourceforge.net/projects/boost/files/boost/1.67.0/boost_1_67_0.tar.gz
BOOST_TGZ=boost_1_67_0.tar.gz
BOOST_ROOT=$(CURDIR)/deps/boost_1_67_0

all:
	make deps
	make kameleon

deps:
	sudo apt install -y gfortran cmake python-dev libboost-all-dev swig

kameleon: ${CDF_LIB} ${BOOST_ROOT} $(CURDIR)/ccmc-software
	- mkdir kameleon-plus-build
	cd kameleon-plus-build; \
		cmake -DBOOST_ROOT=${BOOST_ROOT} \
			-DCDF_LIB=${CDF_LIB} -DCDF_INCLUDES=${CDF_INCLUDES} \
			-DBUILD_JAVA=OFF \
			-DINSTALL_CCMC_PYTHON_MODULE=OFF \
			-DBUILD_HDF5=OFF \
			${KAMELEON_DIR}
	cd kameleon-plus-build/; make -j6 all
	cd ccmc-software/kameleon-plus/trunk; find . -name "*.so"

ccmc-software:
	make $(CURDIR)/ccmc-software

$(CURDIR)/ccmc-software:
	git clone https://github.com/ccmc/ccmc-software.git
# 	Checkout version Makefile tested on
	cd ccmc-software; \
		git checkout 0e2fb90add626f185b0b71cdb9a7b8b3b5c43266
# 	Suppress stdout of "Kameleon::close() calling model's close"
	cp patch/Kameleon.cpp \
		./ccmc-software/kameleon-plus/trunk/kameleon-plus-working/src/ccmc

boost:
	make ${BOOST_ROOT}

${BOOST_ROOT}:
	cd deps; wget -q -N $(BOOST_URL)
	cd deps; tar zxvf ${BOOST_TGZ}

cdf:
	make ${CDF_LIB}

${CDF_LIB}: ${CDF_DIR}
	cd ${CDF_DIR}; make -j4 OS=linux ENV=gnu CURSES=no all

${CDF_DIR}:
	cd deps; tar zxvf ${CDF_TGZ}

clean:
	- rm -f *~

distclean:
	make clean
	- rm -rf ${CDF_DIR}
	- rm -rf ${BOOST_ROOT}
	- rm -rf deps/${BOOST_TGZ}
	- rm -rf ccmc-software
	- rm -rf kameleon-plus-build
