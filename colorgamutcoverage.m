%% calculate intersection between target and normalized images
% WCC 8/6/2020

%
% collect data
%
if 0
    data = zeros(8,8,4);
    
    for j = 1:8
        
        for i = 1:8
            cgc = ColorGamutCompare(j,i)
            rmvs = cgc.histogram_compare;
            data(j,i,:) = rmvs;
        end
        
    end
    
    save('colorgamutcoverage','data')
end

%
% visualization
%
load('colorgamutcoverage','data')
figure
for j = 1:8
    ax = subplot(2,4,j)
    bar(squeeze(data(j,:,:))*100)
    xlabel('Target image #')
    title(sprintf('Source image #%d',j))
    ytickformat(ax, 'percentage');
end
subplot(2,4,2)
legend('Reinhard','Macenko','Vahadane','Spectral')
legend('Location','NorthEast')

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.25, 1, 0.40]);

saveas(gcf,'colorgamutcoverage.png')

return


