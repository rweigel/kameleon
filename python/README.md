# Overview

A alternantive Python wrapper of the Kameleon Plus library.

(Kameleon Plus)[https://ccmc.gsfc.nasa.gov/Kameleon] includes a Python wrapper that allows only calling its C++ interpolation function with one point. The code here allows one to call the Kameleon C++ interpolation function with an list or Numpy array of points. The typical speed-up is 3x over looping in Python over an array of points.

The Kamodo library also includes a Python wrapper to the Kameleon C++ interpolation library. Interpolation over an array of points is typically 30x slower than that from using this library. See the [test script](https://github.com/GaryQ-physics/magnetosphere/blob/master/misc/kameleon_kamodo_compare/kameleon_version_testScript.py) for a comparison of interpolation speed between the Kamelon and Kamodo Python wrappers.

# Installation and Use

Tested on Python 2.7, 3.{5,6,7,8}

## Using Pip

```
pip install https://github.com/rweigel/kameleonV
```

See (kameleonV_test.py)[https://github.com/rweigel/kameleonV/kameleonV/kameleonV_test.py] for usage examples.

## Without Pip

```
git clone https://github.com/rweigel/kameleonV
pip install numpy
cd kameleonV
python kameleonV_test.py
```

# Compiling

## Step 1

```
cd /tmp
git clone https://github.com/rweigel/kameleon
```
Then read `kameleon/README.md` for instructions on dependencies

## Step 2

```
git clone https://github.com/rweigel/swig-and-ctypes
sudo apt install swig
cd swig-and-ctypes
make KAMELEON_DIR=/tmp
```

# Notes

SWIG was used, but perhaps this is easier donw with ctypes as described on (StackOverflow)[https://stackoverflow.com/questions/5862915/passing-numpy-arrays-to-a-c-function-for-input-and-output]

See the end of the Makefile for a description of why using the binary libraries from https://ccmc.gsfc.nasa.gov/Kameleon/Quick_start.html does not work.

# TODO:

1. Add function for field line tracing
2. `libccmc.so` (created by Step 1 in Compiling section above) depends on libhdf5 and libpython2.7. These libraries are not needed. 
3. Compile on OS-X
