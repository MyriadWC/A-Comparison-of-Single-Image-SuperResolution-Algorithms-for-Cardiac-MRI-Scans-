# A Comparison of Single Image SuperResolution Algorithms for Cardiac MRI Scans
My Master's Thesis comparing the relative merits of applying SRGAN and VDSR approaches to the SISR problem in LR MRI slice upsampling.

The final paper can be read [here](./USHER_Frank_FYPReport.pdf).

<b>Objective</b></br></br>
The comparison of two Single Image Super-Resolution (SISR) deep learning algorithms, Very Deep Super Resolution (VDSR) and a Super-Resolution Generative Adversarial Network (SRGAN), to enhance spatial resolution of low-resolution (LR) cardiac magnetic resonance imaging (MRI) scan slices, and to assess their utility as input to bi-ventricular segmentation programs.

<b>Approach</b></br></br>
Both networks were modified to accept MRI input data, and two artificial low-resolution (LR) MRI datasets were created from a single high-resolution (HR) dataset. The two datasets were divided into 806 HR/LR image training pairs and 225 testing pairs. The networks were trained and compared subjectively and by comparison of peak signal-to-noise ratio (PSNR) and structural similarity (SSIM). 

<b>Results</b></br></br>
For both datasets, SRGAN produced the most realistic output, and was most effective in restoring cardiac structural demarcation. VDSR was most effective in restoring correct cardiac structural form during SR, outperforming SRGAN and Bicubic interpolation on measures of PSNR and SSIM for Dataset 1 (P<0.001) and outperformed bicubic (P<0.001) and SRGAN for both measures in Dataset 2, but its poor edge-restoration can cause blending of cardiac boundaries, complicating the segmentation task. Some forms restored by SRGAN had been visibly altered compared to the ground truth, which could affect ventricular volume and wall thickness determination. SRGAN was outperformed on measures of PSNR and SSIM by VDSR and bicubic interpolation for Dataset 1 (P<0.001) and appeared to be outperformed by VDSR for both measures in Dataset 2.

<b>Significance</b></br></br>
SISR networks using MSE loss appear to be more suitable than both GAN-based networks and interpolation methods for generating HR MRI images suitable for the ventricular segmentation task. SRGAN appeared to be more effective than bicubic interpolation for SR of poorer quality LR input data.
