close all
clear
clc

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

data_functions = leitura_dados; %defining class data
filter_functions = kalman; %defining class filter
plot_functions = plots; %defining class plots
inc_functions = inclinacao; %defining class inclinacao

%user defined
data_file_date = input("Please input the date of the file (Eg: '06_11_2021'): ");
data_file_name = input("Please input the name of the file (Eg: '1ºvoo.txt'): ");
view = input("Do you want to see the plots? 1 if yes and 0 if no: ");
save = input("Do you want to save the plots? 1 if yes and 0 if no: ");
%get data from the file
% try
    [sensor_reading,sensor_ref, accelx, accely, accelz, gyrox, gyroy, gyroz, ...
                    magx, magy, magz, temperature] = data_functions.GET_DATA(data_file_date, data_file_name);
% catch 
%     warning("Invalid file date or name!")
%     return;
% end

%define time            
tempo_arduino = (0:0.5:(0.5*(length(accelx)-1))).';

%filter data
accelx_f = filter_functions.KALMAN_F(accelx, accelx(1), 40, save, 10, 0, 0);
accely_f = filter_functions.KALMAN_F(accely, accely(1), 40, save, 10, 0, 0);
accelz_f = filter_functions.KALMAN_F(accelz, accelz(1), 40, save, 10, 0, 0);
gyrox_f = filter_functions.KALMAN_F(gyrox, gyrox(1), 40, save, 10, 0, 0);
gyroy_f = filter_functions.KALMAN_F(gyroy, gyroy(1), 40, save, 10, 0, 0);
gyroz_f = filter_functions.KALMAN_F(gyroz, gyroz(1), 40, save, 10, 0, 0);


%plot data raw and filtered
plot_functions.IMPRIMIR(1, tempo_arduino, accelx, accelx_f,1, data_file_date, data_file_name, view);
plot_functions.IMPRIMIR(2, tempo_arduino, accely, accely_f,1, data_file_date, data_file_name, view);
plot_functions.IMPRIMIR(3, tempo_arduino, accelz, accelz_f,1, data_file_date, data_file_name, view);
plot_functions.IMPRIMIR(4, tempo_arduino, gyrox, gyrox_f,1, data_file_date, data_file_name, view);
plot_functions.IMPRIMIR(5, tempo_arduino, gyroy, gyroy_f,1, data_file_date, data_file_name, view);
plot_functions.IMPRIMIR(6, tempo_arduino, gyroz, gyroz_f,1, data_file_date, data_file_name, view);


%calcular inclinação
gyroy_deg = gyroy*180/pi;
inclinacao_accel = inc_functions.INC_ACCEL(accelx,accely,accelz);
inc_accel_deg = inclinacao_accel*180/pi;
inclinacao_gyro = inc_functions.INC_GYRO(gyroy, tempo_arduino,0);
inc_gyro_deg = inclinacao_gyro*180/pi;

g = sqrt(accelx.^2+accely.^2+accelz.^2);
inc_completa = inc_functions.INC_COMPLETA(g,inclinacao_accel, inclinacao_gyro, 9.71, 9.77);
inc_completa_deg = inc_completa*180/pi;

accel_bias = 0.1;
exp = 0.0001;
inc_pond = inc_functions.INC_PONDERADA(g,inclinacao_accel, inclinacao_gyro,mean(g(1:4)), accel_bias, exp);
inc_pond_deg = inc_pond*180/pi;


plot_functions.IMPRIMIR_INC(2, tempo_arduino, inc_accel_deg, inc_gyro_deg, inc_completa_deg, save, 7, data_file_date, data_file_name, view)

plot_functions.IMPRIMIR_INC(2, tempo_arduino, inc_accel_deg, inc_gyro_deg, inc_pond_deg, save, 8, data_file_date, data_file_name, view)

