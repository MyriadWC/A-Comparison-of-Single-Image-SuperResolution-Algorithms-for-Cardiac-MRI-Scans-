import os
import argparse
import cv2

hr_image_dir = "./Testing Images/axial_full_pat17_HR_CROPPED"

sf = 0.25 #downsampling scale factor
lr_image_dir = "./Testing Images/axial_full_pat17_LR_CROPPED/" + str(1/sf) + "x/"
os.makedirs(lr_image_dir, exist_ok=True)

supported_img_formats = (".bmp", ".jpeg", ".jpg", ".png", ".tif", ".tiff")

# Downsample HR images
for filename in os.listdir(hr_image_dir):
	if filename.startswith("."):
		continue

    # Read HR image
	hr_img = cv2.imread(os.path.join(hr_image_dir, filename))
	#hr_img_dims = (hr_img.shape[1], hr_img.shape[0])

	#Blur with averaging box filter. Takes average of all pixels in kernel and replaces middle pixel
	#hr_averaging_blur = cv2.blur(hr_img, (8,8))
	#Blur with median blurring. Takes median of all pixels in kernel and replaces middle pixel
	#hr_median_blur = cv2.medianBlur(hr_img, 3)

	# Blur with Gaussian kernel of width sigma=1. Takes gaussian weighted average in space and replaces middle pixel
	#hr_gaussian_blur = cv2.GaussianBlur(hr_img, (0, 0), 1, 1)

	# Blur with Bilateral filtering kernel of width sigma=1. Takes gaussian weighted average in space and in pixel difference, so only nearby pixels with similar intensity are blurred.
	#This reduces the blurring of edges seen in gaussian blurring
	#hr_bliateral_filtered = cv2.bilateralFilter(hr_img, 9, 75, 75)

	#bicubic downsampling
	lr_img = cv2.resize(hr_img, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
	#lr_averaging_blur = cv2.resize(hr_averaging_blur, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
	#lr_median_blur = cv2.resize(hr_median_blur, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
	#lr_gaussian_blur = cv2.resize(hr_gaussian_blur, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
	#lr_bilateral_filtered = cv2.resize(hr_bliateral_filtered, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)

	cv2.imwrite(os.path.join(lr_image_dir, filename), lr_img)

