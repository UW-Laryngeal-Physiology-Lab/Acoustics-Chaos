function [zcRate, zcPos, zcStatus] = getBigZeroCrossRate(theSig)

minZcInterval = 5;

lenOfSig = length(theSig);
zcRate = 0;
zcPos = [];
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


for n = 1 : zcRate - 2
    if n+2 > zcRate
        break;
    end
    if (zcPos(n+2) - zcPos(n)) < minZcInterval
        zcPos(n+2) = [];
        zcPos(n) = [];
        zcRate = zcRate - 2;
        
        zcStatus(n+1) = -zcStatus(n+1);
        zcStatus(n+2) = [];
        zcStatus(n) = [];
        
        n = n - 1;
    end
end