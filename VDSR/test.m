function test(weights_file, fileName, filePath, isGreyscale, referenceImg, isStandardDownsampling)

    load(weights_file);

    filePathName = strcat(filePath,fileName);

    %Select one of the images to use as the reference image for super-resolution. You can optionally use your own high-resolution image as the reference image.

    %indx = 1; % Index of image to read from the test image datastore
    %Ireference = readimage(testImages,indx);

    Ireference = imread(filePathName);
    Ireference = im2double(Ireference);
    figure(1)
    imshow(Ireference) 
    
    scaleFactor = 0.25;
    
    if (isStandardDownsampling == false)
        %Histogram matches training data with sample from reference data we're
        %trying to replicate
        ref = imread(referenceImg);

        Imatched = imhistmatch(Ireference, ref);
        %Filters image using averaging smoothing with 8x8 kernel
        Ifiltered = imfilter(Imatched, ones(8,8) / 64, 'replicate');

        %Create a low-resolution version of the high-resolution reference image by using imresize with a scaling factor of 0.25. The high-frequency components
        %of the image are lost during the downscaling.
        Ilowres = imresize(Ifiltered,scaleFactor,'bicubic');
    else
        %For none-matching test of dataset trained on simply bicubically
        %downsampled data
        Ilowres = imresize(Ireference, scaleFactor, 'bicubic');
    end
     figure(2)
     imshow(Ilowres)

    %Improve Image Resolution Using Bicubic Interpolation

    [nrows,ncols,np] = size(Ireference);
    Ibicubic = imresize(Ilowres,[nrows ncols],'bicubic');
    figure(3)
    imshow(Ibicubic)

    %Improve Image Resolution Using Pretrained VDSR Network   
       
    if(isGreyscale == false)
        Ilowres = rgb2ycbcr(Ilowres);
        %If greyscale, the image only contains luminance Iy, so these
        %variables only need defining in the case of a colour image. These
        %will simply be split off from the luminance and bicubically interpolated,
        %then layered back once the luminance data has been super resolved
        Icb = Ilowres(:,:,2);
        Icr = Ilowres(:,:,3);

    end
    Iy = Ilowres(:,:,1);
   
    %Upscale the luminance and two chrominance channels using bicubic interpolation. The upsampled chrominance channels, Icb_bicubic and Icr_bicubic, require no further
    %processing.

    Iy_bicubic = imresize(Iy,[nrows ncols],'bicubic');
    
    if(isGreyscale == false)
        Icb_bicubic = imresize(Icb,[nrows ncols],'bicubic');
        Icr_bicubic = imresize(Icr,[nrows ncols],'bicubic');
    end

    %Pass the upscaled luminance component, Iy_bicubic, through the trained VDSR network. Observe the activations from the final layer (a regression layer).
    %The output of the network is the desired residual image.

    Iresidual = activations(net,Iy_bicubic,41);
    Iresidual = double(Iresidual);
    figure(4)
    imshow(Iresidual,[])
    %title('Residual Image from VDSR')

    %Add the residual image to the upscaled luminance component to get the high-resolution VDSR luminance component.

    Isr = Iy_bicubic + Iresidual;

    %If colour image, concatenate the high-resolution VDSR luminance component with the upscaled color components. Convert the image to the RGB color space by using the ycbcr2rgb function.
    %The result is the final high-resolution color image using VDSR.

    if(isGreyscale == false)
        Isr = ycbcr2rgb(cat(3,Isr,Icb_bicubic,Icr_bicubic));
    end
    
    figure(5)
    imshow(Isr);
    
    %PSNR calculation for bicubic and resolved VDSR
    
    bicubicPSNR = psnr(Ibicubic,Ireference);
    vdsrPSNR = psnr(Isr,Ireference);
    
    %Structural similarity index (SSIM) calculation
    
    bicubicSSIM = ssim(Ibicubic,Ireference);
    vdsrSSIM = ssim(Isr,Ireference);
    
    %Calculate the average PSNR and SSIM of the entire set of test images
    %for the scale factors 2, 3, and 4 using superResolutionMetrics
    
    fprintf('PSNR for Bicubic = %f\n',bicubicPSNR);
    fprintf('PSNR for VDSR = %f\n',vdsrPSNR);
    
    fprintf('SSIM for Bicubic = %f\n',bicubicSSIM);
    fprintf('SSIM for VDSR = %f\n',vdsrSSIM);
    

end

