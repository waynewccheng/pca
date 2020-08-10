function recolor_ij (i, j)

pi = pca_spectrum(i);
pj = pca_spectrum(j);

clf

subplot(2,2,1)
image(pi.rgb2)
axis image
axis off
title('Source')

subplot(2,2,2)
image(pj.rgb2)
axis image
axis off
title('Target')


% before
% subplot(2,2,5)
% show_spectrum(pj.coeff_masked)
% title('Component Target')

pj.adjust_polarity(pi);

subplot(2,2,3)
hold on
show_spectrum(pi.coeff_masked,0)
show_spectrum(pj.coeff_masked,1)
title('Component Source')

% reconstuct images
rgb1 = pca_spectrum.reconstruct(pi.score, pj.mu_masked, pj.coeff_masked, 1:3);
rgb2 = pi.rgb_1d_to_2d(rgb1);

subplot(2,2,4)
image(rgb2)
axis image
axis off
title('Recolored')

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.20, 1, 0.80]);
saveas(gcf,sprintf('%d%d.png',i,j))            

return
end
