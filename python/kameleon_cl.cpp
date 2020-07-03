#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <ccmc/Kameleon.h>
#include <ccmc/FileReader.h>

int main (int argc, char * argv[]) {

  ccmc::Kameleon kameleon1;

  std::string filename1input;
  filename1input = argv[1];
  int N = atoi(argv[2]);

  clock_t start = clock();

  std::vector<float> value1(N,0);

  long status1 = kameleon1.open(filename1input);

  if (status1 != ccmc::FileReader::OK) {
    std::cout << "Could not open " << filename1input << " Exiting with code 1." << std::endl;
    return 1;
  }
  std::cout << filename1input << ": Opened." << std::endl;

  std::cout << filename1input << ": Loading variable started." << std::endl;
  if (kameleon1.doesVariableExist("p")){
    kameleon1.loadVariable("p");
  } else {
    std::cout << "Variable does not exist. Exiting with code 1.";
    return 1;
  }
  std::cout << filename1input << ": Loading variable finished." << std::endl;

  ccmc::Interpolator * interpolator1 = kameleon1.createNewInterpolator();

  std::cout << filename1input << ": Interpolation started." << std::endl;

  for (int k = 0; k < N; k++)
    {
      //value1(k,0) = interpolator1->interpolate("p",  1.0, 1.0, 1.0);
      value1[k] = interpolator1->interpolate("p",  1.0, 1.0, 1.0);
    }
  std::cout << filename1input << ": Interpolation finished." << std::endl;
  
  //std::cout << (value1(0,0)) << std::endl;
  double duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
  std::cout << "Interpolation took " << (duration) << " s" << std::endl;

  //value1.clear();
  delete interpolator1;
  kameleon1.close();

  return 0;
  
}
