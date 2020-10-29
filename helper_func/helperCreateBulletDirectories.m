function helperCreateBulletDirectories(imageFolder, parentFolder, labels)

rootFolder = parentFolder;
folderLabels = labels;
localFolder = imageFolder;
mkdir(fullfile(parentFolder, imageFolder)); 

for i = 1:numel(folderLabels)
    path = fullfile(rootFolder, localFolder, char(folderLabels(i))); % {'C:\Users\a\Desktop\WaveExtract…'}    {'C:\Users\a\Desktop\WaveExtract…'}    {'C:\Users\a\Desktop\WaveExtract…'}
    mkdir(path);
end
end