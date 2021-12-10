close all
clear
clc


data_functions = leitura_dados; %defining class data
filter_functions = kalman; %defining class filter
plot_functions = plots; %defining class plots

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

%define time            
tempo_arduino = 0:0.5:(0.5*(length(accelx)-1));

%filter data
accelx_f = filter_functions.KALMAN_F(accelx, accelx(1), 40, 1, 10, 0, 0);
accely_f = filter_functions.KALMAN_F(accely, accely(1), 40, 1, 10, 0, 0);
accelz_f = filter_functions.KALMAN_F(accelz, accelz(1), 40, 1, 10, 0, 0);
gyrox_f = filter_functions.KALMAN_F(gyrox, gyrox(1), 40, 1, 10, 0, 0);
gyroy_f = filter_functions.KALMAN_F(gyroy, gyroy(1), 40, 1, 10, 0, 0);
gyroz_f = filter_functions.KALMAN_F(gyroz, gyroz(1), 40, 1, 10, 0, 0);


%plot data
plot_functions.IMPRIMIR(1, tempo_arduino, accelx, accelx_f,0);
plot_functions.IMPRIMIR(2, tempo_arduino, accely, accely_f,0);
plot_functions.IMPRIMIR(3, tempo_arduino, accelz, accelz_f,0);
plot_functions.IMPRIMIR(4, tempo_arduino, gyrox, gyrox_f,0);
plot_functions.IMPRIMIR(5, tempo_arduino, gyroy, gyroy_f,0);
plot_functions.IMPRIMIR(6, tempo_arduino, gyroz, gyroz_f,0);
