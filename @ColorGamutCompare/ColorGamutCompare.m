%% ColorGamutCompare
% Compare color gamut between Reinhard, Macenko, Vahadane, and Spectral
% WCC
% revised 12/5/2020
% created for SPIE 2021 submission
%%
classdef ColorGamutCompare < handle
    
    properties
        % ratio of color gamut size after color normalization
        r_r
        r_m
        r_v
        r_s
        
        % color gamut size of source
        n_present % number of occupied 3D bins
    end
    
    properties (Access = private)
        fn_o
        fn_t
        fn_r
        fn_m
        fn_v
        fn_s
        subp_r = 1
        subp_c = 6
        subp_n = 6
    end
    
    methods
        
        function obj = ColorGamutCompare (source, target)
            % Color normalize #source wrt to #target
            obj.fn_o = sprintf('data\\Original\\%d%d.png',source,source);
            obj.fn_t = sprintf('data\\Original\\%d%d.png',target,target);
            obj.fn_r = sprintf('data\\Reinhard\\r%d%d.png',source,target);
            obj.fn_m = sprintf('data\\Macenko\\m%d%d.png',source,target);
            obj.fn_v = sprintf('data\\Vahadane\\v%d%d.png',source,target);
            obj.fn_s = sprintf('data\\Spectral\\s%d%d.png',source,target);
        end
        
        function rmvs = histogram_compare (obj)
            h_o = ColorHistogram(obj.fn_o);
            h_t = ColorHistogram(obj.fn_t);
            h_r = ColorHistogram(obj.fn_r);
            h_m = ColorHistogram(obj.fn_m);
            h_v = ColorHistogram(obj.fn_v);
            h_s = ColorHistogram(obj.fn_s);
            
            %r = h_t.diff(h_r,0);
            %m = h_t.diff(h_m,0);
            %v = h_t.diff(h_v,0);
            %s = h_t.diff(h_s,0);
            [r r1 r2] = h_t.color_normality(h_r,0)
            [m m1 m2] = h_t.color_normality(h_m,0)
            [v v1 v2] = h_t.color_normality(h_v,0)
            [s s1 s2] = h_t.color_normality(h_s,0)
            [o o1 o2] = h_t.color_normality(h_o,0)
            rmvs = [r m v s];
            
            % ratio of color gamut size after color normalization
            obj.r_r = h_r.n_present / h_o.n_present;
            obj.r_m = h_m.n_present / h_o.n_present;
            obj.r_v = h_v.n_present / h_o.n_present;
            obj.r_s = h_s.n_present / h_o.n_present;
            
            % color gamut size of source
            obj.n_present = h_o.n_present;
        end
        
        function color_compare4 (obj)
            obj.remove_background(obj.fn_o);
            obj.remove_background(obj.fn_t);
            obj.remove_background(obj.fn_r);
            obj.remove_background(obj.fn_m);
            obj.remove_background(obj.fn_v);
            obj.remove_background(obj.fn_s);
            
            clf
            
            subplot(obj.subp_r,obj.subp_c,1)
            hold on
            obj.pixel_in_CIELAB([obj.fn_o '_masked.png'],'.',[255 0 0])
            title('Source','Interpreter','none')
            grid on
            
            subplot(obj.subp_r,obj.subp_c,2)
            hold on
            obj.pixel_in_CIELAB([obj.fn_t '_masked.png'],'.',[255 0 0])
            title('Target','Interpreter','none')
            grid on
            
            subplot(obj.subp_r,obj.subp_c,3)
            hold on
            obj.pixel_in_CIELAB([obj.fn_r '_masked.png'],'.',[255 0 0])
            title('Reinhard','Interpreter','none')
            grid on
            
            subplot(obj.subp_r,obj.subp_c,4)
            hold on
            obj.pixel_in_CIELAB([obj.fn_m '_masked.png'],'.',[255 0 0])
            title('Macenko','Interpreter','none')
            grid on
            
            subplot(obj.subp_r,obj.subp_c,5)
            hold on
            obj.pixel_in_CIELAB([obj.fn_v '_masked.png'],'.',[255 0 0])
            title('Vahadane','Interpreter','none')
            grid on
            
            subplot(obj.subp_r,obj.subp_c,6)
            hold on
            obj.pixel_in_CIELAB([obj.fn_s '_masked.png'],'.',[255 0 0])
            title('Spectral','Interpreter','none')
            grid on
            
            obj.axis_set([0 60 -70 10 20 100]);
            obj.view_set([111 34])
            
            % capture
            
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.25, 1, 0.30]);
            saveas(gcf,'colorgamut.png')
        end
        
        function axis_set (obj, axis_range)
            for i = 1:obj.subp_n
                subplot(obj.subp_r,obj.subp_c,i)
                %axis([0 40 -50 10 0 100])
                axis(axis_range)
            end
        end
        
        function view_follow (obj, subp)
            subplot(obj.subp_r,obj.subp_c,subp)
            [a b] = view;
            obj.view_set([a b]);
        end
        
        function view_set (obj, v)
            for i = 1:obj.subp_n
                subplot(obj.subp_r,obj.subp_c,i)
                %view([120 25])
                view(v)
            end
        end
        
        function color_compare (obj,fn1,fn2)
            % obsolete
            obj.remove_background(fn1);
            obj.remove_background(fn2);
            
            clf
            
            subplot(1,3,1)
            imshow(fn1)
            title(fn1,'Interpreter','none')
            
            subplot(1,3,2)
            imshow(fn2)
            title(fn2,'Interpreter','none')
            
            subplot(1,3,3)
            hold on
            obj.pixel_in_CIELAB([fn1 '_masked.png'],'.',0)
            obj.pixel_in_CIELAB([fn2 '_masked.png'],'.',1)
            
            axis([0 40 -50 10 0 100])
            view([120 25])
            grid on
            
        end
        
        % for Weijie and Weizhe, Camelyon16 database
        % remove background for H&E slides
        
        function remove_background (obj,fn)
            
            % threshold from white
            chroma_th = 10;
            
            % read image
            rgb = imread(fn);
            rgb1 = reshape(rgb,size(rgb,1)*size(rgb,2),3);
            
            % convert to CIELAB
            lab1 = rgb2lab(rgb1);
            
            % calculate chroma
            chroma = (lab1(:,2).^2 + lab1(:,3).^2) .^ 0.5;
            
            % for every pixel having chroma less than the threshold
            % change color to green
            rgb1(chroma < chroma_th,1) = 0;
            rgb1(chroma < chroma_th,2) = 255;
            rgb1(chroma < chroma_th,3) = 0;
            
            % back to 2D
            rgb2 = reshape(rgb1,size(rgb,1),size(rgb,2),3);
            
            % visual check
            if 0
                subplot(1,2,1)
                image(rgb)
                subplot(1,2,2)
                image(rgb2)
            end
            
            % write result
            imwrite(rgb2,[fn '_masked.png'])
            
            return
        end
        
        % for Weijie and Weizhe
        % show image pixels in CIELAB
        
        function pixel_in_CIELAB (obj,fn,marker,clr)
            
            % linearize
            rgb = imread(fn);
            rgb1 = reshape(rgb,size(rgb,1)*size(rgb,2),3);
            
            % convert to LAB
            lab1 = rgb2lab(rgb1);
            
            % remove masked green pixels
            if 1
                mask = (rgb1(:,1) == 0) & (rgb1(:,2) == 255) & (rgb1(:,3) == 0);
                lab1_masked = lab1(mask,:);
                rgb1_masked = rgb1(mask,:);
            end
            
            % show
            scatter3(lab1(:,2),lab1(:,3),lab1(:,1),1,double(rgb1(:,:))/255,'o')
            
            %scatter3(lab1(:,2),lab1(:,3),lab1(:,1),1,double(clr)/255,marker)
            
            axis equal
            xlabel('{\it a}*')
            ylabel('{\it b}*')
            zlabel('{\it L}*')
            
        end
        
    end
    
    methods (Static)

        function SPIE_Fig4
            cgc = ColorGamutCompare(1,8);
            cgc.color_compare4
        end

        function SPIE_Fig5
            ColorGamutCompare.colorgamutintersection;
        end
        
        function test

            if 0
                cgc = ColorGamutCompare(1,8);
                cgc.color_compare4
            end
            
            if 0
                cgc = ColorGamutCompare(1,8);
                cgc.histogram_compare
            end
            
            if 0
                ColorGamutCompare.colorgamutsize;
            end
            
            if 1
                ColorGamutCompare.colorgamutratio;
            end
            
            if 0
                ColorGamutCompare.colorgamutintersection;
            end
            
        end
        
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
        
        function colorgamutintersection
            % color gamut intersection between two images
            if 0
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
                    bar(squeeze(data(j,:,:)))
                    xlabel('Target image #')
                    ylabel('Color Normality')
                    title(sprintf('Source image #%d',j))
                    %ytickformat(ax, 'percentage');
                end
                subplot(2,4,3)
                legend('Reinhard','Macenko','Vahadane','Spectral')
                legend('Location','NorthEast')
                
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.25, 1, 0.40]);
                
                saveas(gcf,'colorgamutcoverage.png')
            end
            
            return
        end
        
    end
end

