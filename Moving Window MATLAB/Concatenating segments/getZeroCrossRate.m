function [zcRate, zcPos, zcStatus] = getZeroCrossRate(theSig)

lenOfSig = length(theSig);
zcRate = 0;
for n=1+2:lenOfSig-1-3
    if theSig(n)*theSig(n+1)<0
        zcRate = zcRate + 1;
        zcPos(zcRate) = n;
        if theSig(n)>=0
            zcStatus(zcRate) = 1;
        else
            zcStatus(zcRate) = -1;
        end
    end
end