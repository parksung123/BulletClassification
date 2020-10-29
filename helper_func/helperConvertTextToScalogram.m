function imageFolderRoot = helperConvertTextToScalogram(trainImageFolder, testImageFolder, skipConversion)
warning('off', 'signal:findpeaks:largeMinPeakHeight');
% FOLDERS
classes = ["5.56mm" "7.62mm"];
nClasses = numel(classes);

textFolders = {'AutoOutput', 'SingleOutput', 'Single2Output',...
    '2019-06-27_오후_14733Output', '2019-06-27_오후_15118Output', '2020-09-21_22202Output'};

imageFolderRoot = pwd;
textFileFolder = fullfile(pwd, trainImageFolder);

%%
% directory of images
bulletDataFolder = fullfile(imageFolderRoot, trainImageFolder);

if ~exist(bulletDataFolder, 'dir')
    mkdir(bulletDataFolder);
end

% directory of each class images
for iClasses = 1:nClasses
    classFolderPath = fullfile(bulletDataFolder, classes(iClasses));
    if ~exist(classFolderPath, 'dir')
        mkdir(classFolderPath);
    end
end

testFolderPath = fullfile(imageFolderRoot, testImageFolder);
if ~exist(testFolderPath, 'dir')
    mkdir(testFolderPath);
end

if skipConversion == 0
    % number of classes with data
    nTextFolders = numel(textFolders);
    
    %%  'C:\Users\a\Desktop\WaveExtractionImages\bulletData'
    % Image parent directory
    imageFolderParent = fullfile(imageFolderRoot, trainImageFolder);
    Fs = 100000;
    
    % Auto threshold multiplier
    thresholdMultiplier = 1/1.5;
    
    %% Iterate through the text folders
    for iTextFolder = 1:nTextFolders
        totalFilesCtr = 0;
        
        bulletType = textFolders(iTextFolder);
        bulletType = bulletType{1};
        xLocationMatrix = [];
        
        % Remove '.', '..', and '.mat'
        textDirectory = dir((fullfile(pwd, bulletType)));
        notTxtFile = ~contains({textDirectory.name}, 'rnd');
        textDirectory(notTxtFile) = [];
        
        % Number of txt files inside each folder
        nFiles = size(textDirectory, 1);
        nInc = 1;
        
        if iTextFolder >= 4
            nInc = 3;
        end
        
        %% Iterate through the txt files
        for iFile = 1:nInc:nFiles
            bulletSignalData = load(fullfile(textDirectory(1).folder, textDirectory(iFile).name));
            % Keep track of nth round each file
            isValidFile = any(bulletSignalData > 0.1);
            if isValidFile
                [xLocationMatrix, nRounds] = helperFindSWLocation(bulletSignalData, textFolders, xLocationMatrix, thresholdMultiplier, bulletType);
                SWSegment = helperExtractShockwave(bulletSignalData, xLocationMatrix, nRounds, thresholdMultiplier);
                totalFilesCtr = helperConvert2Scalogram(SWSegment, bulletType, textFolders, nRounds, totalFilesCtr, Fs, imageFolderParent, imageFolderRoot, classes, testImageFolder);
            else
                continue;
            end
        end
        disp([bulletType, ': finished converting to scalogram.']);
    end
end
end