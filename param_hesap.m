function [Parametre] = param_hesap(C)
%UNTÝTLED2 Summary of this function goes here
%   Detailed explanation goes here

Parametre = [];

if C.Param(1) == 1 %spektral hesaplamalar için
    
im = spm_vol(C.Tc);
[I] = spm_read_vols(im{1}); %1 mi??
[spectra, frequencies] = icatb_get_spectra(I' ,C.TR);

boyut = size(spectra,2);
total_val = sum(spectra,2);
total_val_all = repmat(total_val,1,boyut);
spectra_normT = spectra ./ total_val_all;
spectra_normT_mean = mean(spectra_normT,1);

spectra = spectra_normT;

frekans_num = length(frequencies);
lowcutoff = round(frekans_num/3);
highcutoff =round(lowcutoff*2);

lowf = sum(spectra(:,1:lowcutoff),2); % düþük frekans deðerleri.  
higf = sum(spectra(:,highcutoff:end),2); %yüksek frekans deðerleri. 
pow_ratio = lowf./higf; %ikisinin oraný ise power raito deðerini verdi. 

max_val = max(spectra(:,1:lowcutoff),[],2);
min_val = min(spectra(:,highcutoff:end),[],2);
pow_difference = 100*(max_val - min_val);

Parametre.Spektral.Power_Difference = pow_difference;
Parametre.Spektral.Power_Ratio = pow_ratio;

end

if C.Param(2) == 2 %zamansal hesaplamalar için
    
    
    
    
end

if C.Param(3) == 3 %Spasyal hesaplamalar için
    
    
    
end

end

