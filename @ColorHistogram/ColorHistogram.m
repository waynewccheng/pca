%
% color normalization paper in SPIE 2021
% color normality

classdef ColorHistogram
    
    properties (Constant)
        OFFSET_AB_RANGE = 110
        OFFSET_L = 1
        OFFSET_A = ColorHistogram.OFFSET_AB_RANGE
        OFFSET_B = ColorHistogram.OFFSET_AB_RANGE
        
        SIZE_L = 100 + 1
        SIZE_A = 1 + ColorHistogram.OFFSET_AB_RANGE * 2
        SIZE_B = 1 + ColorHistogram.OFFSET_AB_RANGE * 2
    end
    
    properties
        n_pixel  % total pixel count in the image
        n_present % count of occupied bins
        m         % 3D bins
    end
    
    methods
        
        function [normality m1_ratio m2_ratio] = color_normality (obj1, obj2, threshold)
            % Calculate the "color normality" of two images after color normalization
            % inputs: two ColorHistogram m1 and m2, minimum pixel count required to be considered
            % outputs: color_normality, ratio of intersection to m1_gamut, ratio of intersection to m2_gamut
            
            m1 = obj1.m;
            m2 = obj2.m;
            
            m_union = (m1>threshold) | (m2>threshold);
            m_intersect = (m1>threshold) & (m2>threshold);
            n_union = nnz(m_union);
            n_intersect = nnz(m_intersect);
            
            m1_ratio = n_intersect / obj1.n_present;
            m2_ratio = n_intersect / obj2.n_present;
            normality = m1_ratio * m2_ratio;
            
            %[obj1.n_present obj2.n_present n_union n_intersect]
            %[m1_ratio m2_ratio]
        end
        
        function m1_ratio = diff (obj1, obj2, threshold)
            % similar to color_normality, but returns only m1 data
            m1 = obj1.m;
            m2 = obj2.m;
            m_union = (m1>threshold) | (m2>threshold);
            m_intersect = (m1>threshold) & (m2>threshold);
            n_union = nnz(m_union);
            n_intersect = nnz(m_intersect);
            m1_ratio = n_intersect / obj1.n_present;
            m2_ratio = n_intersect / obj2.n_present;
            
            %[obj1.n_present obj2.n_present n_union n_intersect]
            %[m1_ratio m2_ratio]
        end
        
        function obj = ColorHistogram (fn)
            %
            % input is an image file
            %
            
            % 3D to 1D
            rgb = imread(fn);
            rgb1 = reshape(rgb,size(rgb,1)*size(rgb,2),3);
            
            % assign total pixel count in the image
            obj.n_pixel = size(rgb1,1);
            
            % RGB to LAB
            lab1 = rgb2lab(rgb1);
            
            % double to integer
            lab1 = floor(lab1);
            
            % choose one plane of L*
            for l = 0:100       % l: layer in L*
                
                % mask for each layer in L*
                lab_masked = lab1(lab1(:,1)==l,:);
                
                % convert a* to matrix index
                lab_a = lab_masked(:,2) + obj.OFFSET_A;
                
                % convert b* to matrix index
                lab_b = lab_masked(:,3) + obj.OFFSET_B;
                
                % use an ONE matrix to do the counting
                many_ones = ones(size(lab_masked,1),1);
                
                % make sure evreything is in range
                assert(nnz(lab_a < 1)==0);
                assert(nnz(lab_a > obj.SIZE_A)==0);
                assert(nnz(lab_b < 1)==0);
                assert(nnz(lab_b > obj.SIZE_B)==0);
                
                %
                % make a sparse matrix with a* and b* and ones
                %
                % Accumulate Values into Sparse Matrix
                % https://www.mathworks.com/help/matlab/ref/sparse.html
                s{l+1} = sparse(lab_a,lab_b,many_ones,obj.SIZE_A,obj.SIZE_B);
                
            end
            
            % convert back to full 3D matrix
            obj.m = zeros(obj.SIZE_L,obj.SIZE_A,obj.SIZE_B);
            for l = 0:100
                layer = l+1;
                
                %
                % convert sparse matrix to full matrix
                %
                obj.m(layer,:,:) = full(s{layer});
                
            end
            
            %
            % assign count of occupied bins
            %
            obj.n_present = nnz(obj.m);
            
        end
    end
end

