% Samuel 8/4
% Concatenates quadrants from each
% original, macenko, reinhardt, and vahadane image

% WCC 8/5/2020
% moved to PCA repo

height = 676;
width = 844;
foldername = 'data';
mosaic_foldername = sprintf('%s/mosaic',foldername);

borderlinewidth = 7;

if 0 % skip the first half when adjusting borderlinewidth
    for i = 1:8
        o_fn = sprintf("%s/Original/%d%d.png", foldername, i, i);
        o = imread(o_fn);
        o = o(1:height/2, 1:width/2, :);
        
        for j = 1:8
            r_fn = sprintf("%s/Reinhard/r%d%d.png", foldername, i, j);
            m_fn = sprintf("%s/Macenko/m%d%d.png", foldername, i, j);
            v_fn = sprintf("%s/Vahadane/v%d%d.png", foldername, i, j);
            mosaic_fn = sprintf("%s/mosaic%d%d.png", mosaic_foldername, i, j);
            
            r = imread(r_fn);
            m = imread(m_fn);
            v = imread(v_fn);
            
            r = r(1:height/2, width/2+1:width, :);
            m = m(height/2+1:height, 1:width/2, :);
            v = v(height/2+1:height, width/2+1:width, :);
            
            % concatenate vertically
            om = cat(1, o, m);
            rv = cat(1, r, v);
            % concatenate horizontally
            mosaic = cat(2, om, rv);
            
            %draw borders
            mosaic(height/2, :, :) = zeros(1, width, 3);
            mosaic(height/2+1, :, :) = zeros(1, width, 3);
            mosaic(:, width/2, :) = zeros(height, 1, 3);
            mosaic(:, width/2+1, :) = zeros(height, 1, 3);
            
            imwrite(mosaic, mosaic_fn);
        end
    end
end

% get file names
fns = strings(1, 64);
results = dir(mosaic_foldername);
for i = 3:length(results)
    fns(i-2) = sprintf("%s\\%s", results(i).folder, results(i).name);
end

% tile images
table = imtile(fns, 'GridSize', [8 8]);

% draw borders
[n_row n_col n_color] = size(table)

for i = 0:8
    for j = -borderlinewidth:+borderlinewidth
        table(max(min(i*height+j,n_row),1), :, :) = zeros(1, 8*width, 3);
        table(:, max(min(i*width+j,n_col),1), :) = zeros(8*height, 1, 3);
    end
end

imwrite(table, sprintf("%s/table.png",mosaic_foldername));

% resize from 5408x6752 to ~1200
table_small = imresize(table, 0.25);
imwrite(table_small, sprintf("%s/table_small.png",mosaic_foldername));

