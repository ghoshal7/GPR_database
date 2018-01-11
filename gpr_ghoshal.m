function [gprData, database] = gpr_ghoshal

clear all
%
[file_name,file_path, filter_index] = uigetfile('*.csv',['Select one or more exported GPR data files.'],...
    'MultiSelect','on');
if ~iscell(file_name)
    file_name = {file_name};
end
%now filename is a cell array regardless of the number of selected files.

%
[x,y] = size(file_name);
database = {};
file_id = {};

% load data individually
k=1;
for i = 1:y
    file_id{i} = fopen(file_name{i});
    the_line=0;
    data = {};
    while the_line ~= -1
        the_line = fgetl(file_id{i});
        if the_line ~= -1
            data = [data; the_line];
        end
    end
    [row_data, col_data] = size(data);
    %-------------
    for line = 1:row_data
        if contains(data(line),'Project Name:')
        %Text scan looks at current line 'l', uses a colon and comma
        %delimiter. It ignores the first field '%*s', takes the second '%s', then
        %ignores every other field after that '%*[^\n]'. 
        gprData(i).projName = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Project Location:')
        gprData(i).projLocation = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Operator:')
        gprData(i).operator = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,')); 
        elseif contains(data{line},'Project Comments:')
        gprData(i).projComments = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Y-Coordinante Reference:')
        gprData(i).yCoordRef = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Y-Coordinate Reference Side:')
        gprData(i).yCoordRefSide = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Y-Offset from Reference')
        gprData(i).yOffsetFromRef = cell2mat(textscan(data{line},'%*s %f %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'File Name:')
        %May be scenario where user alters actual file name and it no longer
        %matches the filename recorded in metadata. In this case,
        %prompt user to select the desired file name.
        fileName2 = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        if strncmp(fileName2,file_name{i},length(fileName2))
            gprData(i).fileName = fileName2;
        else
            if menu('Filename conflict. Select one.',file_name{i},fileName2)==2
                gprData(i).fileName = fileName2;
            end
        end
        elseif contains(data{line},'Creation Date and Time:')
        t = textscan(data{line},'%*s %*s %*s %*s %s %s %*[^\n]','Delimiter',' .,');
        t = string(strcat(t{1},{' '},t{2})); 
        gprData(i).dateTime = datetime(t);
        elseif contains(data{line},'File Comments:')
        gprData(i).fileComments = string(textscan(data{line},'%*s %s %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Moving Average Window Size')
        gprData(i).moveAvgWndwSize = cell2mat(textscan(data{line},'%*s %f %*[^\n]','Delimiter',':,'));
        elseif contains(data{line},'Output Interval')
        gprData(i).outputInterval = cell2mat(textscan(data{line},'%*s %f %*[^\n]','Delimiter',':,'));
        end
    end
    
    %------------
    index = find(contains(data, 'Dielectric'));
    
    m = row_data - index;
    
    temp_0 = strsplit(data{index}, ',');
    temp = find(~cellfun(@isempty, temp_0));
    [row_temp, col_temp] = size(temp);
    n = col_temp;
    
    table = zeros(m,n);
    for j = 1:m
        table(j,:) = str2num(data{j+index});
    end
    head = temp_0(1:n);
    
    raw_data = [head;num2cell(table)];
    
    %%% -----------------
    index_distance = find(~cellfun(@isempty,strfind(head,'Dist')));
    gprData(i).distance= table(:,index_distance);
    
    index_station = find(~cellfun(@isempty,strfind(head,'Stati')));
    gprData(i).station= table(:,index_station);
    
    index_lon = find(~cellfun(@isempty,strfind(head,'Longi')));
    gprData(i).longitude.longitude_1= table(:,index_lon(1));
    gprData(i).longitude.longitude_2= table(:,index_lon(2));
    gprData(i).longitude.longitude_3= table(:,index_lon(3));
    
    index_lat = find(~cellfun(@isempty,strfind(head,'Lati')));
    gprData(i).latitude.latitude_1= table(:,index_lat(1));
    gprData(i).latitude.latitude_2= table(:,index_lat(2));
    gprData(i).latitude.latitude_3= table(:,index_lat(3));
    
    index_sigq = find(~cellfun(@isempty,strfind(head,'Signal Quality')));
    gprData(i).signalQuality.signalQuality_1= table(:,index_sigq(1));
    gprData(i).signalQuality.signalQuality_2= table(:,index_sigq(2));
    gprData(i).signalQuality.signalQuality_3= table(:,index_sigq(3));
    
    index_diel = find(~cellfun(@isempty,strfind(head,'Diel')));
    gprData(i).dielectric.dielectric_1= table(:,index_diel(1));
    gprData(i).dielectric.dielectric_2= table(:,index_diel(2));
    gprData(i).dielectric.dielectric_3= table(:,index_diel(3));
    
    index_void = find(~cellfun(@isempty,strfind(head,'Void')));
    gprData(i).void= table(:,index_void);
    
   
    database{1,k} = raw_data ;
    k=k+1
    % ----------------
end
