%module kameleon
%{
#include "kameleon.h"
%}

%include "std_vector.i"

%template(FloatVector) std::vector<float>;

%include "kameleon.h"
