% reconstruct 8 images based on the PCA components of each other
% WCC
% 4-17-2020

% do PCA for all images
for i = 1:8
    p(i) = pca_spectrum(i);
end

% define input images
n = 1:8;
% n = [1 2 6 8];

% reconstuct images
k = 1;
for i = n
    for j = n
        
        coeff_i = p(i).coeff_masked;
        coeff_j = p(j).coeff_masked;
        
        coeff_j = p(i).polarize_component(coeff_i,coeff_j);
        
        im = p(i).reconstruct(p(i).score, p(j).mu_masked, coeff_j, 1:3);
        
        fn = sprintf('%d%d.png',i,j);
        imwrite(im,fn)
        
   %     subplot(size(n,2),size(n,2),k)
   %     imshow(im)
        
        k = k + 1;
    end
end

% saveas(gcf,sprintf('%dx%d.png',size(n,2),size(n,2)))
n = 1:8;
D = {};
k = 1;
for i = n
    for j = n
        fn = sprintf('%d%d.png',i,j);
        im = imread(fn);
        D{k} = im;
        k = k + 1;
    end
end

im8x8 = imtile(D,'GridSize', [8 8]);
imwrite(im8x8,'8x8.png');

return
