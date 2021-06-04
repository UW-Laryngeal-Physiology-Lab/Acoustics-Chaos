# MovingWindow

Theis repository contains programs that are used to split audio data into short, overlapping segments. There are both LabVIEW and MATLAB versions. 

The MATLAB version currently only runs in 2013b. This is mainly because it uses the function wavread, which has since been replaced by audioread.

The LabVIEW version produces segments that are slightly different than the MATLAB version. This is due to datatype (float, double, etc.) differences between the two software. These differences should not cause any issues. It is just recommended that you only use segments created by one software or the other, not both.
