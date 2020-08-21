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
        n_pixel
        n_present
        m
    end
    
    methods

        function [normality m1_ratio m2_ratio] = color_normality (obj1, obj2, threshold)
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
            % 3D to 1D
            rgb = imread(fn);
            rgb1 = reshape(rgb,size(rgb,1)*size(rgb,2),3);
            
            obj.n_pixel = size(rgb1,1);
            
            % RGB to LAB
            lab1 = rgb2lab(rgb1);
            
            % double to integer
            lab1 = floor(lab1);
            
            % choose one plane of L*
            for l = 0:100
                % mask
                lab_masked = lab1(lab1(:,1)==l,:);
                
                lab_a = lab_masked(:,2) + obj.OFFSET_A;
                lab_b = lab_masked(:,3) + obj.OFFSET_B;
                many_ones = ones(size(lab_masked,1),1);
                
                assert(nnz(lab_a < 1)==0);
                assert(nnz(lab_a > obj.SIZE_A)==0);
                assert(nnz(lab_b < 1)==0);
                assert(nnz(lab_b > obj.SIZE_B)==0);
                    
                % make a sparse matrix with a* and b* and ones
                s{l+1} = sparse(lab_a,lab_b,many_ones,obj.SIZE_A,obj.SIZE_B);
            end
            
            % convert back to full 3D matrix
            obj.m = zeros(obj.SIZE_L,obj.SIZE_A,obj.SIZE_B);
            for l = 0:100
                layer = l+1;
                obj.m(layer,:,:) = full(s{layer});
            end
            
            obj.n_present = nnz(obj.m);
        end
    end
end

