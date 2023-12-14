close all
clear all
clc
%% raidžių pavyzdžių nuskaitymas ir požymių skaičiavimas
%% read the image with hand-written characters
pavadinimas = 'abc_training.png';
% pozymiai_tinklo_mokymui = pozymiai_raidems_atpazinti(pavadinimas, 8);
%% Atpažintuvo kûrimas
%% Development of character recognizer
% požymiai iš celių masyvo perkeliami į matricą
% P = cell2mat(pozymiai_tinklo_mokymui);
% save("Pval.mat","P");
Z = load("P.mat");
P = fieldnames(Z);
for i = 1:length(P)
    assignin('base', P{i}, Z.(P{i}));
end
% sukuriama teisingų atsakymų matrica: 11 raidžių, 8 eilutės mokymui
% create the matrices of correct answers for each line (number of matrices = number of symbol lines)
T = [eye(11), eye(11), eye(11), eye(11), eye(11), eye(11),eye(11),eye(11)];
% sukuriamas SBF tinklas duotiems P ir T sąryšiams
% create an RBF network for classification with 13 neurons, and sigma = 1
% tinklas = newrb(P,T,0,1,11);
tinklas = feedforwardnet([60],'trainbr');
tinklas.trainParam.max_fail = 20;
tinklas.trainParam.min_grad = 1e-12;
tinklas.trainParam.epochs = 2000;
tinklas = train(tinklas,P,T);
%% Tinklo patikra | Test of the network (recognizer)
% skaičiuojamas tinklo išėjimas nežinomiems požymiams
% estimate output of the network for unknown symbols (row, that were not used during training)
P2 = P(:,12:22);
Y2 = sim(tinklas, P2);
% ieškoma, kuriame išėjime gauta didžiausia reikšmė
% find which neural network output gives maximum value
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas
%% Visualize result
% apskaičiuosime raidžių skaičių - požymių P2 stulpelių skaičių
% calculate the total number of symbols in the row
raidziu_sk = size(P2,2);
% rezultatą saugosime kintamajame 'atsakymas'
% we will save the result in variable 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            % the symbol here should be the same as written first symbol in your image
            atsakymas = [atsakymas, 'A'];
        case 2
            atsakymas = [atsakymas, 'B'];
        case 3
            atsakymas = [atsakymas, 'C'];
        case 4
            atsakymas = [atsakymas, 'D'];
        case 5
            atsakymas = [atsakymas, 'E'];
        case 6
            atsakymas = [atsakymas, 'F'];
        case 7
            atsakymas = [atsakymas, 'G'];
        case 8
            atsakymas = [atsakymas, 'H'];
        case 9
            atsakymas = [atsakymas, 'I'];
        case 10
            atsakymas = [atsakymas, 'K'];
        case 11
            atsakymas = [atsakymas, 'J'];
    end
end
% pateikime rezultatą komandiniame lange
% show the result in command window
disp(atsakymas)
% % figure(7), text(0.1,0.5,atsakymas,'FontSize',38)
%% žodžio "KADA" požymių išskyrimas 
%% Extract features of the test image
pavadinimas = 'test_kada.png';
pozymiai_patikrai = pozymiai_raidems_atpazinti(pavadinimas, 1);

%% Raidžių atpažinimas
%% Perform letter/symbol recognition
% požymiai iš celių masyvo perkeliami į matricą
% features from cell-variable are stored to matrix-variable
P2 = cell2mat(pozymiai_patikrai);
% skaičiuojamas tinklo iššjimas nežinomiems požymiams
% estimating neuran network output for newly estimated features
Y2 = sim(tinklas, P2);
% ieškoma, kuriame iššjime gauta didžiausia reikšmš
% searching which output gives maximum value
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas | Visualization of result
% apskaičiuosime raidžių skaičių - požymių P2 stulpelių skaičių
% calculating number of symbols - number of columns
raidziu_sk = size(P2,2);
% rezultatą saugosime kintamajame 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            atsakymas = [atsakymas, 'A'];
        case 2
            atsakymas = [atsakymas, 'B'];
        case 3
            atsakymas = [atsakymas, 'C'];
        case 4
            atsakymas = [atsakymas, 'D'];
        case 5
            atsakymas = [atsakymas, 'E'];
        case 6
            atsakymas = [atsakymas, 'F'];
        case 7
            atsakymas = [atsakymas, 'G'];
        case 8
            atsakymas = [atsakymas, 'H'];
        case 9
            atsakymas = [atsakymas, 'I'];
        case 10
            atsakymas = [atsakymas, 'K'];
        case 11
            atsakymas = [atsakymas, 'J'];
    end
end
% pateikime rezultatą komandiniame lange
% disp(atsakymas)
figure(8), text(0.1,0.5,atsakymas,'FontSize',38), axis off
%% žodžio "FIKCIJA" požymių išskyrimas 
%% extract features for next/another test image
pavadinimas = 'test_fikcija.png';
pozymiai_patikrai = pozymiai_raidems_atpazinti(pavadinimas, 1);

%% Raidžių atpažinimas
% požymiai iš celių masyvo perkeliami į matricą
P2 = cell2mat(pozymiai_patikrai);
% skaičiuojamas tinklo iššjimas nežinomiems požymiams
Y2 = sim(tinklas, P2);
% ieškoma, kuriame iššjime gauta didžiausia reikšmš
[a2, b2] = max(Y2);
%% Rezultato atvaizdavimas
% apskaičiuosime raidžių skaičių - požymių P2 stulpelių skaičių
raidziu_sk = size(P2,2);
% rezultatą saugosime kintamajame 'atsakymas'
atsakymas = [];
for k = 1:raidziu_sk
    switch b2(k)
        case 1
            atsakymas = [atsakymas, 'A'];
        case 2
            atsakymas = [atsakymas, 'B'];
        case 3
            atsakymas = [atsakymas, 'C'];
        case 4
            atsakymas = [atsakymas, 'D'];
        case 5
            atsakymas = [atsakymas, 'E'];
        case 6
            atsakymas = [atsakymas, 'F'];
        case 7
            atsakymas = [atsakymas, 'G'];
        case 8
            atsakymas = [atsakymas, 'H'];
        case 9
            atsakymas = [atsakymas, 'I'];
        case 10
            atsakymas = [atsakymas, 'K'];
        case 11
            atsakymas = [atsakymas, 'J'];
    end
end
% pateikime rezultatą komandiniame lange
% disp(atsakymas)
figure(9), text(0.1,0.5,atsakymas,'FontSize',38), axis off

