classdef leitura_dados
    methods
        function [sensor_reading,sensor_ref, accelx, accely, accelz, gyrox, gyroy, gyroz, ...
                magx, magy, magz, temperature]= GET_DATA(obj,file_name)
            data_file_id = fopen(file_name,'r');
            DATAO = textscan(data_file_id, '%f%f%f%f%f%f%f%f%f%f%f%f', 'HeaderLines',1 , 'Delimiter', ' ','TreatAsEmpty','~');
            %DATAO = fscanf(data_dile_id,'%*s = %f');
            fclose(data_file_id);
            readings = cell2mat(DATAO);
            sensor_reading = readings(:,1);
            sensor_ref = readings(:,2);
            accelx = readings(:,3);
            accely = readings(:,4);
            accelz = readings(:,5);
            gyrox = readings(:,6);
            gyroy = readings(:,7);
            gyroz = readings(:,8);
            magx = readings(:,9);
            magy = readings(:,10);
            magz = readings(:,11);
            temperature = readings(:,12);
        end
    end
end