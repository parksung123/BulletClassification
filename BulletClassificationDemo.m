function BulletClassificationDemo(trainImageFolder, testImageFolder, skipConversion, skipTraining)
addpath(fullfile(pwd, 'helper_func'));

% AUTOMATE THE TEST DATA AND FIX THE MAKING FILES OF THE LAST THREE TEXT
imageFolderRoot = helperConvertTextToScalogram(trainImageFolder, testImageFolder, skipConversion);

if skipTraining == 0
    %% Divide into Training and Validation Data
    allImages = imageDatastore(fullfile(imageFolderRoot, trainImageFolder),...
        'IncludeSubfolders', true,...
        'LabelSource','foldernames');
    
    %% Split Train and Validation Data
    rng default
    [imgsTrain, imgsValidation, imgsTest] = splitEachLabel(allImages, 0.7, 0.15, 0.15, 'randomized');
    disp(['Number of training images: ', num2str(numel(imgsTrain.Files))]);
    disp(['Number of validation images: ', num2str(numel(imgsValidation.Files))]);
    disp(['Number of test images: ', num2str(numel(imgsTest.Files))]);
    
    %% Train SqueezeNet
    [SNmodel, ~] = helperSqueezeNetTrain(imgsTrain, imgsValidation, imgsTest);
    save('AINetwork', 'SNmodel');
end

%% Import images from Test folder
load('AINetwork', 'SNmodel');

testImages = imageDatastore(fullfile(imageFolderRoot , testImageFolder));
disp(['Number of test images: ', num2str(numel(testImages.Files))]);
augTestImages = augmentedImageDatastore([227 227], testImages);
[YPred, ~] = classify(SNmodel, augTestImages);

for iRow = 1:length(YPred)
    predictedLabel = cellstr(YPred(iRow));
    disp([num2str(iRow), '. Class prediction: ', predictedLabel{1}]);
end
