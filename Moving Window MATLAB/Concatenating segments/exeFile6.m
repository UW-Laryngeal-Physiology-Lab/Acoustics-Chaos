clear;
close all;
% Select a wav file
[fileName, pname] = uigetfile('*.wav', 'Please Select an .wav file');
% read a wave file
[wavFileData, nFs] = wavread(fullfile(pname,fileName));
wavFileData = wavFileData';
% find out zero cross rate
[zcRate, zcPos, zcStatus] = getBigZeroCrossRate(wavFileData);

outputDataLen = 2 * nFs;

FTPeriod = getFoundamentalTonePeriod(wavFileData, nFs);
FTPeriodLen = round( FTPeriod * nFs / 1000 );

if FTPeriodLen <= 150
    FTPeriodLen = FTPeriodLen * round (150/FTPeriodLen);
end

endOffset = zcPos(end);
endSeg = wavFileData(endOffset - 2*FTPeriodLen + 1 : endOffset);
% figure(1);
% hold on
% X = [0:600];Y = zeros(1,601);
% line(X,Y);
% plot(endSeg);
% hold off

[zcRateE, zcPosE, zcStatusE] = getBigZeroCrossRate(endSeg);

startSeg = wavFileData(zcPos(1):zcPos(1)+FTPeriodLen);
% figure(2);
% hold on
% line(X,Y);
% plot(startSeg);
% hold off

[zcRateS, zcPosS, zcStatusS] = getBigZeroCrossRate(startSeg);

nmax = 0;
if length(zcPosS)>6
    nmax = 6;
else
    nmax = length(zcPosS);
end

vecSSegFeature = zeros(1,2*(nmax-1));
subSeg = [];
for n = 1 : nmax - 1
    subSeg = startSeg(zcPosS(n):zcPosS(n+1));
    vecSSegFeature(2*n-1) = sum(subSeg);
    if zcStatusS(n)>=0
        vecSSegFeature(2*n) = max(subSeg);
    else
        vecSSegFeature(2*n) = min(subSeg);
    end
end
% figure(1008);
% hold on;
% plot(startSeg(zcPosS(1):zcPosS(nmax)));
% X = [0:600];Y = zeros(1,601);
% line(X,Y);
% hold off;

mmax = length(zcPosE)-nmax;
vecESegFeature = zeros(1,2*(nmax-1));
matESegFeature = zeros(mmax,2*(nmax-1));
vecDistance = zeros(mmax,1);;
for m = 1 : mmax
%     compareSeg{m} = endSeg(zcPosE(end - m - nmax +1 + 1 ):zcPosE(end - m + 1 ));
%     figure(100+m);
%     hold on;
%     plot(compareSeg{m});
%     X = [0:600];Y = zeros(1,601);
%     line(X,Y);
%     hold off;
    
    for n = 1 : nmax -1
        subSeg = endSeg(zcPosE(end - m - nmax + 1 + n):zcPosE(end - m - nmax + 1 + n + 1));
        vecESegFeature(2*n-1) = sum(subSeg);
        if zcStatusE(end - m - nmax + 1 + n)>=0
            vecESegFeature(2*n) = max(subSeg);
        else
            vecESegFeature(2*n) = min(subSeg);
        end
    end
    % zcStatusE(end - m - nmax + 1 + 1)
    if zcStatusE(end - m - nmax + 1 + 1)~= zcStatusS(1)
       vecESegFeature = vecESegFeature + 1; 
    end    
    matESegFeature(m,:) = vecESegFeature;
    vecDistance(m) = sum(abs(vecESegFeature - vecSSegFeature));
end

% figure(1009)
% hold on
% X = [0:600];Y = zeros(1,601);
% line(X,Y);
% plot(endSeg(beginInsteadIdx:end));
% hold off

[md,mdidx]=min(vecDistance);
beginInsteadIdx = zcPos(end - (mdidx+nmax))-1;
segCopy = wavFileData(zcPos(1):beginInsteadIdx-1);

outputData = wavFileData(1:beginInsteadIdx-1);
extLen = length(outputData);
while(extLen<outputDataLen)
    outputData = [outputData,segCopy];
    extLen = length(outputData);
end
outputData = outputData(1:outputDataLen);

[filename, pathname] = uiputfile('*.wav', 'Save outputData as');
wavwrite(outputData,nFs,fullfile(pathname,filename));


