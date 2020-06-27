# Installation

Tested on Lubuntu 19.10

Based on https://ccmc.gsfc.nasa.gov/downloads/kameleon_instructions/html/Quick_start.html

See also https://ccmc.gsfc.nasa.gov/Kameleon/

```
sudo apt-get install gfortran
sudo apt-get install cmake
sudo apt-get install python-dev
sudo apt-get install libboost-all-dev
sudo apt-get install libhdf5-dev
sudo apt-get install swig
```

From this directory

```
git clone https://github.com/ccmc/ccmc-software.git
git checkout 0e2fb90add626f185b0b71cdb9a7b8b3b5c43266 # Version Makefile tested on
make
```
