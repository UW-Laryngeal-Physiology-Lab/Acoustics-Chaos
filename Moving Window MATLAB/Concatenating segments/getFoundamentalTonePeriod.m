function [theFTPeriod] = getFoundamentalTonePeriod(vecVoice,nFs)

frameLen = nFs/50;
for n=1:length(vecVoice)/frameLen;
    for m=1:frameLen
        Rm(m) = 0;
        for k=(m+1):frameLen
            Rm(m) = Rm(m) + vecVoice(floor(k+(n-1)*frameLen))*vecVoice(floor(k-m+(n-1)*frameLen));
        end        
    end
    p = Rm(10:end);
    [Rmax,N(n)] = max(p);
end

N = N + 10;
T = N/50;
% figure(1007);
% stem(T,'.');
% axis([0 length(T) 0 10]);
% xlabel('frameNum');
% ylabel('Period (ms)');
% title('The T');
theFTPeriod = mean(T);

% T1 = medfilt1(T,5);
% figure(3);
% stem(T1,'.');axis([0 length(T1) 0 10]);
% xlabel('frameNum');
% ylabel('Period (ms)');
% title('The T');


