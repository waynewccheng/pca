% plot first 3 components of 8 images
% WCC
% 4-17-2020

% do PCA for all images
for i = 1:8
    p(i) = pca_spectrum(i);
end

for i = 1:8
    subplot(2,4,i)
    hold on
            plot(380:10:780,p(i).coeff_masked(:,1))
            plot(380:10:780,p(i).coeff_masked(:,2))
            plot(380:10:780,p(i).coeff_masked(:,3))
            plot(380:10:780,p(i).mu_masked,'.')
            xlabel('nm')
            ylabel('T')
            legend('1','2','3','mu')
            title(sprintf('%d',i))
end

saveas(gcf,sprintf('component8.png'))

return