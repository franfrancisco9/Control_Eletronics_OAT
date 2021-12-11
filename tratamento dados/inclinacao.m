classdef inclinacao
    methods
        function inclinacao_accel = INC_ACCEL(obj,ax,ay,az)
            inclinacao_accel = atan(ax ./ sqrt(ay.^2+ az.^2)); %rad
        end
        
        function [inclinacao_gyro, ang_veloc] = INC_GYRO(obj, gy, time,inc_0)
            ang_veloc = zeros(length(time),1);
            for i = 2:length(time)
                ang_veloc(i) = ang_veloc(i-1)+(-gy(i)-gy(i-1))/2*(time(i)-time(i-1)); %rad/s
            end
            
            inclinacao_gyro = zeros(length(time),1);
            inclinacao_gyro(1) = inc_0;
            for i = 2:length(time)
                inclinacao_gyro(i) = inclinacao_gyro(i-1)+(ang_veloc(i)+ang_veloc(i-1))/2*(time(i)-time(i-1)); %rad
            end
        end
            
%         function inclinacao_completa = KALMAN_F(obj,inc_a, inc_g)
%             
%         end
    end
end


