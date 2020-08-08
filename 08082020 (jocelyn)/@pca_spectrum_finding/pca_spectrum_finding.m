% WCC
% experiments of pca_spectrum
% 4-18-2020
classdef pca_spectrum_finding < handle
    %PCA_SPECTRUM_FINDING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p
    end
    
    methods
        
        function obj = pca_spectrum_finding
            %PCA_SPECTRUM_FINDING Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.p = pca_spectrum.empty(8,0);
            
            % create the 8 objects
            for i = 1:8
                obj.p(i) = pca_spectrum(i);
            end
            
            
            recolor(obj);
            
        end
        
        function plot_components_in_8 (obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            % plot first 3 components of 8 images
            % WCC
            % 4-17-2020
            
            for i = 1:8
                subplot(2,4,i)
                hold on
                plot(380:10:780,obj.p(i).coeff_masked(:,1))
                plot(380:10:780,obj.p(i).coeff_masked(:,2))
                plot(380:10:780,obj.p(i).coeff_masked(:,3))
                plot(380:10:780,obj.p(i).mu_masked,'.')
                xlabel('nm')
                ylabel('T')
                legend('1','2','3','mu')
                title(sprintf('%d',i))
                axis([380 780 -0.5 1])
            end
            
            saveas(gcf,sprintf('component_8.png'))
            
            return
        end
        
        function plot_components_in_3 (obj)
            
            % plot first 3 components of 8 images
            % WCC
            % 4-17-2020
            
            for i = 1:3
                subplot(1,3,i)
                hold on
                
                for j = 1:8
                    plot(380:10:780,obj.p(j).coeff_masked(:,i))
                end
                
                xlabel('nm')
                ylabel('T')
                legend('1','2','3','4','5','6','7','8')
                title(sprintf('%d',i))
                axis([380 780 -0.5 +0.5])
            end
            
            saveas(gcf,sprintf('component_3.png'))
            
            return
        end
        
        function recolor (obj)
            % reconstruct 8 images based on the PCA components of each other
            % WCC
            % 4-17-2020
            
            % define input images
            n = 1:8;
            
            % reconstuct images
            k = 1;
            for i = n
                for j = n

                    
                    coeff_j = adjust_polarity(obj.p(i), obj.p(j));
                    
                    rgb1 = pca_spectrum.reconstruct(obj.p(i).score, obj.p(j).mu_masked, coeff_j, 1:3);
                 
                    rgb2 = obj.p(i).rgb_1d_to_2d(rgb1);
                    
                    fn = sprintf('%d%d.png',i,j);
                    imwrite(rgb2,fn)
                    
                    subplot(size(n,2),size(n,2),k)
                    imshow(rgb2)
                    
                    k = k + 1;
                end
            end
            
            saveas(gcf,sprintf('%dx%d.png',size(n,2),size(n,2)))
            
            return
        end
        
        function plot_scatter_2d (obj)
            
            clf
            hold on
            for i = 1:8
                x1 = obj.p(i).score(:,1);
                y1 = obj.p(i).score(:,2);
                z1 = obj.p(i).score(:,3);
                
                range = 1:100:size(x1,1);
                
                subplot(2,4,i)
                %plot3(x1(range),y1(range),z1(range),'.')
                plot(x1(range),y1(range),'.')
                title(i)
                axis equal
            end
            
            saveas(gcf,sprintf('scatter_2d.png'))
            return
        end
        
        function plot_scatter_3d (obj)
            
            clf
            hold on
            for i = 1:8
                x1 = obj.p(i).score(:,1);
                y1 = obj.p(i).score(:,2);
                z1 = obj.p(i).score(:,3);
                
                range = 1:100:size(x1,1);
                
                subplot(2,4,i)
                plot3(x1(range),y1(range),z1(range),'.')
                %plot(x1(range),y1(range),'.')
                title(i)
                axis equal
            end
            
            saveas(gcf,sprintf('scatter_3d.png'))
            return
            
        end
        
        function plot_scatter_2d_masked (obj)
            
            axis_array = zeros(8,4);
            
            clf
            hold on
            
            for i = 1:8
                
                score = obj.p(i).score;
                score_masked = obj.p(i).score;
                
                mask = obj.p(i).mask;
                score_masked(~mask,:) = 0;
                
                x1 = score(:,1);
                y1 = score(:,2);
                z1 = score(:,3);
                
                x1_masked = score_masked(:,1);
                y1_masked = score_masked(:,2);
                z1_masked = score_masked(:,3);
                
                range = 1:100:size(x1,1);
                
                subplot(2,4,i)
                hold on
                plot(x1(range),y1(range),'.')
                plot(x1_masked(range),y1_masked(range),'.')
                title(i)
                grid on
                
                axis_array(i,1:4) = axis;
            end
            
            % re-adjust axis
            myaxis = [min(axis_array(:,1)) max(axis_array(:,2)) min(axis_array(:,3)) max(axis_array(:,4))];
            for i = 1:8
                subplot(2,4,i)
                axis(myaxis)
                axis equal
            end
            
            % saveas(gcf,sprintf('scatter_2d.png'))
            return
        end
        
        function plot_scatter_3d_masked (obj)
            
            range_step = 100
            
            obj.adjust_figure_size;
            
            axis_array = zeros(8,6);
            
            clf
            hold on
            
            for i = 1:8
                
                score = obj.p(i).score;
                score_white = score(~obj.p(i).mask,:);
                
                score_masked = obj.p(i).score_masked;
                
                subplot(2,4,i)
                hold on
                
                range = 1:range_step:size(score_white,1);

                plot3(score_white(range,1),score_white(range,2),score_white(range,3),'o')
                plot3(score_masked(range,1),score_masked(range,2),score_masked(range,3),'.')
                
                title(i)
                grid on
                view(15,50)  % otherwise return 1x4

                axis_array(i,1:6) = axis;
               
            end
            
            % re-adjust axis
            myaxis = [min(axis_array(:,1)) max(axis_array(:,2)) min(axis_array(:,3)) max(axis_array(:,4)) min(axis_array(:,5)) max(axis_array(:,6))];
            for i = 1:8
                subplot(2,4,i)
                axis(myaxis)
                axis equal
            end
            
            saveas(gcf,sprintf('scatter_3d_masked.png'))
            return
            
        end

        function adjust_figure_size (obj)
            clf
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.2, 0.6, 0.6]);
        end
        
        function plot_masked_image_one (obj,i) 
            
            obj.adjust_figure_size;
            
            subplot(1,2,1)
            imshow(obj.p(i).rgb2)
            
            subplot(1,2,2)
            imshow(obj.p(i).rgb_masked2)
        end
        
        function plot_masked_image (obj)
            obj.adjust_figure_size;
            for i = 1:8
                subplot(4,4,i)
                imshow(obj.p(i).rgb2)

                subplot(4,4,i+8)
                imshow(obj.p(i).rgb_masked2)
            end
        end
        
        function component_correlation (obj)
            
            % load all data
            data = zeros(41,41,8);
            for i = 1:8
                data(:,:,i) = obj.p(i).coeff_masked;
            end
            
            % check only the first n vectors
            n = 41;
            n = 10;
            
            clf
            hold on
            i=1;
            for j=1:8
                order = zeros(n,1);
                for k=1:n
                    cr = corrcoef(squeeze(data(:,k,i)),squeeze(data(:,k,j)));
                    order(k,1) = cr(1,2);
                end
                
                subplot(2,4,j)
                plot(order,'-o')
                axis([1 n -1 1])
                axis square
                ylabel('R')
                title(j)
            end
            
            saveas(gcf,sprintf('component_corr.png',size(n,2),size(n,2)))
            
        end
        
        function separate (obj,i,th)
            
            score = obj.p(i).score;
            coeff = obj.p(i).coeff_masked;
            mu = obj.p(i).mu_masked;
            
            score2 = score;
            m = score2(:,1) > th;
            score2(m,:) = 0;
            
            rgb1 = obj.p(i).reconstruct(score2,mu,coeff,1:41);
            rgb2 = obj.p(i).rgb_1d_to_2d(rgb1);
            
            image(rgb2)
            
            return
            
        end
        
        function plot_pca (obj)
            % save spectral analysis of 8 images
            % WCC
            % 4-17-2020
            
            % do PCA for all images
            for i = 1:8
                obj.p(i).create_plot;
                saveas(gcf,sprintf('spectral_%d.png',i))
            end
            
            return
        end
        
    end
    
end

