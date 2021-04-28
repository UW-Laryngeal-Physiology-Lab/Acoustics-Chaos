classdef wav
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        wavfile = file();
        data = [];
        sampleRate = 0;
        nBits = 0;
        readInfo = [];
                
        time = [];
        nSamples = 0;
        length = 0;
        nChannels = 0;
        
        vmin = 0;
        vmax = 0;
    end
    
    methods
        % construction function
        function w = wav(f)
            [d, sr, nb, ri] = wavread(f.fullname);
            w.wavfile = f;
            w.data = d;
            w.sampleRate = sr;
            w.nBits = nb;
            w.readInfo = ri;
                        
            w.nSamples = size(d,1);
            w.length = w.nSamples / sr;
            w.time = 1/sr : 1/sr : w.length;
            w.nChannels = ri.fmt.nChannels;
            
            w.vmin = min(min(d));
            w.vmax = max(max(d));
        end
        
        % get sub-wav data
        function sw = subwav(w, tStart, tEnd)
            iStart = round(tStart * w.sampleRate) +1;
            iEnd = round(tEnd * w.sampleRate);
            sw.data = w.data(iStart:iEnd, :);
            sw.time = w.time(iStart:iEnd);
        end
    end
    
end

