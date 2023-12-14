function pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
%%  pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
% Features = pozymiai_raidems_atpazinti(image_file_name, Number_of_symbols_lines)
% taikymo pavyzdys:
% pozymiai = pozymiai_raidems_atpazinti('test_data.png', 8); 
% example of function use:
% Feaures = pozymiai_raidems_atpazinti('test_data.png', 8);
%%
% Vaizdo su pavyzdžiais nuskaitymas | Read image with written symbols
V = imread(pavadinimas);
figure(12), imshow(V)
%% Raidžių iškirpimas ir sudėliojimas į kintamojo 'objektai' celes |
%% Perform segmentation of the symbols and write into cell variable 
% RGB image is converted to grayscale
V_pustonis = rgb2gray(V);
% vaizdo keitimo dvejetainiu slenkstinės reikšmės paieška
% a threshold value is calculated for binary image conversion
slenkstis = graythresh(V_pustonis);
% pustonio vaizdo keitimas dvejetainiu
% a grayscale image is converte to binary image
V_dvejetainis = im2bw(V_pustonis,slenkstis);
% rezultato atvaizdavimas
% show the resulting image
% figure(1), imshow(V_dvejetainis)
% vaizde esančių objektų kontûrų paieška
% search for the contour of each object
V_konturais = edge(uint8(V_dvejetainis));
% rezultato atvaizdavimas
% show the resulting image
% figure(2),imshow(V_konturais)
% objektų kontûrų užpildymas 
% fill the contours
se = strel('square',7); % struktûrinis elementas užpildymui
V_uzpildyti = imdilate(V_konturais, se); 
% rezultato atvaizdavimas
% show the result
figure(3),imshow(V_uzpildyti)
% tuštumų objetų viduje užpildymas
% fill the holes
V_vientisi= imfill(V_uzpildyti,'holes');
% rezultato atvaizdavimas
% show the result
figure(4),imshow(V_vientisi)
% vientisų objektų dvejetainiame vaizde numeravimas
% set labels to binary image objects
[O_suzymeti Skaicius] = bwlabel(V_vientisi);
% apskaičiuojami objektų dvejetainiame vaizde požymiai
% calculate features for each symbol
O_pozymiai = regionprops(O_suzymeti);
% nuskaitomos požymių - objektų ribų koordinačių - reikšmės
% find/read the bounding box of the symbol
O_ribos = [O_pozymiai.BoundingBox];
% kadangi ribą nusako 4 koordinatės, pergrupuojame reikšmes
% change the sequence of values, describing the bounding box
O_ribos = reshape(O_ribos,[4 Skaicius]); % Skaicius - objektų skaičius
% nuskaitomos požymių - objektų masės centro koordinačių - reikšmės
% reag the mass center coordinate
O_centras = [O_pozymiai.Centroid];
% kadangi centrą nusako 2 koordinatės, pergrupuojame reikšmes
% group center coordinate values
O_centras = reshape(O_centras,[2 Skaicius]);
O_centras = O_centras';
% pridedamas kiekvienam objektui vaize numeris (trečias stulpelis šalia koordinačių)
% set the label/number for each object in the image
O_centras(:,3) = 1:Skaicius;
% surûšiojami objektai pagal x koordinatæ - stulpelį
% arrange objects according to the column number
O_centras = sortrows(O_centras,2);
% rûšiojama atsižvelgiant į pavyzdžių eilučių ir raidžių skaičių
% sort accordign to the number of rows and number of symbols in the row
raidziu_sk = Skaicius/pvz_eiluciu_sk;
for k = 1:pvz_eiluciu_sk
    O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:) = ...
        sortrows(O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:),3);
end
% iš dvejetainio vaizdo pagal objektų ribas iškerpami vaizdo fragmentai
% cut the symbol from initial image according to the bounding box estimated in binary image
for k = 1:Skaicius
    objektai{k} = imcrop(V_dvejetainis,O_ribos(:,O_centras(k,3)));
end
% vieno iš vaizdo fragmentų atvaizdavimas
% show one of the symbol's image
% figure(5),
% for k = 1:Skaicius
%    subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
% end
% vaizdo fragmentai apkerpami, panaikinant foną iš kraštų (pagal stačiakampį)
% image segments are cutt off
for k = 1:Skaicius % Skaicius = 88, jei yra 88 raidės
    V_fragmentas = objektai{k};
    % nustatomas kiekvieno vaizdo fragmento dydis
    % estimate the size of each segment
    [aukstis, plotis] = size(V_fragmentas);
    
    % 1. Baltų stulpelių naikinimas
    % eliminate white spaces
    % apskaičiuokime kiekvieno stulpelio sumą
    stulpeliu_sumos = sum(V_fragmentas,1);
    % naikiname tuos stulpelius, kur suma lygi aukščiui
    V_fragmentas(:,stulpeliu_sumos == aukstis) = [];
    % perskaičiuojamas objekto dydis
    [aukstis, plotis] = size(V_fragmentas);
    % 2. Baltų eilučių naikinimas
    % apskaičiuokime kiekvienos seilutės sumą
    eiluciu_sumos = sum(V_fragmentas,2);
    % naikiname tas eilutes, kur suma lygi pločiui
    V_fragmentas(eiluciu_sumos == plotis,:) = [];
    objektai{k}=V_fragmentas;% įrašome vietoje neapkarpyto
end
% vieno iš vaizdo fragmentų atvaizdavimas
% show the segment
figure(6),
for k = 1:Skaicius
   subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
end
%%
%% Suvienodiname vaizdo fragmentų dydžius iki 70x50
%% Make all segments of the same size 70x50
for k=1:Skaicius
    V_fragmentas=objektai{k};
    V_fragmentas_7050=imresize(V_fragmentas,[70,50]);
    % padalinkime vaizdo fragmentą į 10x10 dydžio dalis
    % divide each image into 10x10 size segments
    for m=1:7
        for n=1:5
            % apskaičiuokime kiekvienos dalies vidutinį šviesumą 
            % calculate an average intensity for each 10x10 segment
            Vid_sviesumas_eilutese=sum(V_fragmentas_7050((m*10-9:m*10),(n*10-9:n*10)));
            Vid_sviesumas((m-1)*5+n)=sum(Vid_sviesumas_eilutese);
        end
    end
    % 10x10 dydžio dalyje maksimali šviesumo galima reikšmė yra 100
    % normuokime šviesumo reikšmes intervale [0, 1]
    % perform normalization
    Vid_sviesumas = ((100-Vid_sviesumas)/100);
    % rezultatą (požmius) neuronų tinklui patogiau pateikti stulpeliu
    % transform features into column-vector
    Vid_sviesumas = Vid_sviesumas(:);
    % išsaugome apskaičiuotus požymius į bendrą kintamąjį
    % save all fratures into single variable
    pozymiai{k} = Vid_sviesumas;
end