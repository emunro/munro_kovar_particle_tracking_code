function padvec = nanpad(spvec, fmvec)
% pads spvec with NaNs based on fmvec

allfms = fmvec(1):fmvec(end);
padvec = zeros(size(allfms));
notmissing = ismember(allfms, fmvec); % find missing frames
padvec(notmissing) = spvec;
padvec(padvec == 0) = NaN;
end