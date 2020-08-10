%% calculate intersection between target and normalized images
% WCC 8/6/2020

%%
function colorgamutsize
%% color gamut size of original source images
if 1
    data = zeros(8,1);
    
    for j = 1:8
        cgc = ColorGamutCompare(j,1)
        cgc.histogram_compare;
        data(j,1) = cgc.n_present;
    end
    
    save('colorgamutpresent','data')
end

if 1
    load('colorgamutpresent','data')
    figure
    bar(data)
    xlabel('Image #')
    ylabel('Color Gamut Size')
    
    saveas(gcf,'colorgamutpresent.png')
end

return
end

%%
function colorgamutratio
% color gamut size change after/before color normalization
if 1
    data = zeros(8,8,4);
    
    for j = 1:8
        
        for i = 1:8
            [j i]
            
            cgc = ColorGamutCompare(j,i)
            cgc.histogram_compare;
            rmvs = [cgc.r_r cgc.r_m cgc.r_v cgc.r_s];
            data(j,i,:) = rmvs;
            [rmvs]
        end
        
    end
    
    save('colorgamutratio','data')
end

if 1
    load('colorgamutratio','data')
    figure
    for j = 1:8
        ax = subplot(2,4,j)
        bar(squeeze(data(j,:,:))*100)
        xlabel('Target image #')
        title(sprintf('Source image #%d',j))
        ytickformat(ax, 'percentage');
        axis([0.5 8.5 0 150])
    end
    
    %subplot(2,4,2)
    %legend('Reinhard','Macenko','Vahadane','Spectral')
    %legend('Location','NorthEast')
    
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.25, 1, 0.40]);
    
    saveas(gcf,'colorgamutratio.png')
end

return
end

%%
function colorgamutintersection
% color gamut intersection between two images
if 1
    data = zeros(8,8,4);
    
    for j = 1:8
        
        for i = 1:8
            [j i]
            cgc = ColorGamutCompare(j,i)
            rmvs = cgc.histogram_compare;
            data(j,i,:) = rmvs;
            [rmvs]
        end
        
    end
    
    save('colorgamutcoverage','data')
end

if 1
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
end

return

end
