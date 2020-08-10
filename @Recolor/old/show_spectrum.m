function show_spectrum (coeff, iorj)
hold on

if iorj == 0
    plot(380:10:780,coeff(:,1),'-r')
    plot(380:10:780,coeff(:,2),'-g')
    plot(380:10:780,coeff(:,3),'-b')
else
    plot(380:10:780,coeff(:,1),':r')
    plot(380:10:780,coeff(:,2),':g')
    plot(380:10:780,coeff(:,3),':b')
end

xlabel('Wavelength (nm)')
ylabel('Transmittance (T)')
axis([380 780 -0.5 +0.5])
axis square
legend('Comp #1','Comp #2','Comp #3')
end