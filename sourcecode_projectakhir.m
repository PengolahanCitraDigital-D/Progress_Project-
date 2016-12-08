gambar_ori = imread ('fractal.png'); %% variabler_ori membaca gambar paper.jpg
figure , %% mengelompokkan figure pertama 
imshow (gambar_ori); %% menampilkan gambar original 
title ('gambar asli'); %% memberi judul untuk figure pertama
%% HSV
%HSV = rgb2hsv (gambar_ori);
%figure , %% mengelompokkan figure kedua
%imshow (HSV); %% menampilkan hasil gambar konversi rgb ke hsv 
%title ('konversi rgb ke hsv');%%memberi judul untuk figure kedua
%convHSV = double (HSV(:,:,2:3)); %% mengambil nilai chanel setiap HSV
%%%% L*A*B
cform = makecform('srgb2lab');
lab_he = applycform(gambar_ori,cform);
figure,
imshow(lab_he);
title ('CIELAB');
convHSV = double (lab_he(:,:,2:3)); 

baris = size (convHSV,1); %% variable baris berfungsi mengambil isi dari baris matrix HueSat 
kolom = size (convHSV,2); %% variable kolom berfungsi mengambil isi dari kolom matrix HueSat
convHSV = reshape (convHSV, baris*kolom ,2); %% membuat matrik baru yang sesuai dengan nilai baris dikali kolom pada variabel HueSat
kluster = 3; %% pengelompokan kluster bedasarkan banyaknya yang akan dikluster sebesar 2 kluster
[centers,U] = fcm(convHSV,kluster); %% melakukan clustering dengan c-means dimana HueSat
                                    %%sebagai data yang diberikan dan
                                    %%kluster sebagai pusat dari cluster
                                    %%center
%% mengklasifikasikan setiap data bedasarkan cluster yang memiki keanggotaan value yang paling besar
maksU = max (U);
index1 = find(U(1,:) == maksU);
index2 = find(U(2,:) == maksU);
index3 = find(U(3,:) == maksU);
%% menandai cluster data dan cluster center 
figure,
plot(convHSV(index1,1),convHSV(index1,2),'ob')
hold on
plot(convHSV(index2,1),convHSV(index2,2),'or')
hold on 
plot(convHSV(index3,1),convHSV(index3,2),'or')
plot(centers(1,1),centers(1,2),'xb','MarkerSize',15,'LineWidth',3)
plot(centers(2,1),centers(2,2),'xr','MarkerSize',15,'LineWidth',3)
title('clustering data dan center ')
hold off
%% melabeli hasil citra yang telah disegmentasi
New_M = zeros (baris,kolom);
New_M (index1) = 1;
New_M (index2) = 2;
New_M (index3) = 3;
label = reshape(New_M,baris,kolom);
RGB = label2rgb(label);
figure,
imshow(RGB,[]), 
title('citra yang telah disegmentasi');


%% mengembalikan warna citra yang telah disegmentasi pada masing-masing klusternya
img = cell(1,3);
labelbyrgb = repmat(label,[1 1 3]);
 
for i = 1:kluster
    color = gambar_ori;
    color(labelbyrgb ~= i) = 0; 
    img {i} = color;
end
kluster_pertama = img{1};
kluster_kedua = img{2};
kluster_ketiga = img{3};

figure,
imshow(kluster_pertama),
title('Citra Pada Kluster pertama');
figure,
imshow(kluster_kedua),
title('Citra Pada Kluster kedua ');
figure,
imshow (kluster_ketiga),
title('Citra Pada Kluster Ketiga ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

level1 = graythresh(kluster_pertama);
OT1 = im2bw(kluster_pertama,level1);
level2 = graythresh(kluster_kedua);
OT2 = im2bw(kluster_kedua,level1);
level3 = graythresh(kluster_ketiga);
OT3 = im2bw(kluster_ketiga,level3);

BW1 = edge(OT1,'sobel');
BW2 = edge(OT2,'sobel');
BW3 = edge(OT3,'sobel');

figure,
imshow(BW1),
title('Citra Pada Kluster pertama(Sobel)');
figure,
imshow(BW2),
title('Citra Pada Kluster kedua (Sobel)');
figure,
imshow (BW3),
title('Citra Pada Kluster Ketiga (Sobel)');


