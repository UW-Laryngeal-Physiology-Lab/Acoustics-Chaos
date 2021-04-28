function [theFeatureVec] = getFeatureVector(theSig,thePos)
% inialize the output
theFeatureVec = -ones(1,11);
% get the sub signal
if(thePos-2<=0||thePos+3>length(theSig))
    fprintf('index error');
    return;
end
theSubSig = theSig(thePos-2:thePos+3);
idx_Start = 3;

% calculate the features
% f1 = x[i]-x[i+1]
theFeatureVec(1) = theSubSig(idx_Start)-theSubSig(idx_Start+1);
% f2 = |x[i]|
theFeatureVec(2) = abs(theSubSig(idx_Start));
% f3 = |x[i+1]|
theFeatureVec(3) = abs(theSubSig(idx_Start+1));
% f4 = (x[i]-x[i+2])/2;
theFeatureVec(4) = (theSubSig(idx_Start)- theSubSig(idx_Start+2))/2;
% f5 = |x[i+2]|
theFeatureVec(5) = abs(theSubSig(idx_Start+2));
% f6 = (x[i]-x[i+3])/3;
theFeatureVec(6) = (theSubSig(idx_Start)- theSubSig(idx_Start+3))/3;
% f7 = |x[i+3]|
theFeatureVec(7) = abs(theSubSig(idx_Start+3));
% f8 = (x[i-1]-x[i+1])/2;
theFeatureVec(8) = (theSubSig(idx_Start-1)- theSubSig(idx_Start+1))/2;
% f9 = |x[i-1]|
theFeatureVec(9) = abs(theSubSig(idx_Start-1));
% f10 = (x[i-2]-x[i+1])/3;
theFeatureVec(10) = (theSubSig(idx_Start-2)- theSubSig(idx_Start+1))/3;
% f11 = |x[i-2]|
theFeatureVec(11) = abs(theSubSig(idx_Start-2));
