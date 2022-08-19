isTrain        = false;
isGreyscale    = true;

%standard downsampling is simple bicubic downsampling of the training set
%non-standard includes histogram matching and 8x8 kernel bicubic smoothing
isStandardDownsampling = true;
%weightsFile   = 'trainedVDSR-19-Feb-2021-15-33-52-Epoch-100-ScaleFactors-234.mat';
weightsFile    = 'trainedVDSR-Epoch-100-ScaleFactors-234.mat'

testFileName   = 'cropped_testing_axial_full_pat17_z116.png';
testFilePath   = './test_images/axial_full_pat17_HR_CROPPED/';

referenceImg = './lian_data_reference.png';

if(isTrain)
    
    train(isGreyscale);

else
    
    test(weightsFile, testFileName, testFilePath, isGreyscale, referenceImg, isStandardDownsampling);

end
