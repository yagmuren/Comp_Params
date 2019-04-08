%Bu script Gift çýktýlarý olan komponentlerden ileri analizler için
%params.mat dosyasýný oluþturur.
%%Gerekli bilgiler
% 1.Gift analizi sonucunda elde edilen *.zip dosyalarýnýn bulunduðu _scaling_components_files dosya konumu
% 2.GICA sonucu elde edilen komponentlerin uzman tarafýndan sinyal/gürültü
% olarak ayrýldýðý *.txt dosyasý
% 3.çekim TR'ý
% 4.Elde edilmiþ komponent sayýsý
% 25.03.2019 Elif Nuran YAÐMUR

clear all

Input_defaultanswer = {'';'';'';''};
list = {'spektral','temporal','spasyal'};
while 1 % Ana ekranda cancel denmediði sürece çýkmaz. 
    input = inputdlg({'Analiz Dosya Yolu', 'Labels.txt Konumu', 'TR', 'Komponent Adedi'},...
        'Input', [1 100; 1 100; 1 20;1 20], Input_defaultanswer);
    if isempty(input)
        return
    end
    if ~exist(input{1}, 'dir')
        f = errordlg('Analiz Dosya Yolu bulunamadý','Hata!'); waitfor(f);
        Input_defaultanswer = input; %Önceki ekranýn yanýtýný saklar.
        continue
    end
    if ~exist(input{2}, 'file')
        f = errordlg('Labels.txt Konumu bulunamadý','Hata!'); waitfor(f);
        Input_defaultanswer = input; %Önceki ekranýn yanýtýný saklar.
        continue
    end
    if isnan(str2double(input{3})) || (str2double(input{3}) < 0)
        f = errordlg('TR hatalý','Hata!'); waitfor(f);
        Input_defaultanswer = input; %Önceki ekranýn yanýtýný saklar.
        continue
    end
    if isnan(str2double(input{4})) || (str2double(input{4}) < 0)
        f = errordlg('Komponent Adedi hatalý','Hata!'); waitfor(f);
        Input_defaultanswer = input; %Önceki ekranýn yanýtýný saklar.
        continue
    end
    
    indx = listdlg('ListString',list,'ListSize',[250 200],'Name','Parametre Seçimi');
    if isempty(indx)
        Input_defaultanswer = input; %Önceki ekranýn yanýtýný saklar.
        continue
    else
        break
    end
end
C.Param = indx;

%____Zip dosyalarý açýlýyor.________
Dosya = input{1};
%oldfolder = cd(Dosya);
zip_files = dir(fullfile(Dosya, '*.zip'));
subj_num = numel(zip_files);
for i = 1:subj_num
    Dosyalar(:,i) = unzip(fullfile(Dosya, zip_files(i).name), fullfile(Dosya, 'unzipped'));
end
%cd(oldfolder);

%____Ýstenen komponent haritalarýnýn konumlarý ve TC konumu alýnýyor.________
map_dir = sort(Dosyalar)';
map_dir(:,[2:2:end])=[]; % sadece *.hdr dosyalarý

comp_num = str2double(input(4));
max_comp_num = length(map_dir) - 1;
if comp_num > max_comp_num % elimizdeki adetten fazla olamaz.
    comp_num = max_comp_num;
end
C.Map = map_dir(:,[1:comp_num]);
C.Tc = map_dir(:,end);

%____TR alýnýyor.________
C.TR = str2double(input(3));

%____Labels alýnýyor.________
fileID = fopen(input{2});
Label= fscanf(fileID, '%f');
fclose(fileID);
C.Label = repelem(Label,1, subj_num)'; % subj x comp

clearvars -except C input
save(fullfile(input{1}, 'Params.mat'));
[Parametre] = param_hesap(C);