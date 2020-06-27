KAMELEON_DIR=$(CURDIR)/ccmc-software/kameleon-plus/trunk/kameleon-plus-working

CDF_DIR=$(CURDIR)/deps/cdf36_4-dist
CDF_TGZ=cdf36_4-dist-all.tar.gz
CDF_LIB=${CDF_DIR}/src/lib/libcdf.so
CDF_INCLUDES=${CDF_DIR}/src/include

BOOST_TGZ=boost_1_54_0.tar.gz
BOOST_ROOT=$(CURDIR)/deps/boost_1_54_0

kameleon: ${CDF_LIB} ${BOOST_ROOT}
	- mkdir kameleon-plus-build
	cd kameleon-plus-build; \
		cmake -DBOOST_ROOT=${BOOST_ROOT} \
			-DCDF_LIB=${CDF_LIB} -DCDF_INCLUDES=${CDF_INCLUDES} \
			${KAMELEON_DIR}
	cd kameleon-plus-build/; make -j6 all
	cd ccmc-software/kameleon-plus/trunk; find . -name "*.so"

boost:
	make ${BOOST_ROOT}

${BOOST_ROOT}:
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
	- rm -rf ccmc-software
	- rm -rf kameleon-plus-build
