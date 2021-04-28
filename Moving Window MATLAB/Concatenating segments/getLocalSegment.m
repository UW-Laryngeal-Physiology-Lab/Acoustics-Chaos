function [segData] = getLocalSegment(theSig,thePos,nSegLen)

segData = theSig(thePos : thePos+nSegLen-1);