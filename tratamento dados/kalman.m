classdef kalman
    methods
        function data_f = KALMAN_F(obj,data, U_hat_0, R, H, Q, P, K)
            U_hat = U_hat_0;
            data_f = zeros(length(data),1);
            for i = 1: length(data)
                %Update Kalman Gain
                K = P * H / (H * P * H + R);
    
                %Update estimation
                U_hat = U_hat + K * (data(i) - H * U_hat);
    
                P = (1 - K * H) * P + Q;
                data_f(i) = U_hat;
            end
        end
    end
end



