function cnts = getNumFeaturesVsTime(trks)

    numTracks = length(trks);
    maxFrm = max([trks.last]);

    cnts = zeros(1,maxFrm);
    for i = 1:numTracks
        cnts(trks(i).first:trks(i).last) = cnts(trks(i).first:trks(i).last) + ones(1,trks(i).lifetime);
    end
end