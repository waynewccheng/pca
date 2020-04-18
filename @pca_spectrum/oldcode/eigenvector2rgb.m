function eigenvector2rgb (mu, eig)

cc = ColorConversionClass;

t_target = mu + eig;

% reduce intensity
t_target = t_target / 2;

spd_target = t_target .* cc.spd_d65;
spd_d65 = cc.spd_d65;

xyz_target = cc.spd2XYZ(spd_target);
xyz_d65 = cc.spd2XYZ(spd_d65);

lab = cc.XYZ2lab(xyz_target,xyz_d65);

rgb = lab2rgb(lab)*255;

showpatt(rgb(1),rgb(2),rgb(3));
axis off

end
