function totalFilesCtr = helperConvert2Scalogram(SWSegment, bulletType, textFolders, nRounds, totalFilesCtr, Fs, imageFolderParent, imageFolderRoot, classes, testImageFolder)

for iRound=1:nRounds
    try
    % Convert SW to scalogram
    signalLength = length(SWSegment{iRound});
    fb = cwtfilterbank('SignalLength', signalLength,...
        'SamplingFrequency',Fs,...
        'VoicesPerOctave',12);
    
    cfs = abs(fb.wt(SWSegment{iRound}));
    catch
        continue;
    end
    
    totalFilesCtr = totalFilesCtr + 1;
    im = ind2rgb(im2uint8(rescale(cfs)),jet(128));
    im = normalize(im, 'range');
    
    if strcmp(bulletType, textFolders{1}) || strcmp(bulletType, textFolders{2})
        imgLoc = fullfile(imageFolderParent, classes(1));
        imFileName = strcat('5', '_', erase(lower(bulletType), 'output'), '_', num2str(totalFilesCtr), '.jpg');
    elseif strcmp(bulletType, textFolders{3})
        imgLoc = fullfile(imageFolderParent, classes(2));
        imFileName = strcat('7', '_', erase(lower(bulletType), 'output'), '_', num2str(totalFilesCtr), '.jpg');
    else
        imgLoc = fullfile(imageFolderRoot,  testImageFolder);
        imFileName = strcat(erase(lower(bulletType), 'output'), '_', num2str(totalFilesCtr), '.jpg');
    end
    
    imwrite(imresize(im,[224 224]),fullfile(imgLoc,imFileName));
end
end