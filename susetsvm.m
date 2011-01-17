function [right, wrong] = susetsvm()
    clear all
    bigMatrix = [];
    sunsetOrNot = [];
    
    % create the svm
    gridSquareSize = 7; % 7x7 Grid
    colorChannels = 3; % LST
    colorFeatures = 2; % mean and variance
    featuresPerGridBox = colorChannels * colorFeatures;
    numberOfFeatures = (gridSquareSize^2) * colorChannels * colorFeatures;
    
    net = svm(numberOfFeatures,'rbf',[featuresPerGridBox]);
    
    if exist('values.mat', 'file')
        %load the data
        bigMatrix = loadStructFromFile('values.mat','bigMatrix'); 
        sunsetOrNot = loadStructFromFile('values.mat','sunsetOrNot'); 
    else
        %if the data doesn't exist, we should create it.
        [bigMatrix, sunsetOrNot] = imageFolderReader();
    end



    lastTrainer = find(sunsetOrNot == 2);
    lastTrainer = lastTrainer(size(lastTrainer))-size(sunsetOrNot,1);

    net = svmtrain(net, bigMatrix(1:lastTrainer,:),sunsetOrNot(1:lastTrainer,1));

    [detected, distance] = svmfwd(net,bigMatrix(lastTrainer+1:size(bigMatrix,1),:));

    right = detected == sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);
    wrong = detected ~= sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);

%
% Because .mat files are stored as structs, we use a helper
% method to get the struct out of the file.
%
function result = loadStructFromFile(fileName, environmentName) 
    tmp = load(fileName, environmentName);
    result = tmp.(environmentName); 