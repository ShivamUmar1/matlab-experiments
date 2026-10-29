clc;
clear all; 
close all;

% Read audio files and their sampling frequencies
[x,Fs1]=audioread('C:\Users\HP\Downloads\Audio_Input_1_440Hz_5sec.wav');
[h,Fs2]=audioread('C:\Users\HP\Downloads\Audio_Input_2_660Hz_5sec.wav');

% Convert stereo audio to mono by averaging both channels
if size(x,2)>1
    x=mean(x,2);
end

if size(h,2)>1
    h=mean(h,2);
end

% Check whether both signals have the same sampling frequency
if Fs1~=Fs2
    error('Both audio files must have the same sampling frequency.');
end

% Convert signals into row vectors
x=x(:).';
h=h(:).';

% Generate time axes using sampling frequency
tx=(0:length(x)-1)/Fs1;
th=(0:length(h)-1)/Fs2;

% Perform convolution using the custom function
y=Conv_user(x,h);

% Normalize output to keep peak amplitude approximately within [-1,1]
y=y/(max(abs(y))+eps);

% Generate time axis for convolution output
ty=(0:length(y)-1)/Fs1;

% Create figure and divide it into 3 rows and 1 column
figure;

subplot(3,1,1);
plot(tx,x);
title('First Audio Signal - 440 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(th,h);
title('Second Audio Signal - 660 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(ty,y);
title('Convolution Output');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Play first audio; soundsc automatically scales playback amplitude
soundsc(x,Fs1);
disp('Playing first audio...');
pause(length(x)/Fs1+1); % Wait for playback to finish

% Play second audio
soundsc(h,Fs1);
disp('Playing second audio...');
pause(length(h)/Fs1+1);

% Play convolution output
soundsc(y,Fs1);
disp('Playing convolution output...');

% Save output audio file with the specified sampling frequency
audiowrite('C:\Users\HP\Downloads\Convolution_Output.wav',y(:),Fs1);
disp('Output saved as Convolution_Output.wav');

% Custom function to calculate linear convolution
function y=Conv_user(x,h)
n1=length(x);
n2=length(h);
y=zeros(1,n1+n2-1);
for n=1:length(y)
    for k=max(1,n-n2+1):min(n,n1)
        y(n)=y(n)+x(k)*h(n-k+1);

    end;
end;
end;