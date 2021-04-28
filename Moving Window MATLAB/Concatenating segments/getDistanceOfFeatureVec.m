function [dDistance] = getDistanceOfFeatureVec(vecF_01, vecF_02)

dDistance = sum((abs(vecF_01-vecF_02)).^2)/length(vecF_01);