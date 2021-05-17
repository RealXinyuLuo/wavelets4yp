function images = mixedimages(signal_number, signal_length)
images = zeros(signal_length,signal_number);

for k = 1 : signal_number
    
    n = randi(5);
    
    %sine wave
    if n == 1
       increment = 2*pi/signal_length;
       t = [0:increment:2*pi-increment];
%        t_length = numel(t);
       amp = randi(10);
       freq = randi(3);
       shift = randi(10);

       signal = amp*sin(freq*t+shift);
       signal = signal';
       signal = normalize(signal,'range');
       images(:,k) = signal;
    end
    
    %pulse signal
    if n == 2
        pulse_point = randi(signal_length);
        images(pulse_point,k) = randi(10);
    end
    
    %random noise
    if n == 3
        images(:,k) = rand(signal_length,1);
    end
    
    %squarewave
    if n == 4
       increment = 2*pi/signal_length;
       t = [0:increment:2*pi-increment];
       amp = randi(5);
       freq = randi(3);
       shift = randi(2);
       signal = amp*square(freq*t+shift);
       signal = signal';
       signal = normalize(signal,'range');
       images(:,k) = signal;
    end
    
    %sawtooth
    if n == 5
       increment = 2*pi/signal_length;
       t = [0:increment:2*pi-increment];
       amp = randi(5);
       freq = randi(3);
       shift = randi(2);
       signal = amp*sawtooth(freq*t+shift);
       signal = signal';
       signal = normalize(signal,'range');
       images(:,k) = signal;
    end
    
    
% %     %step
%     if n == 6
%         increment = 2/signal_length;
%        t = (-1:increment:1-increment)';
%        shift = randn;
%        shift_vec = ones(numel(t),1).*shift;
%        amplitude = randn;
%        unitstep = t>=0;
%        signal = (unitstep+shift_vec).*amplitude;
%        images(:,k) = signal;
%     end
%     
%     %ramp
%     if n == 7
%         increment = 2/signal_length;
%        t = (-1:increment:1-increment)';
%        unitstep = t>=randn;
%        signal = t.*unitstep;
%        images(:,k) = signal;
%     end
    
    
    
end
    





end