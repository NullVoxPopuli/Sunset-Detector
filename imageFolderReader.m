function [bigMatrix, sunsetOrNot] = imageFolderReader(featuresPerGridBox, numOfGridSquares, numberOfFeatures)
% Example of reading all the files in a given folder, e.g., TrainSunset.
% For the sunset detector, you should keep the images in 4 separate folders: train and test
% are separate, and the folder names tell you what the labels are (sunset = +1, non = -1)
% subdir = ['TrainSunset';'TrainNonsunsets';'TestSunset';'TestNonsunset'];
% fileList = dir(subdir);
% files 1 and 2 are . (current dir) and .. (parent dir), respectively,
% so we start with 3.
bigMatrix = [];
sunsetOrNot = [];
for j = 1:4
    str = ['unset'];
    if j == 1 || j == 3
        str = ['S',str];
    else
        str = ['Nons',str, 's'];
    end
    if j >= 3
        str = ['Test',str];
    else
        str = ['Train',str];
    end
    fileList = dir(str);
    for i = 3:size(fileList)
        if strcmp(fileList(i).name,'Thumbs.db')
        else
            img = imread([str '/' fileList(i).name]);
            % TODO: insert code of function call here to operate on image.
            featureVector = extractFeatures(img, numOfGridSquares, numberOfFeatures);
            % Hint: debug the loop body on 1-2 images BEFORE looping over lots of
            % them...\
            bigMatrix = vertcat(bigMatrix,featureVector);
            if j==1 || j == 3
                sunsetOrNot = vertcat(sunsetOrNot,[1 , j]);
            else
                sunsetOrNot = vertcat(sunsetOrNot,[-1, j]);
            end
        end
    end
end
bigMatrix = normalizeFeatures01(bigMatrix, featuresPerGridBox, numberOfFeatures);

save('values.mat','bigMatrix','sunsetOrNot');