classdef inclinacao
    methods
        function inclinacao_accel = INC_ACCEL(obj,ax,ay,az)
            inclinacao_accel = atan(ax ./ sqrt(ay.^2+ az.^2)); %rad
        end
        
        function inclinacao_gyro = INC_GYRO(obj, gy, time,inc_0)
            inclinacao_gyro = zeros(length(time),1);
            inclinacao_gyro(1) = inc_0;
            for i = 2:length(time)
                inclinacao_gyro(i) = inclinacao_gyro(i-1)+(gy(i)+gy(i-1))/2*(time(i)-time(i-1)); %rad
            end
        end
            
        function inc_comp = INC_COMPLETA(obj,g,inc_a, inc_g, lim_inf, lim_sup)
            inc_comp = zeros(length(inc_a),1);
            inc_comp(1) = inc_a(1);
            for i = 2:length(inc_a)
                if lim_inf<g(i) && g(i)<lim_sup
                    inc_comp(i) = inc_a(i);
                else
                    inc_comp(i) = inc_comp(i-1)+inc_g(i)-inc_g(i-1);
                end
            end
        end
        function inc_pond = INC_PONDERADA(obj,g,inc_a, inc_g, target, accel_bias, exp)
            inc_pond = zeros(length(inc_a),1);
            inc_pond(1) = inc_a(1);
            for i = 2:length(inc_a)
                parte_accel = (accel_bias*g(i)^exp/target^exp)*inc_a(i);
                parte_gyro = (1-accel_bias*g(i)^exp/target^exp)*(inc_pond(i-1)+inc_g(i)-inc_g(i-1));
                inc_pond(i) = parte_accel+parte_gyro;
            end
        end
    end
end


