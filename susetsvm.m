function [tpr,fpr] = susetsvm(width)
    warning('OFF');
    bigMatrix = [];
    sunsetOrNot = [];
    
    % create the svm
    numOfGridSquares = 7; % 7x7 Grid
    colorChannels = 3; % LST
    colorFeatures = 2; % mean and variance
    featuresPerGridBox = colorChannels * colorFeatures;
    numberOfFeatures = (numOfGridSquares^2) * colorChannels * colorFeatures;
    
    net = svm(numberOfFeatures,'rbf',[width]);    
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
    fprintf('\n\tThere are %d correctly detected', length(numRight));
    fprintf('\n\tand %d that are incorrectly detected.\n\n', length(numWrong));
    
    [actualSunsets, actualNonSunsets] = countSunsetsAndNonSunsetsForTestData(sunsetOrNot);
    findTruePositive(detected,sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1));
    fprintf('\nThe Correct Answer is: (out of %d)', length(find(sunsetOrNot >= 3)));
    fprintf('\n \t%d Sunsets \n \t%d NonSunsets\n\n', actualSunsets, actualNonSunsets);
    [tpr,fpr] = makeRocCurve(distance,sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1));
end

function [tpr,fpr] = makeRocCurve(distances,actual)
    tpr = [];
    fpr = [];
    for i = -1:0.1:1
        detected = double(distances > i);
        detected(detected == 0) = -1;
        [tp,fp,tn,fn] = findTruePositive(detected,actual);
        tpr = horzcat(tpr, tp/(tp+fn));
        fpr = horzcat(fpr, fp/(fp+tn));
    end
    roc(tpr,fpr);
end

function [tp,fp,tn,fn] = findTruePositive(detected,actual)
    tp = size(find(detected == 1 & detected == actual),1);
%     fprintf('\n The number of true positives is: %f',tp)
    fp = size(find(detected == 1 & detected ~= actual),1);
%     fprintf('\n The number of false positives is: %f',fp)
    tn = size(find(detected == -1 & detected == actual),1);
%     fprintf('\n The number of true negatives is: %f',tn)
    fn = size(find(detected == -1 & detected ~= actual),1);
%     fprintf('\n The number of false negatives is: %f',fn)
%     fprintf('\n True Positive rate %f',tp/(tp+fn))
%     fprintf('\n False Positive rate %f',fp/(fp+tn))
%     fprintf('\n Accuracy: %f',(tp+tn)/(tp+fp+tn+fn))
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