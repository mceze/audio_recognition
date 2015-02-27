clc
clear all
close all


%[ex,fs_ex,nb_ex] = wavread('8sec_extract_audio_cesar&paulinho.wav');
%[ex,fs_ex,nb_ex] = wavread('8segundosAssinatura_MINISTERIO_TURISMO.wav');
[ex,fs_ex,nb_ex] = wavread('8sec_MT.wav');
%[ex,fs_ex,nb_ex] = wavread('8sec_cezar&paulinho.wav');
%[ex,fs_ex,nb_ex] = wavread('OFERECIMENTO_LOREAL.wav');
%[fa,fs_fa,nb_fa] = wavread('full_ad_audio.wav');
%[fa,fs_fa,nb_fa] = wavread('REGRAVADO_Bloco_1226103937AnalogTV17_6.wav');
[fa,fs_fa,nb_fa] = wavread('full_5min.wav');

l_ex = length(ex);%length of extract
l_fa = length(fa);%length of full ad

if (fs_ex ~= fs_fa)
    error('sample frequency mismatch')
end

n_freq = fs_ex*2^0;
%n_freq = l_ex;

nch_ex  = size(ex,2);
nch_fa  = size(fa,2);
if (nch_ex ~= nch_fa)
    error('channel mismatch')
end
t_cpu_st = cputime;
ex_fft = fft(ex,n_freq);

shift = 1; %discard first 'shift' samples
%delta = floor(0.5e-2*l_fa); % 0.1% of total length
delta = floor(fs_ex/5); %% 1 second
k = 1; 
while ((shift+l_ex) <= l_fa)
    %trial extract
    extr = fa(shift:shift+l_ex-1,:);
    extr_fft = fft(extr,n_freq);
    %match 'probability' channel n
    for j = 1:nch_ex
        pr_ch(j) = abs(ex_fft(:,j))'*abs(extr_fft(:,j))/(norm(ex_fft(:,j))*norm(extr_fft(:,j)));
    end
    pr(k,:) = mean(pr_ch);
    pos(k) = shift/fs_ex;
    k = k+1;
    shift = shift + delta;
end

[pr_max,idx] = max(pr);
t_st = pos(idx);

cpu_elapsed_time = cputime-t_cpu_st

figure(1)
plot(pos,pr,'b')
hold on
plot([t_st;t_st],[min(pr);pr_max],'r')
text(pos(idx)+0.2,0.5*(min(pr)+pr_max),strcat('T ~ ',num2str(t_st),' Pr = ',num2str(pr_max)))
hold off
xlabel('Start time (sec)')
ylabel('Probability')
