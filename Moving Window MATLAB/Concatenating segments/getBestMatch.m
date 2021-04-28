function [bestMatchIdx] = getBestMatch(segMatch1,segMatch2)

[zcRate1, zcPos1,zcStatus1] = getZeroCrossRate(segMatch1);
[zcRate2, zcPos2,zcStatus2] = getZeroCrossRate(segMatch2);

