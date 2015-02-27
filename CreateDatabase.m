function [ DataB ] = CreateDataB( extracts, NLevels )
%This function creates a DataB of extracts with NLevels of signatures

%number of entries in DataB
DataB.NEntry = length(extracts);
%find minimum length
MinLen = Inf;

for j = 1:DataB.NEntry
    [ex2ch,fs_ex,nb_ex] = wavread(extracts{j});
    ex                  = ex2ch(:,1);
    l_ex                = length(ex);
    if (l_ex < MinLen)
        MinLen = l_ex;
    end
end
%audio length
DataB.Length = MinLen;
DataB.NSign  = NLevels;
DataB.NFreq  = fs_ex*2.^(0:(NLevels-1));
%loop through extracts and:
%1 - read and trim extracts to MinLen
%2 - perform and store fft's at all levels
for k = 1:DataB.NEntry
    [ex2ch,fs_ex,nb_ex] = wavread(extracts{k});
    ex                  = ex2ch(:,1);
    %trim and store
    DataB.Entry(k).wav      = ex(1:DataB.Length);
    DataB.Entry(k).SampFreq = fs_ex;
    DataB.Entry(k).NBit     = nb_ex;
    DataB.Entry(k).Name     = extracts{k};
    %perform and store fft's at all levels
    DataB.Entry(k).Sign = zeros(DataB.NFreq(NLevels),DataB.NSign);
    for n = 1:DataB.NSign
        nfreq = DataB.NFreq(n);
        signature  = fft(DataB.Entry(k).wav,nfreq);
        DataB.Entry(k).Sign(1:nfreq,n) = abs(signature(:,1));
    end
end



end

