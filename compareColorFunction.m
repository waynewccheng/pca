%% input 
% image1Name: screen shot for viewer 1
% image2Name: screen shot for viewer 2
% image1TopLeftCorner: top left corner position of FOV in image1
% image1TopLeftCorner: top left corner position of FOV in image2
% FOVlength: size of FOV
% boundaryCut: boundary cut size
% threshold: threshold for pixel difference

%% output
% averageDiff: 3 channles average difference
% maxDiff: 3 channles max difference
% percentageOverThreshold: 3 channles percentage of pixel, which difference
% is larger than threshold.
function [ averageDiff, maxDiff, percentageOverThreshold ] = compareColorFunction( image1Name, image2Name, image1TopLeftCorner, image2TopLeftCorner, FOVlength, boundaryCut, threshold)

    image1=imread(image1Name);
    image2 = imread(image2Name);

    % Based on registration result cut viewer
    image1x = image1TopLeftCorner(1);
    image1y = image1TopLeftCorner(2);
    image2x = image2TopLeftCorner(1);
    image2y = image2TopLeftCorner(2);
    
    FOVSize = FOVlength - 2*boundaryCut;
    
    
    % cut two images to get the study FOV 
    image1 = image1(image1y+boundaryCut:image1y+FOVlength-boundaryCut-1,image1x+boundaryCut:image1x+FOVlength-boundaryCut-1,:);
    image2 = image2(image2y+boundaryCut:image2y+FOVlength-boundaryCut-1,image2x+boundaryCut:image2x+FOVlength-boundaryCut-1,:);
    image1 = double(image1);
    image2 = double(image2);


    % compare channel by channel, calculate 
    % 1. mean of absolute difference
    % 2. max difference
    % 3. var of difference
    % 4. number and percenatge of pixel over threshold
    DifR = image1(:,:,1)-image2(:,:,1);
    AveDiffR  = mean(abs(DifR(:)));
    VarDiffR = var(DifR(:));
    MaxDiffR = max(abs(DifR(:)));
    VectorR=DifR(:);
    OutR= sum(abs(VectorR)>threshold);
    PerR = OutR/FOVSize/FOVSize;



    DifG = image1(:,:,2)-image2(:,:,2);
    AveDiffG  = mean(abs(DifG(:)));
    VarDiffG = var(DifG(:));
    MaxDiffG = max(abs(DifG(:)));
    VectorG= DifG(:);
    OutG = sum(abs(VectorG)>threshold);
    PerG = OutG/FOVSize/FOVSize;



    DifB= image1(:,:,3)-image2(:,:,3);
    AveDiffB  = mean(abs(DifB(:)));
    VarDiffB = var(DifB(:));
    MaxDiffB = max(abs(DifB(:)));
    VectorB= DifB(:);
    OutB = sum(abs(VectorB)>threshold);
    PerB = OutB/FOVSize/FOVSize;

    averageDiff = [AveDiffR,AveDiffG,AveDiffB];
    maxDiff = [MaxDiffR,MaxDiffG,MaxDiffB];
    percentageOverThreshold = [PerR,PerR,PerR];
end

