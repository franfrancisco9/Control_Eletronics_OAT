classdef visualizador_variaveis < handle
    %
    %    plot MAV Estados
    %
    %--------------------------------
    properties
    	pn_handle
    	pe_handle
    	h_handle
        
    	phi_handle
    	theta_handle
        psi_handle
       
    	p_handle
    	q_handle
    	r_handle
        bx_handle
        by_handle
        bz_handle
        plot_initialized
        time
        plot_rate
        time_last_plot
    end
    %--------------------------------
    methods
        %------constructor-----------
        function self = visualizador_variaveis
            self.pn_handle = [];
            self.pe_handle = [];
            self.h_handle = [];
           
            self.phi_handle = [];
            self.theta_handle = [];
            self.psi_handle = [];
           
            self.p_handle = [];
            self.q_handle = [];
            self.r_handle = [];
     
            self.time = 0;
            self.plot_rate = .1;
            self.time_last_plot = self.time;
            self.plot_initialized = 0;    
        end
        %---------------------------
        function self=update(self, true, estimated, commanded, Ts)
            global largura;
            global altura;
            if self.plot_initialized==0
                f = figure(2); clf;
                set(2, 'Name', 'Variaveis da Aeronave', 'NumberTitle','off')
                f.Position = [largura/2+80, 0 , largura/2-80 altura/2-80];
                subplot(3,3,1)
                    hold on
                    self.pn_handle = self.graph_y_yhat_yd(self.time, true.pn, estimated.pn, commanded.pn, [], 'p_n');
                subplot(3,3,2)
                    hold on
                    self.phi_handle = self.graph_y_yhat_yd(self.time, true.phi, estimated.phi, commanded.phi, [], '\phi');
                subplot(3,3,3)
                    hold on
                    self.p_handle = self.graph_y_yhat(self.time, true.p, estimated.p, [], 'p');
                subplot(3,3,4)
                    hold on
                    self.pe_handle = self.graph_y_yhat(self.time, true.pe, estimated.pe, [], 'p_e');
                subplot(3,3,5)
                    hold on
                    self.theta_handle = self.graph_y_yhat_yd(self.time, true.theta, estimated.theta, commanded.theta, [], '\theta');
                subplot(3,3,6)
                    hold on
                    self.q_handle = self.graph_y_yhat(self.time, true.q, estimated.q, [], 'q');
                subplot(3,3,7)
                    hold on
                    self.h_handle = self.graph_y_yhat_yd(self.time, true.h, estimated.h, commanded.h, [], 'h');
                subplot(3,3,8)
                    hold on
                    self.psi_handle = self.graph_y_yhat(self.time, true.psi, estimated.psi, [], '\psi');
                subplot(3,3,9)
                    hold on
                    self.r_handle = self.graph_y_yhat(self.time, true.r, estimated.r, [], 'r');
                self.plot_initialized = 1;
            else
                if self.time >= self.time_last_plot + self.plot_rate
                    self.graph_y_yhat(self.time, true.pn, estimated.pn, self.pn_handle);
                    self.graph_y_yhat(self.time, true.pe, estimated.pe, self.pe_handle);
                    self.graph_y_yhat_yd(self.time, true.h, estimated.h, commanded.h, self.h_handle);
                    
                    self.graph_y_yhat_yd(self.time, true.phi, estimated.phi, commanded.phi, self.phi_handle);
                    self.graph_y_yhat_yd(self.time, true.theta, estimated.theta, commanded.theta, self.theta_handle);
                    self.graph_y_yhat(self.time, true.psi, estimated.psi, self.psi_handle);

                    self.graph_y_yhat(self.time, true.p, estimated.p, self.p_handle);
                    self.graph_y_yhat(self.time, true.q, estimated.q, self.q_handle);
                    self.graph_y_yhat(self.time, true.r, estimated.r, self.r_handle);

                    self.time_last_plot = self.time;
                end
                self.time = self.time + Ts;
            end
        end
        %---------------------------
        function handle = graph_y_yhat_yd(self, t, y, yhat, yd, handle, lab)
            if isempty(handle)
                handle(1)   = plot(t,y,'b');
                handle(2)   = plot(t,yhat,'g--');
                handle(3)   = plot(t,yd,'r-.');
                ylabel(lab)
                set(get(gca,'YLabel'),'Rotation',0.0);
            else
                set(handle(1),'Xdata',[get(handle(1),'Xdata'),t]);
                set(handle(1),'Ydata',[get(handle(1),'Ydata'),y]);
                set(handle(2),'Xdata',[get(handle(2),'Xdata'),t]);
                set(handle(2),'Ydata',[get(handle(2),'Ydata'),yhat]);
                set(handle(3),'Xdata',[get(handle(3),'Xdata'),t]);
                set(handle(3),'Ydata',[get(handle(3),'Ydata'),yd]);     
                %drawnow
            end
        end
        %---------------------------
        function handle = graph_y_yhat(self, t, y, yhat, handle, lab)
            if isempty(handle)
                handle(1)   = plot(t,y,'b');
                handle(2)   = plot(t,yhat,'g--');
                ylabel(lab)
                set(get(gca,'YLabel'),'Rotation',0.0);
            else
                set(handle(1),'Xdata',[get(handle(1),'Xdata'),t]);
                set(handle(1),'Ydata',[get(handle(1),'Ydata'),y]);
                set(handle(2),'Xdata',[get(handle(2),'Xdata'),t]);
                set(handle(2),'Ydata',[get(handle(2),'Ydata'),yhat]);
                %drawnow
            end
        end
        
    end
end