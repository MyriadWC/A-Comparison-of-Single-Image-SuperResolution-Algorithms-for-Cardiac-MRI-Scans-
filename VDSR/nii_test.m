%Contains 20 3mm resolution 3D MRI scans
I = niftiread('RA.nii');

imshow(I(:,:,25), []);