function [trainedSN, augimgsTest] = helperSqueezeNetTrain(imgsTrain, imgsValidation, imgsTest)
%% Initialize SqueezeNet
sqz = squeezenet;

%% Check the input size of the net
lgraphSqz = layerGraph(sqz);
disp(['Number of Layers: ', num2str(numel(lgraphSqz.Layers))])
disp(lgraphSqz.Layers(1).InputSize)

%% Replace drop9 layer  with a dropout layer of probability 0.6
tmpLayer = lgraphSqz.Layers(end-5);
newDropoutLayer = dropoutLayer(0.6, 'Name', 'new_dropout');
lgraphSqz = replaceLayer(lgraphSqz, tmpLayer.Name, newDropoutLayer);

%% Increase learning rate factors of the new layer
numClasses = numel(categories(imgsTrain.Labels));
tmpLayer = lgraphSqz.Layers(end-4);
newLearnableLayer = convolution2dLayer(1, numClasses, ...
    'Name', 'new_conv', ...
    'WeightLearnRateFactor', 10, ...
    'BiasLearnRateFactor', 10);
lgraphSqz = replaceLayer(lgraphSqz, tmpLayer.Name, newLearnableLayer);

%% Replace classification layer with new one without class labels
tmpLayer = lgraphSqz.Layers(end);
newClassLayer = classificationLayer('Name', 'new_classoutput');
lgraphSqz = replaceLayer(lgraphSqz, tmpLayer.Name, newClassLayer);

%% Prepare RGB Data for SqueezeNet
augimgsTrain = augmentedImageDatastore([227 227], imgsTrain);
augimgsValidation = augmentedImageDatastore([227 227], imgsValidation);
augimgsTest = augmentedImageDatastore([227 227], imgsTest);
%% Set Training Options and Train SqueezeNet
initLearningR = 1e-4;
miniBatchSize = 10;
maxEpochs = 15;

reset(augimgsTrain);
trainData = read(augimgsTrain);

valFreq = floor(numel(trainData)/miniBatchSize);
opts = trainingOptions('sgdm', ...
    'MiniBatchSize', miniBatchSize,...
    'MaxEpochs', maxEpochs,...
    'InitialLearnRate', initLearningR,...
    'ValidationData', augimgsValidation,...
    'ValidationFrequency',valFreq,...
    'Verbose', 1,...
    'ExecutionEnvironment', 'gpu', ...
    'Plots', 'training-progress');

rng default

%% Train network
trainedSN = trainNetwork(augimgsTrain, lgraphSqz, opts);
end