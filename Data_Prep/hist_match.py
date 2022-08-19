import cv2
import numpy as np
import os

#Found at: https://automaticaddison.com/how-to-do-histogram-matching-using-opencv/
# Core functionality written by automaticaddison

unmatched_dir    = 'MRI_SLICE_TRAIN_HR_CROPPED_0.7_3layers/'
matched_dir      = 'MRI_SLICE_TRAIN_HR_MATCHED_3layers/'
ref_img_path = "./lian_data_reference.png"

os.makedirs(matched_dir, exist_ok=True)

def calculate_cdf(histogram):
    """
    This method calculates the cumulative distribution function
    :param array histogram: The values of the histogram
    :return: normalized_cdf: The normalized cumulative distribution function
    :rtype: array
    """
    # Get the cumulative sum of the elements
    cdf = histogram.cumsum()
 
    # Normalize the cdf
    normalized_cdf = cdf / float(cdf.max())
 
    return normalized_cdf
 
def calculate_lookup(src_cdf, ref_cdf):
    """
    This method creates the lookup table
    :param array src_cdf: The cdf for the source image
    :param array ref_cdf: The cdf for the reference image
    :return: lookup_table: The lookup table
    :rtype: array
    """
    lookup_table = np.zeros(256)
    lookup_val = 0
    for src_pixel_val in range(len(src_cdf)):
        lookup_val
        for ref_pixel_val in range(len(ref_cdf)):
            if ref_cdf[ref_pixel_val] >= src_cdf[src_pixel_val]:
                lookup_val = ref_pixel_val
                break
        lookup_table[src_pixel_val] = lookup_val
    return lookup_table
 
def match_histograms(src_image, ref_image):
    """
    This method matches the source image histogram to the
    reference signal
    :param image src_image: The original source image
    :param image  ref_image: The reference image
    :return: image_after_matching
    :rtype: image (array)
    """
    # Only one colour channel repeated three times. No need to repeat for RGB
    src, src_g, src_r = cv2.split(src_image)
    ref, ref_g, ref_r = cv2.split(ref_image)
 
    # Compute the b, g, and r histograms separately
    # The flatten() Numpy method returns a copy of the array c
    # collapsed into one dimension.
    src_hist, bin_0 = np.histogram(src.flatten(), 256, [0,256])
    ref_hist, bin_1 = np.histogram(ref.flatten(), 256, [0,256])    
 
    # Compute the normalized cdf for the source and reference image
    src_cdf = calculate_cdf(src_hist)
    ref_cdf = calculate_cdf(ref_hist)
    
    # Make a separate lookup table for each color
    lookup_table = calculate_lookup(src_cdf, ref_cdf)
 
    # Use the lookup function to transform the colors of the original
    # source image
    after_transform = cv2.LUT(src, lookup_table)
 
    # Merge the three greyscale layers to recreate the png image
    #image_after_matching = cv2.merge([after_transform, after_transform, after_transform])
    image_after_matching = after_transform
    image_after_matching = cv2.convertScaleAbs(image_after_matching)
 
    return image_after_matching


ref_img = cv2.imread(ref_img_path)

for img_name in os.listdir(unmatched_dir):
    if img_name.startswith("."):
        continue

    img = cv2.imread(os.path.join(unmatched_dir, img_name))

    img_matched = match_histograms(img, ref_img)

    cv2.imwrite(os.path.join(matched_dir, "matched_" + img_name), img_matched)