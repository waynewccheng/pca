clc
clear all
close all
% load screen cut from two viewers
eeDAPimage=imread('eeDAPicc.PNG');
imagescopeimageOn = imread('imagescope.PNG');

% Based on registration result cut viewer
eeDAPx1=5;
eeDAPy1=370;
imagescopeOnx1 = 691;
imagescopeOny1 = 378;
length = 879;

% set cutting boundary
cutBorad = 5;



% cut two images to get the study FOV 
eeDAPimage = eeDAPimage(eeDAPy1+cutBorad:eeDAPy1+length-cutBorad-1,eeDAPx1+cutBorad:eeDAPx1+length-cutBorad-1,:);
imagescopeimageOn = imagescopeimageOn(imagescopeOny1+cutBorad:imagescopeOny1+length-cutBorad-1,imagescopeOnx1+cutBorad:imagescopeOnx1+length-cutBorad-1,:);
imwrite(eeDAPimage,'show_eeDAPicc.png');
imwrite(imagescopeimageOn,'show_IS.png')
eeDAPimage =double(eeDAPimage);
imagescopeimageOn =double(imagescopeimageOn);


% set differencce threshold
threshold = 10;

% compare channel by channel, calculate 
% 1. mean of absolute difference
% 2. max difference
% 3. var of difference
% 4. number and percenatge of pixel over threshold
DifRon = eeDAPimage(:,:,1)-imagescopeimageOn(:,:,1);
AveDiffRon  = mean(abs(DifRon(:)));
VarDiffRon = var(DifRon(:));
MaxDiffR = max(DifRon(:))
VectorRon=DifRon(:);
OutRon= sum(abs(VectorRon)>threshold);
PerRon = OutRon/874/874
figure
[countRon,centerRon]=hist(double(VectorRon));
hist(double(VectorRon),max(VectorRon(:))-min(VectorRon(:)));


DifGon = eeDAPimage(:,:,2)-imagescopeimageOn(:,:,2);
AveDiffGon  = mean(abs(DifGon(:)));
VarDiffGon = var(DifGon(:));
MaxDiffG = max(DifGon(:))
VectorGon= DifGon(:);
OutGon = sum(abs(VectorGon)>threshold);
PerGon = OutGon/874/874
Not0Gon = VectorGon(find(VectorGon~=0));
figure
hist(double(VectorGon),max(VectorGon(:))-min(VectorGon(:)));


DifBon= eeDAPimage(:,:,3)-imagescopeimageOn(:,:,3);
AveDiffBon  = mean(abs(DifBon(:)));
VarDiffBon = var(DifBon(:));
MaxDiffB = max(DifBon(:))
VectorBon= DifBon(:);
OutBon = sum(abs(VectorBon)>threshold);
PerBon = OutBon/874/874
figure
[countBon,centerBon]=hist(double(VectorBon));
hist(double(VectorBon),max(VectorBon(:))-min(VectorBon(:)));





