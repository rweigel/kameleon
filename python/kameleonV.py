import _kameleon as kameleon

def interpolate(fname, x, y, z, var):

    assert(len(x) == len(y) == len(z))
    assert(type(x) == type(y) == type(z))
    assert(type(var) == str)
    
    return_array = False
    if type(x) is not list:
        try:
            import numpy as np 
            if isinstance(x, np.ndarray):
                return_array = True
        except:
            raise(ValueError, "x, y, and z must be of type list or numpy.array")
                
    #x = kameleon.runner(fname, x, y, z, len(x), var)
    x = kameleon.runner(fname, x, y, z, len(x))

    if return_array:
        return np.array(x)
    else:
        return list(x) # kameleon.runner returns tuple
    
