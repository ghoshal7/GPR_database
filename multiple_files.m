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
    index = find(contains(data, 'Dielectric'));
    [row_data, col_data] = size(data);
    m = row_data - index;
    
    temp_0 = strsplit(data{index}, ',');
    temp = find(~cellfun(@isempty, temp_0));
    [row_temp, col_temp] = size(temp);
    n = col_temp;
    
    table = zeros(m,n);
    for i = 1:m
        table(i,:) = str2num(data{i+index});
    end
    head = temp_0(1:n);
    raw_data = [head;num2cell(table)];
   
    database{1,k} = raw_data ;
    k=k+1
 end




