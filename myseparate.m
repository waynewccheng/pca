i=6;


th = [-0.4:0.1:0.4];


score = p(i).score;
coeff = p(i).coeff_masked;
mu = p(i).mu_masked;

for i = 5
    score2 = score;
    m = score2(:,1) > +0.7;
    score2(m,:) = 0;
    
    im2 = p(1).reconstruct(score2,mu,coeff,1:41);
    
    %subplot(3,3,i)
    image(im2)
end
