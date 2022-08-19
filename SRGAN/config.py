from easydict import EasyDict as edict
import json

config = edict()
config.TRAIN = edict()

## Adam
config.TRAIN.batch_size = 16 # [16] use 8 if your GPU memory is small, and use [2, 4] in tl.vis.save_images / use 16 for faster training
config.TRAIN.lr_init = 1e-4
config.TRAIN.beta1 = 0.9

## initialize G
config.TRAIN.n_epoch_init = 100
    # config.TRAIN.lr_decay_init = 0.1
    # config.TRAIN.decay_every_init = int(config.TRAIN.n_epoch_init / 2)

## adversarial learning (SRGAN)
config.TRAIN.n_epoch = 2000
config.TRAIN.lr_decay = 0.1
config.TRAIN.decay_every = int(config.TRAIN.n_epoch / 2)

## train set location
config.TRAIN.hr_img_path = 'MRI_SLICES_2_3L/MRI_SLICE_TRAIN_HR_CROPPED_0.7/'
config.TRAIN.lr_img_path = 'MRI_SLICES_2_3L/MRI_SLICE_TRAIN_LR_MATCHED_8x8kernel_avg_blur/4.0x/'

config.VALID = edict()
## test set location
config.VALID.hr_img_path = 'MRI_4_TEST_IMGS/axial_full_pat17_HR_CROPPED/'
config.VALID.lr_img_path = 'MRI_4_TEST_IMGS/axial_full_pat17_LR_CROPPED_MATCHED_8x8kernel_avg_blur/4.0x/'

def log_config(filename, cfg):
    with open(filename, 'w') as f:
        f.write("================================================\n")
        f.write(json.dumps(cfg, indent=4))
        f.write("\n================================================\n")
