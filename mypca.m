%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA of spectral spectra

% 03-29-2020: First version
% 4-8-2020: WCC


% function mypca
% for i=1:8
%     mypca_do(i)
%     snapnow
% end
% end


function mypca (organ_id)

TOY = 0;                   % use small image for debugging

if TOY ~= 1
    
    WCC = 1
    
    % data paths
    switch organ_id
        case 1
            organ_name = 'BiomaxOrgan10_Bladder_M13'
        case 2
            organ_name = 'BiomaxOrgan10_Brain_H10'
        case 3
            organ_name = 'BiomaxOrgan10_Breast_A1'
        case 4
            organ_name = 'BiomaxOrgan10_Colon_H6'
        case 5
            organ_name = 'BiomaxOrgan10_Kidney_H7'
        case 6
            organ_name = 'BiomaxOrgan10_Liver_H9'
        case 7
            organ_name = 'BiomaxOrgan10_Lung_J7'
        case 8
            organ_name = 'BiomaxOrgan10_UterineCervix_B10'
    end
    
    if WCC == 1
        transName_path = ['C:\Users\wcc\Desktop\paul data wsi\Data\ProcessedData\031320\' organ_name '\Transmittance\'];
        imgTruthName_path = ['C:\Users\wcc\Desktop\paul data wsi\Data\ProcessedData\031320\' organ_name '\EndResults\'];
        cied65_path = 'C:\Users\wcc\Documents\GitHub\paulcode\input\DataIlluminants\';
    end
    
    % File names
    transName = [transName_path 'trans_mean_camera'];
    imgTruthName = [imgTruthName_path 'truth.tif'];
    
    % image size 
    ncol = 844;
    nrow = 676;
    
    % Load Paul's data files
    load(transName,'trans_array_m');
    
    % trans_array_m is 41x570544
    
    % data is 570544x41
    data = trans_array_m';
    
else
    
    %% use Toy data
    ncol = 200;
    nrow = 200;
    load('toy','data')
    organ_name = 'Toy'
    
    imgTruthName = ['toy.png'];
    
end



%% data conditioning -- 
% huge difference in PCA!!!

% remove noisy 380 nm 
% by reducing magnitude to 0.001
% while keeping randomness 
drange1 = min(data(:,1));
drange2 = max(data(:,1));
data(:,1) = data(:,1) / (drange2-drange1) * 0.001;

% remove noise 780 nm
% by reducing magnitude to 0.001
% while keeping randomness 
drange1 = min(data(:,end));
drange2 = max(data(:,end));
data(:,end) = data(:,end) / (drange2-drange1) * 0.001;

% trim to [0,1]
data(data < 0) = 0;
data(data > 1) = 1;


%% Principal Component Analysis
% great tutorial: http://www.cs.otago.ac.nz/cosc453/student_tutorials/principal_components.pdf
% Matlab pca(): https://www.mathworks.com/help/stats/pca.html

%
% Matlab pca
%
[coeff,score,latent,tsquared,explained,mu] = pca(data);

% subplot layout
sprow = 4;
spcol = 3;


clf

% color conversion library
cc = ColorConversionClass;

%
% first row: show mu + i
%
for i = 1:3
    subplot(sprow,spcol,i)

    % score of the i-th pixel
    sco = score(:,i);
    sco_kx41 = repmat(sco,1,41);

    % the i-th component
    comp = coeff(:,i);
    comp_kx41 = repmat(comp',size(sco,1),1);
    
    % the mean
    mu_kx41 = repmat(mu,size(sco,1),1);
    
    % the transmittance including mean
    trans_kx41 = comp_kx41 .* sco_kx41 + mu_kx41;
    
    % light source
    spd_d65 = cc.spd_d65;
    spd_d65_kx41 = repmat(spd_d65',size(sco,1),1);
    
    % transmittance and light source combined
    spd_kx41 = trans_kx41 .* spd_d65_kx41;
    
    % SPD to CIEXYZ
    xyz_target = cc.spd2XYZ(spd_kx41');
    xyz_d65 = cc.spd2XYZ(spd_d65);
    
    % CIEXYZ to CIELAB
    lab = cc.XYZ2lab(xyz_target,xyz_d65);
    lab2 = reshape(lab,nrow,ncol,3);
    
    % CIELAB to sRGB
    rgb = uint8(lab2rgb(lab)*255);
    
    % 1D to 2D
    rgb2 = reshape(rgb,nrow,ncol,3);
    
    % show image
    image(rgb2)
    title(sprintf('mu + %d',i))
    axis off
    
end

% % second row
% % show relative changes only
% for i = 1:3
%
%     % start from the 2nd row
%     subplot(sprow,spcol,i+spcol*1)
%
%     % use 80% white as the baseline
%     spd_white = cc.spd_d65 * 1;
%     spd_white_kx41 = repmat(spd_white',size(sco,1),1);
%
%     % the score for each pixel
%     sco = score(:,i);
%
%     % modify score
%     sco2 = reshape(sco,nrow,ncol);
%     for j = 1:ncol
%         sco2(:,j) = (j/ncol - 0.5) / 0.5 * 2;
%     end
%     sco = reshape(sco2,nrow*ncol,1);
%
%     sco_kx41 = repmat(sco,1,41);
%
%     % the eigenvector
%     comp = coeff(:,i);
%     comp_kx41 = repmat(comp',size(sco,1),1);
%
%     % the transmittance _change_ for each pixel
%     % do not use mu here -- that's wrong!!!
%     % should add a baseline, e.g., 0.5
%     trans_kx41 = comp_kx41 .* sco_kx41 + 0.5;
%
%     % spd for each pixel
%     spd_kx41 = trans_kx41 .* spd_white_kx41;
%
%     % xyz for each pixel
%     xyz_target = cc.spd2XYZ(spd_kx41');
%
%     % xyz for reference white
%     xyz_d65 = cc.spd2XYZ(spd_white);
%
%     % lab for each pixel
%     lab = cc.XYZ2lab(xyz_target,xyz_d65);
%
%     % lab in 2D
%     lab2 = reshape(lab,nrow,ncol,3);
%
%     % sRGB for each pixel
%     rgb = uint8(lab2rgb(lab)*255);
%
%     % sRGB in 2D
%     rgb2 = reshape(rgb,nrow,ncol,3);
%
%     % show image
%     image(rgb2)
%     title(sprintf('gray + %d',i))
%     axis off
%
% end

% % show color of mu
% subplot(sprow,spcol,4)
%
% spd_d65 = cc.spd_d65;
% spd_target = spd_d65 .* mu';
%
% xyz_target = cc.spd2XYZ(spd_target);
% xyz_d65 = cc.spd2XYZ(spd_d65);
%
% lab = cc.XYZ2lab(xyz_target,xyz_d65);
%
% rgb = lab2rgb(lab)*255;
%
% showpatt(rgb(1),rgb(2),rgb(3));
% axis off

% third row
% show heatmaps of the first 3 vectors

% for colormap
mysco_n = 100;
mycmap = zeros(3,mysco_n,3);

for i = 1:3
    
    ax(i) = subplot(sprow,spcol,1*spcol+i);
    im1 = score(:,i);
    im2 = reshape(im1,nrow,ncol);
    
    %
    mysco1 = min(im1);
    mysco2 = max(im2);
    mysco = [mysco1:(mysco2-mysco1)/(mysco_n-1):mysco2]';
    mycolormap = create_colorbar(coeff(:,i),mysco);
    mycmap(i,:,:) = mycolormap;
    imagesc(im2)
    colorbar('east')
    
    axis off
    title(sprintf('gray + %d',i))
    
end

for i=1:3
    colormap(ax(i),squeeze(mycmap(i,:,:)))
end

% show histograms
% on 3rd row
for i = 1:3
    subplot(sprow,spcol,2*spcol+i)
    histogram(score(:,i))
    title(sprintf('histogram %d',i))
end

% show eigenvectors
subplot(sprow,spcol,sprow*spcol-2)
hold on
plot(380:10:780,coeff(:,1))
plot(380:10:780,coeff(:,2))
plot(380:10:780,coeff(:,3))
plot(380:10:780,mu,'.')
xlabel('nm')
ylabel('T')
legend('1','2','3','mu')
title('component')

% show background
subplot(sprow,spcol,sprow*spcol-1)

mu_kx41 = repmat(mu,size(sco,1),1);

trans_kx41 = mu_kx41;

spd_d65 = cc.spd_d65;
spd_d65_kx41 = repmat(spd_d65',size(sco,1),1);

spd_kx41 = trans_kx41 .* spd_d65_kx41;

xyz_target = cc.spd2XYZ(spd_kx41');
xyz_d65 = cc.spd2XYZ(spd_d65);

lab = cc.XYZ2lab(xyz_target,xyz_d65);
lab2 = reshape(lab,nrow,ncol,3);

rgb = uint8(lab2rgb(lab)*255);

rgb2 = reshape(rgb,nrow,ncol,3);

image(rgb2)
title(sprintf('mu'))
axis off

% show the RGB truth image
subplot(sprow,spcol,sprow*spcol)
imgTruth = imread(imgTruthName);
image(imgTruth)
% axis image
axis off
% colorbar
title(organ_name,'Interpreter','none')

% figure
% for i=1:9
%     subplot(3,3,i)
%     eigenvector2rgb(mu',coeff(:,i))
%     title([i])
% end

return


%%
% % explore the Matlab pca() output results
%
% clf
%
% subplot(6,1,1)
% hold on
% plot(390:10:770,coeff(:,1))
% plot(390:10:770,coeff(:,2))
% plot(390:10:770,coeff(:,3))
% xlabel('nm')
% ylabel('T')
% title('coef')
% legend('1','2','3')
%
% subplot(6,1,3)
% plot(latent(1:5),'o-')
% title('latent')
%
% subplot(6,1,5)
% plot(explained(1:5),'o-')
% title('explained')
%
% subplot(6,1,6)
% plot(390:10:770,mu)
% xlabel('nm')
% ylabel('T')
% title('mu')
%
% return


end


%%
function rgb = create_colorbar (trans, sco)


cc = ColorConversionClass;

% use 80% white as the baseline
spd_white = cc.spd_d65 * 1;
spd_white_kx41 = repmat(spd_white',size(sco,1),1);


sco_kx41 = repmat(sco,1,41);

% the eigenvector
comp = trans;
comp_kx41 = repmat(comp',size(sco,1),1);

% the transmittance _change_ for each pixel
% do not use mu here -- that's wrong!!!
% should add a baseline, e.g., 0.5
trans_kx41 = comp_kx41 .* sco_kx41 + 0.5;

% spd for each pixel
spd_kx41 = trans_kx41 .* spd_white_kx41;

% xyz for each pixel
xyz_target = cc.spd2XYZ(spd_kx41');

% xyz for reference white
xyz_d65 = cc.spd2XYZ(spd_white);

% lab for each pixel
lab = cc.XYZ2lab(xyz_target,xyz_d65);

% sRGB for each pixel
rgb = lab2rgb(lab);

rgb = max(rgb,0);
rgb = min(rgb,1);

save('rgb','rgb')
end
