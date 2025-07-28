%% 
l=0;
%data(:,5)=1024-data(:,5);

pixel = input('type pixel size in um');
%% 

%% calcul files de cada cell

files = zeros(1, 100);
j=1;
m=0;
for i=2:length(data(:,1))
    if data(i,1)-data(i-1,1)==0
        m=m+1;
    else
        files(j)=m;
        j=j+1;
        m=0;
    end
end
%% 

%% escriptura matrius

m=max(files);
%angles(1:m,1:j)=NaN;
distancia(1:m,1:j)=NaN;
%velocitats(1:m,1:j)=NaN;
x(1:m,1:j)=NaN;
y(1:m,1:j)=NaN;
x0(1:m,1:j)=NaN;
y0(1:m,1:j)=NaN;
%% 

%% omplim les matrius amb les components de les trajectories de les cells
j=1;
m=0;
for i=2:length(data(:,1))
    if data(i,1)-data(i-1,1)==0
        m=m+1;
        x(m,j)=data(i,3)*pixel;
        y(m,j)=data(i,4)*pixel;
        x0(m,j)=data(i,3)*pixel-x(1,j);
        y0(m,j)=data(i,4)*pixel-y(1,j);
    else
        files(j)=m;
        j=j+1;
        m=0;
    end
end
%% 

%% evaluem net displacement
net_displacement_x = x(length(x(:,1)),:)-x(1,:);
net_displacement_y = y(length(x(:,1)),:)-y(1,:);

net_displacement = net_displacement_x.^2 + net_displacement_y.^2;
net_displacement = net_displacement.^(1/2);
net_displacement = net_displacement';

xlswrite('net_displacement.xls',net_displacement);

%% 

%% evaluem total distance
diff_x=diff(x);
diff_y=diff(y);

diff_x_2 = diff_x.^2;
diff_y_2 = diff_y.^2;

r2 = diff_x_2 + diff_y_2;

r = r2.^(1/2);

total_distance = sum(r);
total_distance = total_distance';
%% 

%% calcul directionality
xlswrite('total_distance.xls',total_distance);

directionality = net_displacement./total_distance;
%directionality = directionality';

xlswrite('directionality.xls',directionality);
%% 

%% Posicio del front (Vane)
Front=max(x(1,:));
x_initial=x(1,:)-Front;
x_initial=x_initial';

xlswrite('x_initial.xls',x_initial);
%% 

h = figure;
plot(x0,y0);

%% calcul angle

for i=2:length(data(:,1))-2
    if data(i+2,1)-data(i-1,1)==0
        x_a=data(i+1,3)-data(i-1,3);
        y_a=data(i+1,4)-data(i-1,4);
        r=(x_a^2 + y_a^2)^(0.5);
        if r > 2
        teta=atan2(y_a,x_a);
        data(i-1,8)=teta;
        else
        data(i-1,8)=NaN;
        end
    else
        data(i-1,8)=NaN;
    end
end

directions=atan2(net_displacement_y',net_displacement_x');
xlswrite('directions.xls',directions);

xlswrite('angles.xls',180/(pi)*data(:,8));

cos_2teta=cos(2*data(:,8));
angles2=(1/2)*180/(pi)*acos(cos_2teta);
angles2(isnan(angles2))=[];

xlswrite('angles2.xls',angles2);
%% 

%% MSD
for l=1:length(files)
N=files(l);
for k=1:N
    MSD2(k,l)=0;
    for i=1:N-k-1
        MSD2(k,l)=((x(i+k,l)-x(i,l))^2+(y(i+k,l)-y(i,l))^2)+MSD2(k,l);
    end
    MSD2(k,l)=MSD2(k,l)/(N-k);
end
end

temps2=(5:5:max(files)*5);
for i=1:length(MSD2)
cellnumber(i)=length(find(MSD2(i,:)));
end

sd_MSD2=std(MSD2,0,2);
MSD2=sum(MSD2,2);
MSD2=MSD2./cellnumber';

h=figure;
loglog(temps2,MSD2,'.');

%Input data

xdata=temps2';
ydata=MSD2;

%create persistent random wolk function

fun=@(D_P,xdata)4*D_P(1)*(xdata-D_P(2)*(1-exp(-xdata./D_P(2))));

%Fit the Model

D_P0 = [1 1];
D_P = lsqcurvefit(fun,D_P0,xdata,ydata);

x_fit = logspace(0,4);

y_fit = 4*D_P(1)*(x_fit-D_P(2)*(1-exp(-x_fit/D_P(2))));

loglog(xdata,ydata,'.')
hold on
loglog(x_fit,y_fit)

xlswrite('time_fit.xls',x_fit');
xlswrite('MSD2_fit.xls',y_fit');

xlswrite('D_P.xls',D_P');

xlswrite('MSD2.xls',MSD2);
xlswrite('time.xls',temps2');
xlswrite('sd_MSD2.xls',sd_MSD2);

