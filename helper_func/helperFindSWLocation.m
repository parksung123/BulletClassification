function [xLocationMatrix, nRounds] = helperFindSWLocation(bulletSignalData, textFolders, xLocationMatrix, thresholdMultiplier, bulletType)
THVal = max(bulletSignalData) * thresholdMultiplier;
nextSWLoc = find(bulletSignalData(:, 1) > THVal, 1, 'first');
nRounds = 0;
xFinal = 8000;

if strcmp(bulletType, textFolders{1})
    %% find locations of shockwaves
    while ~isempty(nextSWLoc)
        nRounds = nRounds + 1;
        
        xLocationMatrix(nRounds) = nextSWLoc;
        
        nextSWScan = nextSWLoc + xFinal;
        nextSWLoc = find(bulletSignalData(nextSWScan:end, 1) > THVal, 1, 'first');
        nextSWLoc = nextSWLoc + nextSWScan;
    end
else
    xLocationMatrix = nextSWLoc;
    nRounds = 1;
end
end