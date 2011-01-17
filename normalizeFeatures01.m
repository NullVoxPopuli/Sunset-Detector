% This function normalizes the features to the range [0,1]. For each feature type, 
% for example, Lmean, the min becomes 0 and max becomes 1. This isn't that robust, because 
% a single outlier could compress the rest of the data too much.

% The data is assumed to be in the the format specified in the paper.
% Features is a N x 294 matrix, where N is the number of images.
function features = normalizeFeatures01(features, featuresPerGridBox, numberOfFeatures)

% if this isn't 294, we should thow an exception
nFeatures = size(features, 2); % 294
if (nFeatures ~= numberOfFeatures)
     error = MException('MATLAB:LoadErr',...
         'Number of features read is not the same as the calculated number of features. You will need to update the .mat file');
     throw(error);
    
end

% Loop over Lmean, Lstd, Smean, Sstd, Tmean, Tstd
for selectedType = 1:featuresPerGridBox
    % extract all values of the given feature from all 49 blocks from all images
    selectedFeature = features(:,selectedType:featuresPerGridBox:nFeatures);
    % Find the min and shift the data so that the min is now 0
    minValue = min(min(selectedFeature));
    selectedFeature = selectedFeature-minValue;
 
    % Find the max and divide by it to make the max 1
    maxValue = max(max(selectedFeature));
    selectedFeature = selectedFeature / maxValue;
 
    % We could have combined: f = (f-min)/(max-min)
    
    % Re-insert into the feature matrix
    features(:,selectedType:featuresPerGridBox:nFeatures) = selectedFeature;
end
 
features = double(features);