function [ out ] = Kilfoil_to_simple_traj(in)
    %Kilfoil_to_simple_traj: Transform the output of Kilfoil particle tracking into
    %the format produced by uTrackToSimpleTraj.m

    %   Inputs:
    %
    %   in                     = output data in array format used by Kilfoil with columns:


    %   Xpos    Ypos    Int     Eccentricity    gyration    frame#  time   Track ID
    %
    %   
    %   Output:
    %
    %   out           = a list of particle tracks in the format 
    %                       output by the function uTrackToSimpleTraj:
    %
    %   'first' =   the first movie frame in which this track appears
    %   'last' =    the last movie frame in which this track appears.
    %   'lifetime' = the length of the track in frames.
    %   'x' = an array containing the sequence of x positions.
    %   'y' = an array containing the sequence of y positions.
    %   'I' = an array containing the intensity values.

    numTracks = max(in(:,8));
    out(numTracks) = struct('first',0,'last',0,'lifetime',0,'x',0,'y',0,'I',0);

    for i = 1:numTracks
        trk = in([in(:,8)==1],:);
        out(i).first = min(trk(:,6));
        out(i).last = max(trk(:,6));
        out(i).lifetime = out(i).last-out(i).first+1;
        out(i).x = trk(:,1);
        out(i).y = trk(:,2);
        out(i).I = trk(:,3);
    end
end

