%Gamut reconstruction; source image is in cyan, target image is in blue,
%and each reconstructed image gamut is in magenta overlaid on target (blue)
clf
truth1 = imread('lung.tif');
[nrows ncols channels] = size(truth1);
truth1_col = reshape(truth1,nrows*ncols,3);

truth1_lab= rgb2lab(truth1_col);

for i=1:5700
    
    l = truth1_lab(i*100,1);
    a = truth1_lab(i*100,2);
    subplot(2,3,1)
    plot(l,a,'.','color', 'c')
    
    hold on
    

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Image 7 (Lung)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

truth2 = imread('kidney.tif');
[nrows ncols channels] = size(truth2);
truth2_col1 = reshape(truth2,nrows*ncols,3);

truth2_lab1= rgb2lab(truth2_col1);

for i=1:5700
    
    lref = truth2_lab1(i*100,1);
    aref = truth2_lab1(i*100,2);
    bref = truth2_lab1(i*100,3);
    subplot(2,3,4)
    plot(lref,aref,'.','color', 'blue')
    
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
    
    l = r_lab(i*100,1);
    a = r_lab(i*100,2);

    lref = truth2_lab1(i*100,1);
    aref = truth2_lab1(i*100,2);

    subplot(2,3,2)
    plot(lref,aref,'.','color', 'blue')
    hold on
    plot(l,a,'.','color', 'm')
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

    l = m_lab(i*100,1);
    a = m_lab(i*100,2);
    lref = truth2_lab1(i*100,1);
    aref = truth2_lab1(i*100,2);
    subplot(2,3,3)
    plot(lref,aref,'.','color', 'blue')
    hold on
    plot(l,a,'.','color', 'm')
    
    
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

    l = v_lab(i*100,1);
    a = v_lab(i*100,2);
    lref = truth2_lab1(i*100,1);
    aref = truth2_lab1(i*100,2);

    subplot(2,3,5)
    plot(lref,aref,'.','color', 'blue')
    hold on
    plot(l,a,'.','color', 'm')
    
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
    
    l = s_lab(i*100,1);
    a = s_lab(i*100,2);
    lref = truth2_lab1(i*100,1);
    aref = truth2_lab1(i*100,2);

    subplot(2,3,6)
        plot(lref,aref,'.','color', 'blue')
        hold on
    plot(l,a,'.','color', 'm')
    
    hold on

end
xlabel('L*')
ylabel('a*')
axis([0 100 -40 70])
title('Spectral (7 to 5)')

saveas(gcf,sprintf('gamut_test2d_2full.png'))