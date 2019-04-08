function [Parametre] = param_hesap(C)
%UNT�TLED2 Summary of this function goes here
%   Detailed explanation goes here

Parametre = [];

if ismember(1, C.Param) %spektral hesaplamalar i�in
    %_____Spektrum hesaplamas�_____
    im = spm_vol(C.Tc);
    [I] = spm_read_vols(im{1});
    [spectra, frequencies] = icatb_get_spectra(I', C.TR);
    frekans_num = length(frequencies);
    %_____Spektrumun komponentin toplam g�c�ne normalizasyonu_____
    total_val = sum(spectra, 2); % comp sum
    spectra_normT = spectra ./ repmat(total_val, 1, frekans_num);
    spectra_normT_mean = mean(spectra_normT,1);
    
    %_____Spektrumun d���k 1/3 ve y�ksek 1/3 frekans diliminin hesaplamas�_____
    lowcutoff = round(frekans_num/3);
    Parametre.Spektral.LCF = frequencies(lowcutoff);
    highcutoff =round(frekans_num*2/3) + 1;
    Parametre.Spektral.HCF = frequencies(highcutoff);
    %_____D���k ve y�ksek dilimlerin g�c�n�n hesaplamas� ve power ratio_____
    lowf = sum(spectra_normT(:,1:lowcutoff),2); % d���k frekans de�erleri.
    higf = sum(spectra_normT(:,highcutoff:end),2); %y�ksek frekans de�erleri.
    pow_ratio = lowf./higf; %ikisinin oran� ise power ratio de�erini verdi.
    Parametre.Spektral.Power_Ratio = pow_ratio;
    
    %_____D���k ve y�ksek dilimlerin _____
    max_val = max(spectra_normT(:,1:lowcutoff),[],2);
    min_val = min(spectra_normT(:,highcutoff:end),[],2);
    pow_difference = 100*(max_val - min_val);
    Parametre.Spektral.Power_Difference = pow_difference;
    
    %_____Fig�r_____
    figure;
    scatter(Parametre.Spektral.Power_Ratio(logical(C.Label)), Parametre.Spektral.Power_Difference(logical(C.Label)),'filled')
    hold on
    scatter(Parametre.Spektral.Power_Ratio(~logical(C.Label)), Parametre.Spektral.Power_Difference(~logical(C.Label)))
end

if ismember(2, C.Param) %zamansal hesaplamalar i�in
    
    
    
    
end

if ismember(3, C.Param) %Spasyal hesaplamalar i�in
    
    
    
end



