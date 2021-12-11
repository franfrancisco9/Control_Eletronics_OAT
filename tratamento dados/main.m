close all
clear
clc


data_functions = leitura_dados; %defining class data
filter_functions = kalman; %defining class filter
plot_functions = plots; %defining class plots
inc_functions = inclinacao; %defining class inclinacao

%user defined
data_file_date = '06_11_2021';
data_file_name = '1º voo.txt';


%get data from the file
[sensor_reading,sensor_ref, accelx, accely, accelz, gyrox, gyroy, gyroz, ...
                magx, magy, magz, temperature] = data_functions.GET_DATA(data_file_date, data_file_name);

%define time            
tempo_arduino = (0:0.5:(0.5*(length(accelx)-1))).';

%filter data
accelx_f = filter_functions.KALMAN_F(accelx, accelx(1), 40, 1, 10, 0, 0);
accely_f = filter_functions.KALMAN_F(accely, accely(1), 40, 1, 10, 0, 0);
accelz_f = filter_functions.KALMAN_F(accelz, accelz(1), 40, 1, 10, 0, 0);
gyrox_f = filter_functions.KALMAN_F(gyrox, gyrox(1), 40, 1, 10, 0, 0);
gyroy_f = filter_functions.KALMAN_F(gyroy, gyroy(1), 40, 1, 10, 0, 0);
gyroz_f = filter_functions.KALMAN_F(gyroz, gyroz(1), 40, 1, 10, 0, 0);


%plot data raw and filtered
plot_functions.IMPRIMIR(1, tempo_arduino, accelx, accelx_f,0);
plot_functions.IMPRIMIR(2, tempo_arduino, accely, accely_f,0);
plot_functions.IMPRIMIR(3, tempo_arduino, accelz, accelz_f,0);
plot_functions.IMPRIMIR(4, tempo_arduino, gyrox, gyrox_f,0);
plot_functions.IMPRIMIR(5, tempo_arduino, gyroy, gyroy_f,0);
plot_functions.IMPRIMIR(6, tempo_arduino, gyroz, gyroz_f,0);


%calcular inclinação
gyroy_deg = gyroy*180/pi;
inclinacao_accel = inc_functions.INC_ACCEL(accelx_f,accely_f,accelz_f);
inc_accel_deg = inclinacao_accel*180/pi;
[inclinacao_gyro,ang_veloc] = inc_functions.INC_GYRO(gyroy, tempo_arduino,0);
inc_gyro_deg = inclinacao_gyro*180/pi;
ang_veloc_deg = ang_veloc*180/pi;
