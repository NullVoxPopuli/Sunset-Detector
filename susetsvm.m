clear all
% create the svm
net = svm(294,'rbf',[6]);

%load the data
bigMatrix = load('values.mat','bigMatrix');
sunsetOrNot = load('values.mat','sunsetOrNot');

lastTrainer = find(sunsetOrNot == 2);
lastTrainer = lastTrainer(size(lastTrainer))-size(sunsetOrNot,1);

net = svmtrain(net, bigMatrix(1:lastTrainer,:),sunsetOrNot(1:lastTrainer,1));

[detected, distance] = svmfwd(net,bigMatrix(lastTrainer+1:size(bigMatrix,1),:));

right = detected == sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);
wrong = detected ~= sunsetOrNot(lastTrainer+1:size(sunsetOrNot),1);
