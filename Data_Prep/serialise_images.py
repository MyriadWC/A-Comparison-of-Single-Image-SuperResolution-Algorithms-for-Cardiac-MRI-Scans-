import os
import re

#Sometimes this code creates an empty file that is hidden in finder, you have to search it 
#in the terminal and remove it. i.e. rm hr0000.bmp

"""
Formatted like this:
hr0000
hr0001
hr0002
hr0003...

This way an alphabetic sort will order them numerically
"""

path = './hr'

files = os.listdir(path)
files.sort(key=lambda var:[int(x) if x.isdigit() else x for x in re.findall(r'[^0-9]|[0-9]+', var)])

for i, file in enumerate(files):
    os.rename(os.path.join(path, file), os.path.join(path, ''.join(['hr'+"{:0>4}".format(str(i+1)), '.bmp']))) 