function [result] = map(u1, u2, v1, v2, val)

    % funçao que nos da valor interpolado de um intervalo para outro
    result = (val - u1)*(v2 - v1)/(u2 - u1) + v1;

end

