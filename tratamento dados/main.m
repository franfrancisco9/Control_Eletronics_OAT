clear all
clc
close


data_functions = leitura_dados; %defining class data

%user defined
data_file_date = '06_11';
data_file_name = '1º voo.txt';

filedir = split(mfilename('fullpath'), '\main'); %get main folder
cd (char(filedir(1))); %go to main

%go into the data file folder
data_file_dir = strcat('.\data\', data_file_date);
cd (data_file_dir);

%get data from the file
[sensor_reading,sensor_ref, accelx, accely, accelz, gyrox, gyroy, gyroz, ...
                magx, magy, magz, temperature] = data_functions.GET_DATA(data_file_name);


