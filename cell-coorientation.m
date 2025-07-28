%Script to create heatmap of the difference between ISMEF and IEC vector
%fields

%load the variables
x_iec=data_iec(:,1);
y_iec=data_iec(:,2);
nx_iec=data_iec(:,4);
ny_iec=data_iec(:,5);
z_iec=(180/(2*pi))*acos(cos(2*(pi/180)*data_iec(:,6)));
E_iec=data_iec(:,8);
C_iec=data_iec(:,7);

x_mf=data_mf(:,1);
y_mf=data_mf(:,2);
nx_mf=data_mf(:,4);
ny_mf=data_mf(:,5);
z_mf=(180/(2*pi))*acos(cos(2*(pi/180)*data_mf(:,6)));
E_mf=data_mf(:,8);
C_mf=data_mf(:,7);

hist(data_iec(:,8))
E_iec_limit = input('type E limit');

hist(data_iec(:,7))
C_iec_limit = input('type C limit');

%Filter for E and C
for i=1:length(x_iec(:,1))
    if E_iec(i) < E_iec_limit
        nx_iec(i)=NaN;
        ny_iec(i)=NaN;
        z_iec(i)=NaN;
    else
        if C_iec(i) < C_iec_limit
            nx_iec(i)=NaN;
            ny_iec(i)=NaN;
            z_iec(i)=NaN;
        else
        end
    end
end

hist(data_mf(:,8))
E_mf_limit = input('type E limit');

hist(data_mf(:,7))
C_mf_limit = input('type C limit');

for i=1:length(x_mf(:,1))
    if E_mf(i) < E_mf_limit
        nx_mf(i)=NaN;
        ny_mf(i)=NaN;
        z_mf(i)=NaN;
    else
        if C_iec(i) < C_mf_limit
            nx_mf(i)=NaN;
            ny_mf(i)=NaN;
            z_mf(i)=NaN;
        else
        end
    end
end

%Create grid from x, y

x_iec_min=min(x_iec);
x_iec_max=max(x_iec);
delta_x_iec=x_iec(2)-x_iec(1);
x_grid_iec=x_iec_min:delta_x_iec:x_iec_max;

y_iec_min=min(y_iec);
y_iec_max=max(y_iec);
y_grid_iec=y_iec_min:delta_x_iec:y_iec_max;

[X_iec,Y_iec]=meshgrid(x_grid_iec,y_grid_iec);

x_mf_min=min(x_mf);
x_mf_max=max(x_mf);
delta_x_mf=x_mf(2)-x_mf(1);
x_grid_mf=x_mf_min:delta_x_mf:x_mf_max;

y_mf_min=min(y_mf);
y_mf_max=max(y_mf);
y_grid_mf=y_mf_min:delta_x_mf:y_mf_max;

[X_mf,Y_mf]=meshgrid(x_grid_mf,y_grid_mf);

%Create the Z matrix using the grid created

Z_iec=griddata(x_iec,y_iec,z_iec,X_iec,Y_iec);
Z_mf=griddata(x_mf,y_mf,z_mf,X_mf,Y_mf);

% %Generate the map
% 
% s=surface(X,Y,Z);
% s.EdgeColor = 'none';
% s.EdgeColor = 'none';
% colormap(redblue(20));
% 
% %create the components of the vector field: x component = u and y component
% %= v
% 
% u=cos(pi/180*angle);
% v=sin(pi/180*angle);

mean_angle_iec=mean(Z_iec,2,'omitNaN');
std_angle_iec=std(Z_iec,0,2,'omitNaN');
writematrix(Y_iec(:,1),'Y_iec.csv');
writematrix(mean_angle_iec,'mean_angle_iec.csv');
writematrix(std_angle_iec,'std_angle_iec.csv');
z_iec(isnan(z_iec))=[];
writematrix(z_iec(:,1),'z_iec.csv');

mean_angle_mf=mean(Z_mf,2,'omitNaN');
std_angle_mf=std(Z_mf,0,2,'omitNaN');
writematrix(Y_mf(:,1),'Y_mf.csv');
writematrix(mean_angle_mf,'mean_angle_mf.csv');
writematrix(std_angle_mf,'std_angle_mf.csv');
z_mf(isnan(z_mf))=[];
writematrix(z_mf(:,1),'z_mf.csv');

% h=figure;
% plot(mean_angle_iec,'.')
% h=figure;
% plot(mean_angle_mf,'.')

diff_angles=Z_mf-Z_iec;
cor_angles=cos(pi*2*diff_angles/180);
mean_cor_angles=mean(cor_angles,2,'omitNaN');
std_cor_angles=std(cor_angles,0,2,'omitNaN');
writematrix(mean_cor_angles,'mean_cor_angles.csv');
writematrix(std_cor_angles,'std_cor_angles.csv');

% h=figure;
% plot(mean_cor_angles,'.')

h=figure;
surface(X_iec,Y_iec,cor_angles,'EdgeColor','none','FaceColor','interp')
caxis([-1 1]);
colorbar
