function msd = getMSDatTAU(trks,tau,movieInfo)
% Compute mean squared dispacement at a given timelag tau for each of a sequence of trajectories

% Inputs:

% trks = an array of particle tracks in simple format
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.


% tau               timelag measured in frames

% movieInfo         =   a struct containing the following fields:
%     
%     frameRate:      in #/sec
%     pixelSize:      in µm

% Output

% msd           an array containing maximum values (for each track) of msd at lag time
%                       tau

    trks = trks([trks.lifetime]>tau);
%     trks = trks([trks.lifetime]== tau+1);
    msd = zeros(1,length(trks));
    for i = 1:length(trks)
        trk = trks(i);
        if tau < trk.lifetime
            N=trk.lifetime-tau;
            dx = trk.x(tau+1:tau+N)-trk.x(1:N);
            dy = trk.y(tau+1:tau+N)-trk.y(1:N);
            dx = dx(~isnan(dx));
            dy = dy(~isnan(dy));
            msd(i) = mean(dx.*dx + dy.*dy);
            msd(i) = msd(i)*movieInfo.pixelSize*movieInfo.pixelSize;
        end
    end
%     
%     trks = trks([trks.lifetime]>tau);
%     msd = zeros(1,length(trks));
%     for i = 1:length(trks)
%         trk = trks(i);
% 
%         lifetime = min(3,trk.lifetime);
% 
%         if tau < lifetime
%             N=lifetime-tau;
%             dx = trk.x(tau+1:tau+N)-trk.x(1:N);
%             dy = trk.y(tau+1:tau+N)-trk.y(1:N);
%             dx = dx(~isnan(dx));
%             dy = dy(~isnan(dy));
%             msd(i) = mean(dx.*dx + dy.*dy);
%             msd(i) = msd(i)*movieInfo.pixelSize*movieInfo.pixelSize;
%         end
%     end
end






