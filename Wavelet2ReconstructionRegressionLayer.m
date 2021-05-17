classdef Wavelet2ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = TestRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Output layer for 2 coefficient wavelet reconstruction learning';
        end
        
        function loss = forwardLoss(layer, Y, T)
            isYsingle = fi(Y);
            isYsingle = issingle(isYsingle);
            
      %T updates with a new column after each sample in the minibatch,
                                % So we need to make sure we are using the
                                % latest column
            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
            loss = 0;
            
            for k = 1 : minibatch_size
                
%                 Df = Y(1:2,k); % First half of output vector is decomp filter
%                 Df = squeeze(Df);
%                 Rf = Y(3:4,k); % Second half is synthesis filter
%                 Rf = squeeze(Rf);

%                 save test Df Rf % Saving wavelet
%                 familyName = 'test_wavelet';
%                 familyShortName = 'test';
%                 familyWaveType = 2; % 1 = orthogonal wavelet, 2 = biorthoginal wavelet
%                 familyNums      = '';
%                 fileWaveName    = 'test.mat';
%                 wavemngr('add',familyName,familyShortName,familyWaveType, familyNums,fileWaveName)
%                 [LoD,HiD,LoR,HiR] = biorfilt(Df,Rf);
%                 T_k = T(:,k);
%                 [cA,cD] = dwt(T_k,LoD,HiD);
%                 rec = idwt(cA,cD,LoR,HiR);
%                 rec = double(rec);
%                 loss_individual = 1 - ssim(rec,T_k);
%                 loss = loss + loss_individual;   %Adding up loss for the minibatch

                LoD = Y(1:2,k); % First half of output vector is decomp filter
                LoR = Y(3:4,k); % Second half is synthesis filter
%                 HiD = Y(5:6,k);
%                 HiR = Y(7:8,k);
                HiD = LoR;
                HiD(1) = -HiD(1);
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                T = getGlobalImage;
                
                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
                
                loss_individual = immse(rec,T_k);
                loss = loss + loss_individual;   %Adding up loss for the minibatch

%                 wavemngr('del','test'); %Delete current wavelet so new one can be added in the next loop
%                 delete('test.mat')
                
            end
            
            
            
            loss = loss / minibatch_size;
            if isYsingle == 1
            loss = single(loss);
            end
            %loss = single(loss);
            
            % Take mean over mini-batch.
%             N = size(Y,4);
%             loss = sum(meanAbsoluteError)/N;
        end
        function dLdY = backwardLoss(layer, Y, T)

            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
            isYsingle = fi(Y);
            isYsingle = issingle(isYsingle);
            
            dLdY = zeros(s(1),s(2));
            
            for k = 1 : minibatch_size
                
%                 Df = Y(1:2,k); % First half of output vector is decomp filter
%                 Df = squeeze(Df);
%                 Rf = Y(3:4,k); % Second half is synthesis filter
%                 Rf = squeeze(Rf);
%                 [LoD,HiD,LoR,HiR] = biorfilt(Df,Rf);
%                 save test Df Rf % Saving wavelet
%                 familyName = 'test_wavelet';
%                 familyShortName = 'test';
%                 familyWaveType = 2; % 1 = orthogonal wavelet, 2 = biorthoginal wavelet
%                 familyNums      = '';
%                 fileWaveName    = 'test.mat';
%                 wavemngr('add',familyName,familyShortName,familyWaveType, familyNums,fileWaveName)

%                 T_k = T(:,k);
%                 Y_k = Y(:,k);
%                 Y_k = Y_k.^2;
%                 [cA,cD] = dwt(T_k,LoD,HiD);
%                 rec = idwt(cA,cD,LoR,HiR);
%                 rec = double(rec);
% 
%                 diff = rec - T_k; % Element wise difference between reconstructed signal and original signal
%                 diff = diff.^2;
%                 
%                 dLdY(1:4,k) = cost2forDL(diff,LoD,LoR,T_k);
                
                LoD = Y(1:2,k); % First quarter of output vector is LoD
                LoR = Y(3:4,k); % Second quarter is LoR etc
%                 HiD = Y(5:6,k);
%                 HiR = Y(7:8,k);
                HiD = LoR;
                HiD(1) = -HiD(1);
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                T = getGlobalImage;

                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);

                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal
%                 diff = diff.^2;
                
                
                
                dLdY(1:4,k) = cost2forDL(diff,LoD,LoR,T_k);

                
%                 wavemngr('del','test'); %Delete current wavelet so new one can be added in the next loop
%                 delete('test.mat')
            end
            

            
            dLdY = dLdY./minibatch_size;
            
%             YL2norm = norm(Y);
%             YL2norm = YL2norm / (minibatch_size*s(1));
%             
%             dLdY = dLdY+YL2norm;
%             
            if isYsingle == 1
            dLdY = single(dLdY);
            end
            dLdY = single(dLdY);

            
        end
    
            
        end
end