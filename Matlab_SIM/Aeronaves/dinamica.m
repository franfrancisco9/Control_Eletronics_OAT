classdef dinamica < handle
   %--------------------------------
    properties
        ts_simulation
        state
        true_state
    end
    %--------------------------------
    methods
        %------constructor-----------
        function self = dinamica(Ts, MAV)
            self.ts_simulation = Ts; % tempo entre chamada de funçoes
            self.state = [MAV.pn0; MAV.pe0; MAV.pd0; MAV.u0; MAV.v0; MAV.w0;...
                MAV.e0; MAV.e1; MAV.e2; MAV.e3; MAV.p0; MAV.q0; MAV.r0];
            addpath('../Mensagens'); self.true_state = msg_state();
        end
        %---------------------------
        function self=update_state(self, forces_moments, MAV)
            % Integrar as equaçoes diferenciais que definem a dinamica.
            % forces moments sao as forças e os momentos do MAV
            % Integrar ODE usando Runge-Kutta RK4
            k1 = self.derivatives(self.state, forces_moments, MAV);
            k2 = self.derivatives(self.state + self.ts_simulation/2*k1, forces_moments, MAV);
            k3 = self.derivatives(self.state + self.ts_simulation/2*k2, forces_moments, MAV);
            k4 = self.derivatives(self.state + self.ts_simulation*k3, forces_moments, MAV);
            self.state = self.state + self.ts_simulation/6 * (k1 + 2*k2 + 2*k3 + k4);
            
            % Normalizar o quaterniao
            self.state(7:10) = self.state(7:10)/norm(self.state(7:10));
            self.update_true_state();
        end
        %----------------------------
        function xdot = derivatives(self, state, forces_moments, MAV)
            pn    = state(1);
            pe    = state(2);
            pd    = state(3);
            u     = state(4);
            v     = state(5);
            w     = state(6);
            e0    = state(7);
            e1    = state(8);
            e2    = state(9);
            e3    = state(10);
            p     = state(11);
            q     = state(12);
            r     = state(13);
            fx    = forces_moments(1);
            fy    = forces_moments(2);
            fz    = forces_moments(3);
            ell   = forces_moments(4);
            m     = forces_moments(5);
            n     = forces_moments(6);
        
            % Cinematica da posicao
            pn_dot = u*(e1^2+e0^2-e2^2-e3^2) + v*(2*(e1*e2-e3*e0)) + w * (2*(e1*e3+e2*e0));
            pe_dot = v*(e2^2+e0^2-e1^2-e3^2) + u*(2*(e1*e2+e3*e0)) + w * (2*(e2*e3-e1*e0));
            pd_dot = w*(e3^2+e0^2-e1^2-e2^2) + v*(2*(e3*e2+e1*e0)) + u * (2*(e1*e3-e2*e0));

            % Posicao dinamica
            u_dot = (r*v-q*w)+ 1/(MAV.mass)*fx;
            v_dot = (p*w-r*u)+ 1/(MAV.mass)*fy;
            w_dot = (q*u-p*v)+ 1/(MAV.mass)*fz;
            
            % Cinemtica rotacional
            e0_dot = 0.5*(-e1*p-q*e2-r*e3);
            e1_dot = 0.5*(e0*p+r*e2-q*e3);
            e2_dot = 0.5*(e0*q-r*e1+p*e3);
            e3_dot = 0.5*(e0*r+q*e1-p*e2);
            
            %J's Valores
            jx = MAV.Jx;
            jy = MAV.Jy;
            jz = MAV.Jz;
            jxz = MAV.Jxz;
            %Gama Valores
            Gama = jx*jz-(jxz)^2;
            Gama1 = (jxz*(jx-jy+jz))/Gama;
            Gama2 = (jz*(jz-jy)+(jxz)^2)/Gama;
            Gama3 = jz/Gama;
            Gama4 = jxz/Gama;
            Gama5 = (jz-jx)/jy;
            Gama6 = jxz/jy;
            Gama7 = ((jx-jy)*jx+(jxz)^2)/Gama;
            Gama8 = jx/Gama;
           
            % Dinamica rotacional
            p_dot = Gama1*p*q-Gama2*q*r+Gama3*ell+Gama4*n;
            q_dot = Gama5*p*r-Gama6*(p^2-r^2)+1/jy*m;
            r_dot = Gama7*p*q-Gama1*q*r+Gama4*ell+Gama8*n;
        
            % Coletar todas as derivadas dos estados
            xdot = [pn_dot; pe_dot; pd_dot; u_dot; v_dot; w_dot;...
                    e0_dot; e1_dot; e2_dot; e3_dot; p_dot; q_dot; r_dot];
        end
        %----------------------------
        function self=update_true_state(self)
             [phi, theta, psi] = Quaternion2Euler(self.state(7:10));
            self.true_state.pn = self.state(1);  % pn
            self.true_state.pe = self.state(2);  % pd
            self.true_state.h = -self.state(3);  % h
            self.true_state.phi = phi; % phi
            self.true_state.theta = theta; % theta
            self.true_state.psi = psi; % psi
            self.true_state.p = self.state(11); % p
            self.true_state.q = self.state(12); % q
            self.true_state.r = self.state(13); % r
        end
    end
end