#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <ccmc/Kameleon.h>
#include <ccmc/FileReader.h>

//std::vector<float> runner (char* filename, std::vector<float> x, std::vector<float> y, std::vector<float> z, int N, std::string variable) {
std::vector<float> runner (char* filename, std::vector<float> x, std::vector<float> y, std::vector<float> z, int N) {

  clock_t start = clock();

  int debug = 0;

  ccmc::Kameleon kameleon1;

  long status1 = kameleon1.open(filename);

  if (status1 != ccmc::FileReader::OK) {
    std::cout << "Could not open " << filename << std::endl;
    return x;
  }
  if (debug == 1) {
    std::cout << filename << ": Opened." << std::endl;
    std::cout << filename << ": Loading variable started." << std::endl;
  }

  if (kameleon1.doesVariableExist("p")){
    kameleon1.loadVariable("p");
  } else {
    std::cout << "Variable " << "p" << " does not exist in " << filename << std::endl;
    return x;
  }
  if (debug == 1) {
    std::cout << filename << ": Loading variable finished." << std::endl;
  }

  ccmc::Interpolator * interpolator1 = kameleon1.createNewInterpolator();

  if (debug == 1) {  
    std::cout << filename << ": Interpolation started." << std::endl;
  }

  for (int k = 0; k < N; k++) {
    x[k] = interpolator1->interpolate("p",  x[k], y[k], z[k]);
  }

  if (debug == 1) {
    std::cout << filename << ": Interpolation finished." << std::endl;
  }

  double duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;  
  if (debug == 1) {
    std::cout << "Interpolation took " << (duration) << " s" << std::endl;
  }

  delete interpolator1;
  kameleon1.close();

  return x;
  
}
