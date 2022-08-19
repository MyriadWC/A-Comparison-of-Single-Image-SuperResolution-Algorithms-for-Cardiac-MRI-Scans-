function superResolutionMetrics(net,testImages,scaleFactors)

% Loops through all selected scale factors. I only used one at a time, but it is possible to find average values over multiple SFs
for scaleFactor = scaleFactors
    fprintf('Results for SF %d\n\n',scaleFactor);

    % Loops through all images in the testing dataset    
    for i = 1:numel(testImages.Files)
        
        I = readimage(testImages,i);
        Iycbcr = rgb2ycbcr(I);
        Ireference = im2double(Iycbcr);
        
        %-------------------------------------------------%
        
        % Show the HR image at the start for reference
        filtered = imfilter(double(img), ones(3) / 9, 'replicate');
        imshow(uint8(filtered));
        
        if (isStandardDownsampling == false)
            Imatched = imhistmatch(Ireference, ref);
            %Filters image using averaging smoothing with 8x8 kernel
            Ifiltered = imfilter(Imatched, ones(8,8) / 64, 'replicate');

            %Create a low-resolution version of the high-resolution reference image by using imresize with a scaling factor of 0.25. The high-frequency components
            %of the image are lost during the downscaling.
            lowResolutionImage = imresize(Ifiltered,scaleFactor,'bicubic');
        else
            % Resize the reference image by a scale factor of 4 to create a low-resolution image using bicubic interpolation
            lowResolutionImage = imresize(Ireference,1/scaleFactor,'bicubic');
        end
        
        %-------------------------------------------------%
        
        % Upsample the low-resolution image using bicubic interpolation
        upsampledImage = imresize(lowResolutionImage,[size(Ireference,1) size(Ireference,2)],'bicubic');

        
        % Separate upsampled LR image into luminance and colour components.
        Iy  = upsampledImage(:,:,1);
        Icb = upsampledImage(:,:,2);
        Icr = upsampledImage(:,:,3);
        
        % Recreate the upsampled image from the luminance and colour components and
        % convert to RGB
        Ibicubic = ycbcr2rgb(cat(3,Iy,Icb,Icr));
        
        % We pass only the luminance component through the network because
        % we used only the luminance channel while training. The colour components
        % are upsampled using bicubic interpolation.
        residualImage = activations(net,Iy,41);
        residualImage = double(residualImage);
        
        % Add the residual image from the network to the upsampled luminance
        % component to get the high-resolution network output
        Isr = Iy + residualImage;
        
        % combine upsampled luminance and colour components and convert to RGB to get final
        % HR colour image
        Ivdsr = ycbcr2rgb(cat(3,Isr,Icb,Icr));
        
        % Convert reference image to RGB
        Ireference = ycbcr2rgb(Ireference);
        
        % Calculate final values and add them to the list
        bicubicPSNR(i) = psnr(Ibicubic,Ireference); %#ok<*AGROW>
        vdsrPSNR(i) = psnr(Ivdsr,Ireference);
        
        bicubicSSIM(i) = ssim(Ibicubic,Ireference);
        vdsrSSIM(i) = ssim(Ivdsr,Ireference);
        
    end

    % Since I only inputted one testing image at a time, the average means nothing, but it would be very easy to test on a large dataset to assess statistical significance
    % Takes the mean of all image PSNR and SSIM values in the testing dataset
    avgBicubicPSNR = mean(bicubicPSNR);
    fprintf('Average PSNR for Bicubic = %f\n',avgBicubicPSNR);

    avgVdsrPSNR = mean(vdsrPSNR);
    fprintf('Average PSNR for VDSR = %f\n',avgVdsrPSNR);

    avgBicubicSSIM = mean(bicubicSSIM);
    fprintf('Average SSIM for Bicubic = %f\n',avgBicubicSSIM);

    avgVdsrSSIM = mean(vdsrSSIM);
    fprintf('Average SSIM for VDSR = %f\n\n',avgVdsrSSIM);

end

end