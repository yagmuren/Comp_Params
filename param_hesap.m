function [Parametre] = param_hesap(C)
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

Parametre = [];

if ismember(1, C.Param) %spektral hesaplamalar için
    for subjind = 1:length(C.Tc)
        %_____Spektrum hesaplamasý_____
        [I] = C.Tc{subjind};
        [spectra, frequencies] = icatb_get_spectra(I', C.TR);
        frekans_num = length(frequencies);
        %_____Spektrumun komponentin toplam gücüne normalizasyonu_____
        total_val = sum(spectra, 2); % comp sum
        spectra_normT = spectra ./ repmat(total_val, 1, frekans_num);
        spectra_normT_mean = mean(spectra_normT,1);
        
        %_____Spektrumun düþük 1/3 ve yüksek 1/3 frekans diliminin hesaplamasý_____
        lowcutoff = round(frekans_num/3);
        Parametre.Spektral.LCF = frequencies(lowcutoff);
        highcutoff =round(frekans_num*2/3) + 1;
        Parametre.Spektral.HCF = frequencies(highcutoff);
        %_____Düþük ve yüksek dilimlerin gücünün hesaplamasý ve power ratio_____
        lowf = sum(spectra_normT(:,1:lowcutoff),2); % düþük frekans deðerleri.
        higf = sum(spectra_normT(:,highcutoff:end),2); %yüksek frekans deðerleri.
        pow_ratio = lowf./higf; %ikisinin oraný ise power ratio deðerini verdi.
        Parametre.Spektral.Power_Ratio{subjind} = pow_ratio;
        
        %_____Düþük ve yüksek dilimlerin _____
        max_val = max(spectra_normT(:,1:lowcutoff),[],2);
        min_val = min(spectra_normT(:,highcutoff:end),[],2);
        pow_difference = 100*(max_val - min_val);
        Parametre.Spektral.Power_Difference{subjind} = pow_difference;
        
        %_____Figür_____
        figure;
        scatter(Parametre.Spektral.Power_Ratio(logical(C.Label)), Parametre.Spektral.Power_Difference(logical(C.Label)),'filled')
        hold on
        scatter(Parametre.Spektral.Power_Ratio(~logical(C.Label)), Parametre.Spektral.Power_Difference(~logical(C.Label)))
    end
end
if ismember(2, C.Param) %zamansal hesaplamalar için
    
    
    
    
end

if ismember(3, C.Param) %Spasyal hesaplamalar için
    for subjind = 1:size(C.Map,1)
    
    end
end



