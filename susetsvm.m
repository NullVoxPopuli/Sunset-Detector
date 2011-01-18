function [right, wrong] = susetsvm()
    clear all
    bigMatrix = [];
    sunsetOrNot = [];
    
    % create the svm
    numOfGridSquares = 7; % 7x7 Grid
    colorChannels = 3; % LST
    colorFeatures = 2; % mean and variance
    featuresPerGridBox = colorChannels * colorFeatures;
    numberOfFeatures = (numOfGridSquares^2) * colorChannels * colorFeatures;
    
    net = svm(numberOfFeatures,'rbf',[7]);
    
    if exist('values.mat', 'file')
        %load the data
        bigMatrix = loadStructFromFile('values.mat','bigMatrix'); 
        sunsetOrNot = loadStructFromFile('values.mat','sunsetOrNot'); 
    else
        %if the data doesn't exist, we should create it.
        [bigMatrix, sunsetOrNot] = imageFolderReader(featuresPerGridBox, numOfGridSquares, numberOfFeatures);
    end

    

    lastTrainer = find(sunsetOrNot == 2);
    lastTrainer = lastTrainer(size(lastTrainer))-size(sunsetOrNot,1);

    net = svmtrain(net, bigMatrix(1:lastTrainer,:),sunsetOrNot(1:lastTrainer,1));

    [detected, distance] = svmfwd(net,bigMatrix(lastTrainer+1:size(bigMatrix,1),:));

    right = detected == sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);
    wrong = detected ~= sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);
    
    numRight = find(right > 0);
    numWrong = find(wrong > 0);
    
    fprintf('\n\nOf the %d tested images:', length(detected));
    fprintf('\n\tThere are %d discovered sunsets', length(numRight));
    fprintf('\n\tand %d that are not sunsets.\n\n', length(numWrong));
    
    [actualSunsets, actualNonSunsets] = countSunsetsAndNonSunsetsForTestData(sunsetOrNot);
    
    fprintf('\nThe Correct Answer is: (out of %d)', length(find(sunsetOrNot >= 3)));
    fprintf('\n \t%d Sunsets \n \t%d NonSunsets\n\n', actualSunsets, actualNonSunsets);
end


%
% Because .mat files are stored as structs, we use a helper
% method to get the struct out of the file.
%
function result = loadStructFromFile(fileName, environmentName) 
    tmp = load(fileName, environmentName);
    result = tmp.(environmentName); 
end   

function [actualSunsets, actualNonSunsets] = countSunsetsAndNonSunsetsForTestData(sunsetOrNot)
    actualSunsets = length(find(sunsetOrNot == 3));
    actualNonSunsets = length(find(sunsetOrNot == 4));
end