% save spectral analysis of 8 images
% WCC
% 4-17-2020

% do PCA for all images
for i = 1:8
    p(i) = pca_spectrum(i);
    p(i).create_plot;
    saveas(gcf,sprintf('spectral_%d.png',i))
end

return