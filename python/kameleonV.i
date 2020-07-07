%module kameleonV
%{
#include "kameleonV.h"
%}

%include "std_vector.i"

%template(FloatVector) std::vector<float>;

%include "kameleonV.h"
