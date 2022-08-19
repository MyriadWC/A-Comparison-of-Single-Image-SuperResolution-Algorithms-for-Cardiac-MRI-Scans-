% Copyright 2018 The MathWorks, Inc.

function createVDSRTrainingSet(imds,scaleFactors,upsampledDirName,residualDirName, isGreyscale)

if ~isfolder(residualDirName)
    mkdir(residualDirName);
end
    
if ~isfolder(upsampledDirName)
    mkdir(upsampledDirName);
end

while hasdata(imds)
    % Use only the luminance component for training
    
    [I,info] = read(imds);
    [~,fileName,~] = fileparts(info.Filename);
    
    if(isGreyscale == false)
        I = rgb2ycbcr(I);
    end
    
    Y = I(:,:,1);
    I = im2double(Y);
    
    % Randomly apply one value from scaleFactor
    if isvector(scaleFactors)
        scaleFactor = scaleFactors(randi([1 numel(scaleFactors)],1));
    else
        scaleFactor = scaleFactors;
    end

    if (isStandardDownsampling == false)
        Imatched = imhistmatch(I, ref);
        %Filters image using averaging smoothing with 8x8 kernel
        Ifiltered = imfilter(Imatched, ones(8,8) / 64, 'replicate');

        %Create a low-resolution version of the high-resolution reference image by using imresize with a scaling factor of 0.25. The high-frequency components
        %of the image are lost during the downscaling.
        lowResolutionImage = imresize(Ifiltered,scaleFactor,'bicubic');
    else
        % Resize the reference image by a scale factor of 4 to create a low-resolution image using bicubic interpolation
        downsampledImage = imresize(I,1/scaleFactor,'bicubic');
    end

    upsampledImage = imresize(downsampledImage,[size(I,1) size(I,2)],'bicubic');
    
    residualImage = I-upsampledImage;
    
    save([residualDirName filesep fileName '.mat'],'residualImage');
    save([upsampledDirName filesep fileName '.mat'],'upsampledImage');
    
end

end