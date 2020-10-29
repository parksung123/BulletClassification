function SWSegment = helperExtractShockwave(bulletSignalData, xLocationMatrix, nRounds, thresholdMultiplier)
%% extract shockwaves
SWSegment = cell(nRounds, 1);
for iRound = 1:nRounds
    padded = 500;
    
    while xLocationMatrix(iRound) <= padded
        padded = padded - 100;
    end
    
    shockwaveSegment = bulletSignalData(xLocationMatrix(iRound)-padded:xLocationMatrix(iRound)+padded);
    shockwaveSegment = normalize(shockwaveSegment, 'center', 'mean');
    
    new_TH = max(shockwaveSegment) * thresholdMultiplier;
    [~, locs] = findpeaks(shockwaveSegment, 'MinPeakHeight', new_TH);
    fpeak = locs(1);
    bulletSegment_inverse = -shockwaveSegment;
    [~, locs] = findpeaks(bulletSegment_inverse, 'MinPeakHeight', new_TH/2);
    
    while isempty(locs)
        new_TH = new_TH/1.5;
        [~, locs] = findpeaks(bulletSegment_inverse, 'MinPeakHeight', new_TH);
    end
    speak = locs(1);

    isSecondPeakSW = (numel(locs) > 1 && (locs(2) - locs(1)) < 20);
    if isSecondPeakSW
        speak = locs(2);
    end
    
    % Shift the average noise before the shockwave segment
    % to zero
    initialNoise = shockwaveSegment(fpeak-12:fpeak-8);
    tempSegment = shockwaveSegment;
    tempSegment(fpeak-12:fpeak-8) = normalize(initialNoise, 'center', 'mean');
    
    % Zero-crossing algorithm to find zero intersections
    zeroCrossIdx = find([false; diff(sign(tempSegment))~=0]);
    leftZero = zeroCrossIdx(find(fpeak > zeroCrossIdx, 1, 'last'));
    rightZero = zeroCrossIdx(find(speak < zeroCrossIdx, 1, 'first'));
    
    SWSegment{iRound} = shockwaveSegment(leftZero:rightZero);
end
end