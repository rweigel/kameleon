import os
import sys
import time

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
import kameleonV

var = 'bx'
print("---------------------------------------------------------------------------")
print("Testing kameleonV in Python " + sys.version.replace("\n", ""))
print("---------------------------------------------------------------------------")

fname = '3d__var_1_e20120723-120000-000.out.cdf'
fpath = '/tmp/' + fname
if not os.path.exists(fpath):
    url = 'http://mag.gmu.edu/git-data/bcurtiswx/Differences/data/'
    url = url + 'Sean_Blake_081318_1/GM_CDF/'
    print('Downloading ' + fname)
    os.system('cd /tmp; wget ' + url + fname)

x = [1., 2.]
y = [1., 2.]
z = [1., 2.]
x1 = kameleonV.interpolate(fpath, x, y, z, var)

if var == 'p':
    xt = [0.009664899669587612, 0.44393426179885864]
    try:
        import numpy as np
    except:
        print("Numpy not found. Not performing Numpy test.")
        assert(x1 == xt)
        print('\033[92m' + "PASS" + '\033[0m')
        print("------------------------------------------------------------------------")
        sys.exit(0)

if var == 'bx':
    xt = [-5317.56005859375, -659.572265625]
    try:
        import numpy as np
    except:
        print("Numpy not found. Not performing Numpy test.")
        assert(x1 == xt)
        print('\033[92m' + "PASS" + '\033[0m')
        print("------------------------------------------------------------------------")
        sys.exit(0)

x = np.array(x)
y = np.array(y)
z = np.array(z)
x2 = kameleonV.interpolate(fpath, x, y, z, var)

assert(np.all(np.array(x1) == x2) and np.all(x2 == np.array(xt)))

print('\033[92m' + "PASS" + '\033[0m')
print("----------------------------------------------------------------------------")

if False:
    points = np.linspace(2,10,999999).reshape((-1,3))
    
    to = time.time()
    x3 = kameleonV.interpolate(fpath, points[:,0], points[:,1], points[:,2], 'p')
    tf = time.time()
    print('{0:d} points in {1:.1f} s = {2:.1f} pts/s\n' \
          .format(points.shape[0], tf-to, points.shape[0]/(tf-to)))
