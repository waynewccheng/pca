classdef MosaicGen
    %MosaicGen Generate figures of RGB images for papers
    %   derived from Samuel's code
    
    methods
        function obj = MosaicGen
        end
    end
    
    methods (Static)
        
        function SPIE_Fig1
            MosaicGen.mosaic_gen_1x8;
        end
        
        function SPIE_Fig3
            MosaicGen.mosaic_gen_8x8;
        end
        
        function mosaic_gen_8x8
            % Samuel 8/4
            % Concatenates quadrants from each
            % original, macenko, reinhardt, and vahadane image
            
            % WCC 8/10/2020: changed dir(), imtile 'bordersize'
            % WCC 8/5/2020: moved to PCA repo
            
            height = 676;
            width = 844;
            foldername = 'data';
            mosaic_foldername = sprintf('%s/mosaic',foldername);
            
            borderlinewidth = 7;
            
            if 1 % skip the first half when adjusting borderlinewidth
                for i = 1:8
                    o_fn = sprintf("%s/Original/%d%d.png", foldername, i, i);
                    o = imread(o_fn);
                    o0 = o; % keep an original image for sizing
                    o = o(1:height/2, 1:width/2, :);
                    
                    for j = 1:8
                        r_fn = sprintf("%s/Reinhard/r%d%d.png", foldername, i, j);
                        m_fn = sprintf("%s/Macenko/m%d%d.png", foldername, i, j);
                        v_fn = sprintf("%s/Vahadane/v%d%d.png", foldername, i, j);
                        s_fn = sprintf("%s/Spectral/s%d%d.png", foldername, i, j);
                        mosaic_fn = sprintf("%s/mosaic%d%d.png", mosaic_foldername, i, j);
                        
                        r = imread(r_fn);
                        m = imread(m_fn);
                        v = imread(v_fn);
                        s = imread(s_fn);
                        
                        r = r(1:height/2, width/2+1:width, :);
                        m = m(height/2+1:height, 1:width/2, :);
                        v = v(height/2+1:height, width/2+1:width, :);
                        s = s(1:height/2, 1:width/2, :);
                        
                        % concatenate vertically
                        om = cat(1, s, m);
                        rv = cat(1, r, v);
                        
                        % concatenate horizontally
                        mosaic = cat(2, om, rv);
                        
                        % draw borders
                        mosaic(height/2, :, :) = zeros(1, width, 3);
                        mosaic(height/2+1, :, :) = zeros(1, width, 3);
                        mosaic(:, width/2, :) = zeros(height, 1, 3);
                        mosaic(:, width/2+1, :) = zeros(height, 1, 3);
                        
                        % find distance from the center for each pixel
                        [X Y Z] = meshgrid(1:size(o0,2),1:size(o0,1),1:3);
                        dist = ((X-floor(size(o0,2)/2)).^2 + (Y-floor(size(o0,1)/2)).^2).^0.5;
                        imagesc(dist)
                        
                        % define a circle roughly 1/2 of the image
                        rad = size(o0,1)*0.5/2;
                        mask_inner = dist < rad;
                        mask_eq = abs(dist - rad) < 1;
                        
                        % insert the original image into the circle
                        mosaic(mask_inner) = o0(mask_inner);
                        mosaic(mask_eq) = o0(mask_eq)*0;
                        
                        imwrite(mosaic, mosaic_fn);
                    end
                end
            end
            
            % get file names
            fns = {};
            results = dir([mosaic_foldername '\mosaic*.png']);
            for i = 1:length(results)
                fns{i} = sprintf("%s\\%s", results(i).folder, results(i).name);
            end
            
            % tile images
            table = imtile(fns, 'GridSize', [8 8], 'BorderSize', [5 5] );
            
            % draw borders
            [n_row n_col n_color] = size(table)
            
            % for i = 0:8
            %     for j = -borderlinewidth:+borderlinewidth
            %         table(max(min(i*height+j,n_row),1), :, :) = zeros(1, 8*width, 3);
            %         table(:, max(min(i*width+j,n_col),1), :) = zeros(8*height, 1, 3);
            %     end
            % end
            
            imwrite(table, sprintf("%s/table.png",mosaic_foldername));
            
            % resize from 5408x6752 to ~1200
            table_small = imresize(table, 0.25);
            imwrite(table_small, sprintf("%s/table_small.png",mosaic_foldername));
        end
        
        function mosaic_gen_1x8
            % Samuel Lam 8/5
            % Puts original images into a 1x8 table.
            % todo: Numbers in upper left hand corner.
            
            height = 676;
            width = 844;
            foldername = 'data/Original';
            fig_foldername = sprintf('data/mosaic');
            fig_fn = sprintf('%s/fig1.png', fig_foldername);
            
            % "half border thickness"
            hbt = 2;
            
            im_fns = strings(1, 8);
            
            for i = 1:8
                im_fns(i) = sprintf('%s/%d%d.png', foldername, i, i);
            end
            
            fig = imtile(im_fns, 'GridSize', [1 8], 'BorderSize', [hbt*2 hbt*2]);
            label_pos = zeros(8,2);
            
            if 0
                % draw borders
                for i = 1:7
                    for j = -1*hbt+1:hbt
                        fig(:, i*width+j, :) = zeros(height, 1, 3);
                    end
                    label_pos(i,:) = [(i-1)*width+3*hbt 2*hbt];
                end
                label_pos(8,:) = [7*width+2*hbt 2*hbt];
                
                fig = cat(1, zeros(10, 8*width, 3), fig, zeros(10, 8*width, 3));
                fig = cat(2, zeros(height+20, 10, 3), fig, zeros(height+20, 10, 3));
                
            end
            
            % add image id on the upper left corner
            for i = 1:7
                label_pos(i,:) = [(i-1)*(width+4*hbt)+3*hbt 2*hbt];
            end
            label_pos(8,:) = [7*(width+4*hbt)+2*hbt 2*hbt];
            
            fig = insertText(fig, label_pos, [1 2 3 4 5 6 7 8], 'FontSize', 100);
            
            % add gamut size
            load('colorgamutpresent','data')
            for i = 1:8
                %data_label(i) = sprintf('%.2f',data(i,1));
            end
            fig = insertText(fig, label_pos + [0 floor(height-0.20*height)], data, 'FontSize', 60, 'BoxColor','w');
            
            imwrite(fig, fig_fn);
            
            % resize from 5408x6752 to ~1200
            table_small = imresize(fig, 0.25);
            imwrite(table_small, sprintf("%s/fig1_small.png",fig_foldername));
        end
        
    end
end

