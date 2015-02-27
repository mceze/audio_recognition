function [ DataBN ] = SearchAudioInRecording( DataB, recording, Prob)
%Searches for audio entries in DataB within recording

DataBN = DataB;

%read recording
[rec2ch,rec_fs,rec_nb] = wavread(recording);
rec = rec2ch(:,1);
rec_len = length(rec);

shift  = 1;
delta  = floor(rec_fs); %% 1 second
sg_len = DataBN.Length;

while ((shift+sg_len) <= rec_len)
    %initlialize probability to -1
    ProbE  = -1*ones(DataBN.NSign,DataBN.NEntry);
    for s = 1:DataBN.NSign
        %number of frequency slots for fft
        nfreq = DataBN.NFreq(s);
        %trial extract
        extr = rec(shift:shift+sg_len-1,:);
        extr_Sign = abs(fft(extr,nfreq));
        %loop through entries and find most probable
        for n = 1:DataBN.NEntry
            SignE = DataBN.Entry(n).Sign(s);
            ProbE(s,n) = SignE'*extr_Sign/(norm(SignE)*norm(extr_Sign);
            
        end
    end
end


end

