function [ N_match, pos_match ] = CheckIfAudioExists(extract,full_recording,Prob_threshold)
%This function checks if the audio in "extract" exists in
%"full_recording" under a probaility "Prob_threshold"
% N_match: number of occurences
% pos: array of time positions for occurrences

[ex2ch,fs_ex,nb_ex] = wavread(extract);
[fa2ch,fs_fa,nb_fa] = wavread(full_recording);
ex = ex2ch(:,1);
fa = fa2ch(:,1);
n_levels = 3; %number of fft's frequency-slot levels

l_ex = length(ex);%length of extract
t_ex = l_ex/fs_ex;%total time length of extract
l_fa = length(fa);%length of full ad

if (fs_ex ~= fs_fa)
    error('sample frequency mismatch')
end

N_match = 0;
pos_match(1) = -1;
pr_max_prev = 0;
for level = 0:n_levels
    n_freq = 0.5*fs_ex*2^level;
    
    
    nch_ex  = size(ex,2);
    nch_fa  = size(fa,2);
    if (nch_ex ~= nch_fa)
        error('channel mismatch')
    end
    
    ex_fft = fft(ex,n_freq);
    
    shift = 1; %discard first 'shift' samples
    %delta = floor(0.5e-2*l_fa); % 0.1% of total length
    delta = floor(fs_ex); %% 1 second
    k = 1;
    clear pr_ch 
    clear pr 
    clear pos
    while ((shift+l_ex) <= l_fa)
        %trial extract
        extr = fa(shift:shift+l_ex-1,:);
        extr_fft = fft(extr,n_freq);
        %match 'probability' channel n
        for j = 1:nch_ex
            pr_ch(j) = abs(ex_fft(:,j))'*abs(extr_fft(:,j))/(norm(ex_fft(:,j))*norm(extr_fft(:,j)));
        end
        pr(k) = mean(pr_ch);
        pos(k) = shift/fs_ex;
        k = k+1;
        shift = shift + delta;
    end
    [pr_max,idx] = max(pr);
    if (pr_max < pr_max_prev)
        return % when a match exists, the probability increases with refinement levels
    end
    pr_max_prev = pr_max;
    t_st = pos(idx);
    if (pr_max >= Prob_threshold)
        N_m = 0;
        for k = 1:length(pr)
            if (pr(k) >= Prob_threshold)
                N_m = N_m + 1;
                pos_m(N_m) = pos(k);
            end
        end
        
        if (N_m > 0)
            [N_match_new,pos_match] = LumpEntriesWithinR(N_m,pos_m,t_ex);
            if (N_match_new == N_match)
                return
            else
                N_match = N_match_new;
            end
        end
        %return
    end
end


end

