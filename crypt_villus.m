% Select file using UI
datafile = uigetfile('*.xlsx', 'Select the Excel File');

[~, sheets] = xlsfinfo(datafile);

% Initialize data storage
crypt_data = {};
ta_data = {};
villus_data = {};

% Iterate over sheets
for s = 1:length(sheets)
    sheet_name = sheets{s};
    tokens = split(sheet_name, ' '); % Extract experiment, crypt number, and region
    experiment_name = tokens{1};
    crypt_number = str2double(tokens{2});
    region = tokens{3};
    
    % Read sheet data
    data = xlsread(datafile, sheet_name);
    track_numbers = unique(data(:,1)); % Get unique track numbers
    
    % Initialize matrices
    num_tracks = length(track_numbers);
    max_timepoints = max(histcounts(data(:,1))); % Find max time points per track
    x = NaN(max_timepoints, num_tracks);
    y = NaN(max_timepoints, num_tracks);
    
    % Fill matrices
    for i = 1:num_tracks
        track_id = track_numbers(i);
        track_indices = data(:,1) == track_id;
        x(1:sum(track_indices), i) = data(track_indices, 3); % X-coordinates
        y(1:sum(track_indices), i) = data(track_indices, 4); % Y-coordinates
    end
    
    % Store data in appropriate group
    if strcmp(region, 'crypt')
        crypt_data{end+1} = struct('exp', experiment_name, 'crypt', crypt_number, 'x', x, 'y', y);
    elseif strcmp(region, 'TA')
        ta_data{end+1} = struct('exp', experiment_name, 'crypt', crypt_number, 'x', x, 'y', y);
    elseif strcmp(region, 'Villus')
        villus_data{end+1} = struct('exp', experiment_name, 'crypt', crypt_number, 'x', x, 'y', y);
    end
end

% Compute crypt centroids for each experiment and crypt number
centroids = containers.Map;
for i = 1:length(crypt_data)
    key = sprintf('%s_%d', crypt_data{i}.exp, crypt_data{i}.crypt);
    centroid_x = nanmean(crypt_data{i}.x(1, :));
    centroid_y = nanmean(crypt_data{i}.y(1, :));
    centroids(key) = [centroid_x, centroid_y];
end

% Standardize coordinates using crypt centroid as origin
normalize_coords = @(x, y, centroid) deal(x - centroid(1), y - centroid(2));

for i = 1:length(crypt_data)
    key = sprintf('%s_%d', crypt_data{i}.exp, crypt_data{i}.crypt);
    [crypt_data{i}.x, crypt_data{i}.y] = normalize_coords(crypt_data{i}.x, crypt_data{i}.y, centroids(key));
end
for i = 1:length(ta_data)
    key = sprintf('%s_%d', ta_data{i}.exp, ta_data{i}.crypt);
    if isKey(centroids, key)
        [ta_data{i}.x, ta_data{i}.y] = normalize_coords(ta_data{i}.x, ta_data{i}.y, centroids(key));
    end
end
for i = 1:length(villus_data)
    key = sprintf('%s_%d', villus_data{i}.exp, villus_data{i}.crypt);
    if isKey(centroids, key)
        [villus_data{i}.x, villus_data{i}.y] = normalize_coords(villus_data{i}.x, villus_data{i}.y, centroids(key));
    end
end

% Define custom colors
crypt_color = [62, 38, 168] / 255;
% ta_color = [11, 189, 189] / 255;
% villus_color = [254, 201, 52] / 255;
villus_color = [11, 189, 189] / 255;


% Plot trajectories with different colors
figure; hold on;
for i = 1:length(crypt_data)
    plot(crypt_data{i}.x, crypt_data{i}.y, 'Color', crypt_color, 'LineWidth', 2); 
end
% for i = 1:length(ta_data)
%     plot(ta_data{i}.x, ta_data{i}.y, 'Color', ta_color, 'LineWidth', 2);
% end
for i = 1:length(villus_data)
    plot(villus_data{i}.x, villus_data{i}.y, 'Color', villus_color, 'LineWidth', 2);
end
xlabel('X (standardized)'); ylabel('Y (standardized)');
% legend({'Crypt', 'TA', 'Villus'});
legend({'Crypt', 'Villus'});
axis equal; grid off;
xlim([-200, 800]);
ylim([-500, 500]);
hold off;
