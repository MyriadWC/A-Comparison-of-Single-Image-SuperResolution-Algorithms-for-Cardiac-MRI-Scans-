import os
import argparse
import cv2

hr_image_dir = "MRI_SLICES_2_3L/MRI_SLICE_TRAIN_HR_CROPPED_0.7"

sf = 0.25 #downsampling scale factor
lr_image_dir = "MRI_SLICES_2_3L/MRI_SLICE_TRAIN_LR_BICUBIC/" + str(1/sf) + "x/"
os.makedirs(lr_image_dir, exist_ok=True)

supported_img_formats = (".bmp", ".jpeg", ".jpg", ".png", ".tif", ".tiff")

# Downsample HR images
for filename in os.listdir(hr_image_dir):
    if not filename.endswith(supported_img_formats):
        continue

    # Read HR image
    hr_img = cv2.imread(os.path.join(hr_image_dir, filename))
    hr_img_dims = (hr_img.shape[1], hr_img.shape[0])

    #bicubic downsampling
    #lr_img = cv2.resize(hr_img, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
    lr_bic_downsampled = cv2.resize(hr_img, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
    #lr_median_blur = cv2.resize(hr_median_blur, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
    #lr_gaussian_blur = cv2.resize(hr_gaussian_blur, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)
    #lr_bilateral_filtered = cv2.resize(hr_bliateral_filtered, (0, 0), fx=sf, fy=sf, interpolation=cv2.INTER_CUBIC)

    cv2.imwrite(os.path.join(lr_image_dir, "bicubic_" + filename), lr_bic_downsampled)

