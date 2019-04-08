%Bu script Gift ��kt�lar� olan komponentlerden ileri analizler i�in
%params.mat dosyas�n� olu�turur.
%%Gerekli bilgiler
% 1.Gift analizi sonucunda elde edilen *.zip dosyalar�n�n bulundu�u _scaling_components_files dosya konumu
% 2.GICA sonucu elde edilen komponentlerin uzman taraf�ndan sinyal/g�r�lt�
% olarak ayr�ld��� *.txt dosyas�
% 3.�ekim TR'�
% 4.Elde edilmi� komponent say�s�
% 25.03.2019 Elif Nuran YA�MUR

clear all

Input_defaultanswer = {'','','',''};
list = {'spektral','temporal','spasyal'};
while 1 % Ana ekranda cancel denmedi�i s�rece ��kmaz. 
    input = inputdlg({'Analiz Dosya Yolu', 'Labels.txt Konumu', 'TR', 'Komponent Adedi'},...
        'Input', [1 100; 1 100; 1 20;1 20], Input_defaultanswer);
    if isempty(input)
        return
    end
    if ~exist(input{1}, 'dir')
        f = errordlg('Analiz Dosya Yolu bulunamad�','Hata!'); waitfor(f);
        Input_defaultanswer = input; %�nceki ekran�n yan�t�n� saklar.
        continue
    end
    if ~exist(input{2}, 'file')
        f = errordlg('Labels.txt Konumu bulunamad�','Hata!'); waitfor(f);
        Input_defaultanswer = input; %�nceki ekran�n yan�t�n� saklar.
        continue
    end
    if ~isa(input{3}, 'numeric')
        f = errordlg('TR hatal�','Hata!'); waitfor(f);
        Input_defaultanswer = input; %�nceki ekran�n yan�t�n� saklar.
        continue
    end
    if ~isa(input{4}, 'numeric')
        f = errordlg('Komponent Adedi hatal�','Hata!'); waitfor(f);
        Input_defaultanswer = input; %�nceki ekran�n yan�t�n� saklar.
        continue
    end
    
    indx = listdlg('ListString',list,'ListSize',[250 200],'Name','Parametre Se�imi');
    if isempty(indx)
        Input_defaultanswer = input; %�nceki ekran�n yan�t�n� saklar.
        continue
    else
        break
    end
end
C.Param = indx;

Dosya = input{1};
oldfolder = cd(Dosya);

zip_files = dir('*.zip');
subj_num = numel(zip_files);
for i = 1:subj_num
    Dosyalar(:,i) = unzip(zip_files(i).name,fullfile(Dosya,'unzipped'));
end

cd(oldfolder);


map_dir = sort(Dosyalar)';
map_dir(:,[2:2:end])=[];

comp_num = str2double(input(4));

C.Map = map_dir(:,[1:comp_num]);
C.Tc = map_dir(:,end);

input(3,1)= strrep(input(3),',','.');
TR = str2double(input(3));

fileID = fopen(string(input(2)));
format= '%f';
Label= fscanf(fileID,format);
Labels = repelem(Label,1, subj_num)';


C.TR = TR;
C.Label =Labels;

clearvars -except C

if isempty(C.Param) == 0 ;
    
    param_hesap(C);
    
end

save('Params.mat')