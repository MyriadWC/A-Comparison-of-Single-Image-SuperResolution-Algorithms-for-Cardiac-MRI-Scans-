import cv2
import os

uncropped_dir 	= 'testingaxialfullpat17/'
cropped_dir 		= 'testingaxialfullpat17CROPPED0.7/'
extension = '.png'
scale = 0.7

def imagecrop(img, scale):
    middleX, middleY = img.shape[1]/2, img.shape[0]/2
    widthNew, heightNew = img.shape[1]*scale, img.shape[0]*scale
    leftX, rightX = middleX - widthNew/2, middleX + widthNew/2
    topY, bottomY = middleY - heightNew/2, middleY + heightNew / 2
    imagecropped = img[int(topY):int(bottomY), int(leftX):int(rightX)]
    print("Image " + imgname + " has been cropped")
    return imagecropped


for imgname in os.listdir(uncropped_dir):
    if imgname.startswith("."):
        continue

    img = cv2.imread(os.path.join(uncropped_dir, imgname))
    imagecropped = imagecrop(img, scale)

    cv2.imwrite(os.path.join(croppeddir, "cropped" + imgname), imagecropped)