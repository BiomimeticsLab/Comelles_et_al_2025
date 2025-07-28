% Input data
x_iec=data_iec(:,1);
y_iec=data_iec(:,2);
nx_iec=data_iec(:,4);
ny_iec=data_iec(:,5);
z_iec=(180/(2*pi))*acos(cos(2*(pi/180)*data_iec(:,6)));
E_iec=data_iec(:,8);
C_iec=data_iec(:,7);

% Display E and C and select values
hist(data_iec(:,8))
E_iec_limit = input('type E limit');
hist(data_iec(:,7))
C_iec_limit = input('type C limit');

% Filter for E and C
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

% Input filtered data
inputData = [x_iec y_iec z_iec]; % Assuming 100 points with (x, y, theta)

% Extract x, y, and theta from input data
x = inputData(:, 1);
y = inputData(:, 2);
theta = inputData(:, 3);

% Compute gradient of theta
[gradThetaX, gradThetaY] = gradient(reshape(theta, [], sqrt(numel(theta))));

% Compute the topological defects
defects = zeros(size(gradThetaX));
for i = 1:numel(defects)
    Q = [gradThetaX(i), gradThetaY(i); gradThetaY(i), -gradThetaX(i)];
    [~, D] = eig(Q);
    defects(i) = sum(diag(D) < 0);
end

% Plotting
scatter(x, y, 10, defects(:), 'filled');
colorbar;
axis equal;
title('Topological Defects of Nematic Field');
xlabel('X');
ylabel('Y');
