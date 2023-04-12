# for python 2 compatibility #
from __future__ import print_function
#                            #
import numpy as np
from skimage import io
import matplotlib.pyplot as plt
# %matplotlib inline

f = io.imread('ImageULike.gif')   # read in image
f_f = np.array(f, dtype=float)
z = np.fft.fft2(f_f)           # do fourier transform
q = np.fft.fftshift(z)         # puts u=0,v=0 in the centre
Magq =  np.absolute(q)         # magnitude spectrum
Phaseq = np.angle(q)           # phase spectrum

fig1 = plt.figure()
ax1  = fig1.add_subplot( 111 )
ax1.axis('off')
# Usually for viewing purposes:
ax1.imshow( np.log( np.absolute(q) + 1 ), cmap='gray' ) # io.

w = np.fft.ifft2( np.fft.ifftshift(q) ) # do inverse fourier transform
#
fig2 = plt.figure()
ax2  = fig2.add_subplot( 111 )
ax2.axis('off')
ax2.imshow( np.array(w,dtype=int), cmap='gray' ) # io.

plt.show()
