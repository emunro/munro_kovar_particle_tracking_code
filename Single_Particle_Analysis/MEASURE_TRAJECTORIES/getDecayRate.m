function  [rate,intercept] = getDecayRate(decayCurve,firstT,lastT,info)
%getDecayRates:  fits decay curves to an exponential function and returns the fitting parameters - namely the decay rate, the  for different embryos (and
%possibly different particle detection or tracking parameters 



    %  Inputs
    
    % decayCurve        =     a vector containing the decay curve
    % firstT            =     first position to sample
    % lastT             =     last position to sample
    % movieInfo         =     a struct containing the following fields:
    %     
    %                           frameRate:      in #/sec
    %                           pixelSize:      in µm
    % 
    
    % Outputs
    
    % rate              =   a 3-vector containing the (rate estimate,confidence intervals)
    % intercept         =   a 3-vector containing the (intercept estimate,confidence intervals)

    
    rate = zeros(1,3);
    intercept = zeros(1,3);
    
    deltaT = 1/info.frameRate;
    firstFrame = fix(firstT*info.frameRate);
    lastFrame = min(fix(lastT*info.frameRate),length(decayCurve)-1);
    lastFrame = min(lastFrame,find(decayCurve>0,1,'last'));

    
    % vector of timepointsthe
    x = transpose(deltaT*(0:(lastFrame-firstFrame)));
    
    % normalized data to max of 1 
    y = decayCurve(firstFrame:lastFrame)/decayCurve(firstFrame);
    
   % y values with fewer counts get smaller weights in the least squares fit
    weights = sqrt(y);

    % log turns exponential curve into linear one
    y = log(y);
     
    % Fit a line to the data 
    % intercept (which should be ~one for a fit to normalized data
    fitObject = fit(x,y,'poly1','Weights',weights);
    ci  = confint(fitObject);
    
    % extract the slope (the decay rate) 
    rate(1) = fitObject.p1;
    rate(2:3) = ci(:,1);
    
    % extract intercept (which should be ~one for a fit to normalized data
    intercept(1) = fitObject.p2;
    intercept(2:3) = ci(:,2);
end