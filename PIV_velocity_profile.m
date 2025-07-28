

x=data(:,1);
y=data(:,2);
Vx=data(:,3)*0.721/10;
Vy=data(:,4)*0.721/10;

x_min=min(x);
x_max=max(x);
delta_x=y(2)-y(1);
x_grid=x_min:delta_x:x_max;

y_min=min(y);
y_max=max(y);
y_grid=y_min:delta_x:y_max;

[X,Y]=meshgrid(x_grid,y_grid);

Zx=griddata(x,y,Vx,X,Y);
Vx_profile=mean(Zx,1,'omitNaN');
writematrix(Vx_profile,'Vx_profile.csv');
Vx_std=std(Zx,1,'omitNaN');
writematrix(Vx_std,'Vx_std.csv');

Zy=griddata(x,y,Vy,X,Y);
Vy_profile=mean(Zy,1,'omitNaN');
writematrix(Vy_profile,'Vy_profile.csv');
Vy_std=std(Zy,1,'omitNaN');
writematrix(Vy_std,'Vy_std.csv');

plot(Vx_profile)
hold on
plot(Vy_profile)