clear all
close all

extracts = {'8segundosAssinatura_ComercialTomeLeve.wav','8segundosAssinatura_ComercialCesar&Paulinho.wav','OFERECIMENTO_LOREAL.wav','8segundosAssinatura_MINISTERIO_TURISMO.wav'};
fullrec = 'Bloco_concatenado.wav';


DataB = CreateDatabase(extracts,4);


prob = 0.85;


t_cpu_st = cputime;
for j = 1:length(extracts)
    extract(j).name = extracts{j};
    [ extract(j).N, extract(j).pos ] = CheckIfAudioExists(extract(j).name,fullrec,prob);
end
cpu_time = cputime-t_cpu_st