import cv2
import numpy as np
import os

ninelayer_dir    = 'MRI_SLICE_TRAIN_HR_CROPPED_0.7/'
threelayer_dir      = 'MRI_SLICE_TRAIN_HR_CROPPED_0.7_3layers/'

os.makedirs(threelayer_dir, exist_ok=True)
 
def three_layers(src_image):
    
    # Only one colour channel repeated three times. No need to repeat for RGB
    src, src_g, src_r = cv2.split(src_image)
 
    # Merge the three greyscale layers to recreate the png image
    #image_after_matching = cv2.merge([src, src, src])
    #image_after_matching = cv2.convertScaleAbs(image_after_matching)
 
    #return image_after_matching
    return src

for img_name in os.listdir(ninelayer_dir):
    if img_name.startswith("."):
        continue

    img = cv2.imread(os.path.join(ninelayer_dir, img_name))

    img_three = three_layers(img)

    cv2.imwrite(os.path.join(threelayer_dir, img_name), img_three)