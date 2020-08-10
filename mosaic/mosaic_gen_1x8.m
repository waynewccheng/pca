% Samuel Lam 8/5
% Puts original images into a 1x8 table.
% todo: Numbers in upper left hand corner.

height = 676;
width = 844;
foldername = 'data';
fig_foldername = sprintf('%s/mosaic',foldername);
fig_fn = sprintf('%s/fig1.png', fig_foldername);

% "half border thickness"
hbt = 5;

im_fns = strings(1, 8);

for i = 1:8
    im_fns(i) = sprintf('%s/%d%d.png', foldername, i, i);
end

fig = imtile(im_fns, 'GridSize', [1 8]);
label_pos = zeros(8,2);


for i = 1:7
    for j = -1*hbt+1:hbt
        fig(:, i*width+j, :) = zeros(height, 1, 3);
    end
    label_pos(i,:) = [(i-1)*width+3*hbt 2*hbt];
end
label_pos(8,:) = [7*width+2*hbt 2*hbt];

fig = cat(1, zeros(10, 8*width, 3), fig, zeros(10, 8*width, 3));
fig = cat(2, zeros(height+20, 10, 3), fig, zeros(height+20, 10, 3)); 
fig = insertText(fig, label_pos, [1 2 3 4 5 6 7 8], 'FontSize', 100);

imwrite(fig, fig_fn);

% resize from 5408x6752 to ~1200
table_small = imresize(fig, 0.25);
imwrite(table_small, sprintf("%s/fig1_small.png",fig_foldername));