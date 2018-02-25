%% Import datasets
I = im2double( imread( 'Im001_1.jpg' ) );
%I = imresize(I, 0.25);
testSet = featureExtraction(I);
% testSet = testSet(:,[1 4]);
[featVectU,~,iFV] = unique((testSet),'rows') ;

if exist(fullfile(pwd, 'Mode.mat'), 'file') == 0
    
    %% training set settings
    classNumbers = 1; % Number of regions of interest
    trainingImagesNumber = 100; % 73, 200, 260;
    trainingSetPixels = 1800;
    opt = 1;
    dbDir = 'ALL_IDB';
    
    %% Sampling and training
    [trainingSet, trainingClasses] = svm.getTrainingSamples( ...
        classNumbers, trainingImagesNumber, trainingSetPixels, dbDir, opt );
    trainingClasses = trainingClasses - 1;
    
    %% SVM Classification
    [Model, predicted] = svm.classify(trainingSet, trainingClasses, featVectU);
    save('ModelloSimone.mat', 'Model');
else
    load('ModelloSimone.mat');
    predicted = svm.predict(Model, featVectU);
end
predicted = predicted(iFV);
p = reshape(predicted, size(I,1), size(I,2));

% [gmag,gdir]=imgradient(p);
%figure(), imshow(I);
figure(), imshowpair(I,p,'montage');