%2D Gamut reconstruction where each point is the rgb color of its
%corresponding pixel
clf
truth1 = imread('lung.tif');
[nrows ncols channels] = size(truth1);
truth1_col = reshape(v,nrows*ncols,3);

truth1_lab= rgb2lab(truth1_col);

for i=1:5700
    
    r1 = truth1_col(i*100,1);
    g1 = truth1_col(i*100,2);
    b1 = truth1_col(i*100,3);
    
    l = truth1_lab(i*100,1);
    a = truth1_lab(i*100,2);

    subplot(2,3,1)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on
    

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Image 7 (Lung)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

truth2 = imread('kidney.tif');
[nrows ncols channels] = size(truth2);
truth2_col = reshape(truth2,nrows*ncols,3);

truth2_lab= rgb2lab(v_col);

for i=1:5700
    
    r1 = truth2_col(i*100,1);
    g1 = truth2_col(i*100,2);
    b1 = truth2_col(i*100,3);

    l = truth2_lab(i*100,1);
    a = truth2_lab(i*100,2);

    subplot(2,3,4)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Image 5 (Kidney)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r = imread('r75.png');
[nrows ncols channels] = size(r);
r_col = reshape(r,nrows*ncols,3);

r_lab= rgb2lab(r_col);

for i=1:5700
    
    r1 = r_col(i*100,1);
    g1 = r_col(i*100,2);
    b1 = r_col(i*100,3);

    l = r_lab(i*100,1);
    a = r_lab(i*100,2);

    subplot(2,3,2)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on
    
end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Reinhard (7 to 5)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = imread('m75.png');
[nrows ncols channels] = size(m);
m_col = reshape(m,nrows*ncols,3);

m_lab= rgb2lab(m_col);

for i=1:5700
    
    r1 = m_col(i*100,1);
    g1 = m_col(i*100,2);
    b1 = m_col(i*100,3);

    l = m_lab(i*100,1);
    a = m_lab(i*100,2);
    
    subplot(2,3,3)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Macenko (7 to 5)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = imread('v75.png');
[nrows ncols channels] = size(v);
v_col = reshape(v,nrows*ncols,3);

v_lab= rgb2lab(v_col);

for i=1:5700
    
    r1 = v_col(i*100,1);
    g1 = v_col(i*100,2);
    b1 = v_col(i*100,3);

    l = v_lab(i*100,1);
    a = v_lab(i*100,2);
    
    subplot(2,3,5)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Vahadane (7 to 5)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = imread('75.png');
[nrows ncols channels] = size(s);
s_col = reshape(s,nrows*ncols,3);

s_lab= rgb2lab(s_col);

for i=1:5700
    
    r1 = s_col(i*100,1);
    g1 = s_col(i*100,2);
    b1 = s_col(i*100,3);
    
    l = s_lab(i*100,1);
    a = s_lab(i*100,2);
    
    subplot(2,3,6)
    plot(l,a,'.','color', [r1 g1 b1])
    
    hold on

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Spectral (7 to 5)')

saveas(gcf,sprintf('gamut_test2d_full.png'))