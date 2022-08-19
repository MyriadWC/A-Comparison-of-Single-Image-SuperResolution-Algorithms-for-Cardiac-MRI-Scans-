import h5py
filename = './models/200e/g.h5'
h5 = h5py.File(filename, 'r')
#layer_names = [n.decode('utf-8') for n in h5.attrs['layer_names']]
layer_names = h5.attrs['layer_names']

print(layer_names)