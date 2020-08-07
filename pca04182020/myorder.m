% for i = 1:8
%     p(i) = pca_spectrum(i);
% end

% load all data
data = zeros(41,41,8);

for i = 1:8
    data(:,:,i) = p(i).coeff_masked;
end

% check only the first n vectors
n = 41;
n = 3;

clf
hold on
i=1;
for j=1:8
    order = zeros(n,1);
    for k=1:n
        cr = corrcoef(squeeze(data(:,k,i)),squeeze(data(:,k,j)));
        order(k,1) = cr(1,2);
    end
    subplot(2,8,j)
    plot(order,'-o')
    axis([1 n -1 1])
    axis square
end

% polarize
coeff_i = squeeze(data(:,:,i));

for j = 2:8
    
    coeff_j = squeeze(data(:,:,j));
    
    w = p(i).polarize_component(coeff_i,coeff_j);
    
    %     subplot(1,3,1)
    %     imagesc(coeff_i)
    %     axis square
    %     subplot(1,3,2)
    %     imagesc(coeff_j)
    %     axis square
    %     subplot(1,3,3)
    %     imagesc(w)
    %     axis square
    
    data(:,:,j) = w;
    
end

i=1;
for j=1:8
    order = zeros(n,1);
    for k=1:n
        cr = corrcoef(squeeze(data(:,k,i)),squeeze(data(:,k,j)));
        order(k,1) = cr(1,2);
    end
    subplot(2,8,j+8)
    plot(order,'-o')
    axis([1 n -1 1])
    axis square
end

figure

for i = 1:3
    comp = squeeze(data(:,i,:));
    
    subplot(1,3,i)
    plot(380:10:780,comp)
    axis([380 780 -0.5 0.5])
    axis square
    title(i)
end
