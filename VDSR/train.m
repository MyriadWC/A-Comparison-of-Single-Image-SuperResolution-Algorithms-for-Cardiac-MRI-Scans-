function train(isGreyscale)
    
    trainImagesDir = './train_images/new_training_images/';
    referenceImg = './lian_data_reference.png';
    exts = {'.jpg','.bmp','.png'};
    origImages = imageDatastore(trainImagesDir,'FileExtensions',exts);

    % Prepare Training Data
   
    upsampledDirName = [trainImagesDir filesep 'upsampledImages'];
    residualDirName = [trainImagesDir filesep 'residualImages'];

    %createVDSRTrainingSet performs these operations for each image in trainImages:
    %   - Convert  image to the YCbCr
    %   - Downsize luminance (Y) channel by different scale factors to create artificial LR images, then resize the images to the original size using bicubic interpolation
    %   - Calculate the difference between the original and resized images.
    %   - Save the resized and residual images.

    %---------------------------------------%
    
    %scaleFactors = [2 3 4];
    scaleFactors = [2 4];
    createVDSRTrainingSet(origImages,scaleFactors,upsampledDirName,residualDirName, isGreyscale, referenceImg);

    % Define Preprocessing Pipeline for Training Set

    upsampledImages = imageDatastore(upsampledDirName,'FileExtensions','.mat','ReadFcn',@matRead);
    residualImages = imageDatastore(residualDirName,'FileExtensions','.mat','ReadFcn',@matRead);
    
    %---------------------------------------%

    % Create an imageDataAugmenter that specifies the parameters of data augmentation. data augmentation varies the training data, generating more training data from the same base images.
    % augmenter has been set to perform random 90 degree rotation and random reflections in the x-direction.

    augmenter = imageDataAugmenter( ...
        'RandRotation',@()randi([0,1],1)*90, ...
        'RandXReflection',true);

    %Create a randomPatchExtractionDatastore that performs randomized patch extraction from the upsampled and residual image datastores.

    patchSize = [41 41];
    patchesPerImage = 64;
    dsTrain = randomPatchExtractionDatastore(upsampledImages,residualImages,patchSize, ...
        "DataAugmentation",augmenter,"PatchesPerImage",patchesPerImage);

    %The resulting datastore, dsTrain, provides mini-batches of data to the network at each iteration of the epoch. Preview the result of reading from the datastore.

    inputBatch = preview(dsTrain);
    disp(inputBatch)

    %Set Up VDSR Layers

    layers = vdsrLayers();

    %Specify training options

    maxEpochs = 100;
    epochIntervals = 1;
    initLearningRate = 0.1;
    learningRateFactor = 0.1;
    l2reg = 0.0001;
    miniBatchSize = 64;
    options = trainingOptions('sgdm', ...
        'Momentum',0.9, ...
        'InitialLearnRate',initLearningRate, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',10, ...
        'LearnRateDropFactor',learningRateFactor, ...
        'L2Regularization',l2reg, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'GradientThresholdMethod','l2norm', ...
        'GradientThreshold',0.01, ...
        'Plots','training-progress', ...
        'Verbose',false);

    %Train the Network

    modelDateTime = datestr(now,'dd-mmm-yyyy-HH-MM-SS');
    net = trainNetwork(dsTrain,layers,options);
    save(['trainedVDSR-' modelDateTime '-Epoch-' num2str(maxEpochs*epochIntervals) '-ScaleFactors-' num2str(234) '.mat'],'net','options');

end