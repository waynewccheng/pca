range = 1:100:570544;
clf
hold on
for i = 1:8
    x1 = p(i).score(:,1);
    y1 = p(i).score(:,2);
    z1 = p(i).score(:,3);
    subplot(2,4,i)
    %plot3(x1(range),y1(range),z1(range),'.')
    plot(x1(range),y1(range),'.')
    title(i)
    axis equal
end
