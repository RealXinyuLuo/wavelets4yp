training_samples = 12800;
sample_length = 32;
filternumber = 4; % 2 for 2 coefficient network, 4 for 4 coefficient network

%Generating Training data
X = cell(training_samples,1);
s = size(X);
for k = 1 : s(1)
a = mixedimages(1, sample_length);
a = normalize(a,'range');
a = awgn(a,100);
a = normalize(a,'range');
X{k} = a;
end

setGlobalImage(X); %Need to set training data as global to retrieve inside deep learning pipeline

% Generating dummy ground truth (As training data is the ground truth
dummyY = cell(training_samples,1);
s = size(dummyY);

for k = 1:s(1)
    a = zeros(filternumber*2,1);
    dummyY{k} = a;
end

% Defining layers
if filternumber == 2
    layers = [
    sequenceInputLayer([sample_length])
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)
    eluLayer
    Wavelet2ReconstructionRegressionLayer()];
%     Wavelet2EntropyRegressionLayer()];

else
    layers = [
    sequenceInputLayer([sample_length])
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)
    eluLayer
    Wavelet4ReconstructionRegressionLayer()];
end

% Defining training options
options = trainingOptions('sgdm','InitialLearnRate',0.03,'LearnRateSchedule','piecewise','LearnRateDropPeriod',1,'LearnRateDropFactor',0.2,'Momentum',0.9,'GradientThreshold',1,'L2Regularization',0.1,'MaxEpochs',2,'plots','training-progress');

net = trainNetwork(X,dummyY,layers,options);

