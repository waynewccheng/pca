function showpatt (red,green,blue)
    global remote
    global ipaddr
    global portno
    imagedimx = 640; 
    imagedimy = 960;
    ia = uint8(ones(imagedimy,imagedimx,3))*128;  % image frame
    unityarray = ones(imagedimy,imagedimx); % for assignment
    
    % prepare pattern
    ia(:,:,1) = uint8(red .* unityarray);
    ia(:,:,2) = uint8(green .* unityarray);
    ia(:,:,3) = uint8(blue .* unityarray);
    % show the image
    if (remote==1)
        imwrite(ia,'1.jpg');
        boxSendImg('1.jpg',ipaddr, portno, 1)
    else
        image(ia);
        pause(0.1);
    end    
end
