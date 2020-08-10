%% ColorGamutCompare
% Compare color gamut between Reinhard, Macenko, Vahadane, and Spectral
% WCC
%%
classdef ColorGamutCompare < handle
    
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
            obj.fn_s = sprintf('data\\Spectral\\%d%d.png',source,target);
        end
        
        function rmvs = histogram_compare (obj)
            h_o = ColorHistogram(obj.fn_o);
            h_t = ColorHistogram(obj.fn_t);
            h_r = ColorHistogram(obj.fn_r);
            h_m = ColorHistogram(obj.fn_m);
            h_v = ColorHistogram(obj.fn_v);
            h_s = ColorHistogram(obj.fn_s);
            
            r = h_t.diff(h_r,0);
            m = h_t.diff(h_m,0);
            v = h_t.diff(h_v,0);
            s = h_t.diff(h_s,0);
            rmvs = [r m v s];
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
            title('Original','Interpreter','none')
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
        function test
            cgc = ColorGamutCompare(1,8);
            cgc.color_compare4
            %cgc.histogram_compare            
        end
    end    
end

