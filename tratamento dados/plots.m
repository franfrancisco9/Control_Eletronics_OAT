classdef plots
    methods
        function IMPRIMIR(obj,indicador, tempo, dados, dados_f, save, file_date, file_name, view)
            if view == 1
                f = figure(indicador);
                
            else
                 f = figure(indicador);
                 f.Visible = 'off'; 
            end
            scr_siz = get(0,'ScreenSize') ;
            set(f, 'Position',  [1 scr_siz(4)/4 scr_siz(3) scr_siz(4)/2])
            
            
            
            plot(tempo, dados, tempo, dados_f);
            legend('original','filtered')
            xlabel('time (s)')
            switch(indicador)
               case 1
                  titulo = ('Aceleração x');
                  ylabel('aceleração (m/s^2)');
               case 2
                  titulo = 'Aceleração y';
                  ylabel('aceleração (m/s^2)');
               case 3
                  titulo = ('Aceleração z');
                  ylabel('aceleração (m/s^2)');
               case 4
                  titulo = ('Giroscópio x');
                  ylabel('velocidade angular (rad/s)');
               case 5
                  titulo = ('Giroscópio y');
                  ylabel('velocidade angular (rad/s)');
               case 6
                  titulo = ('Giroscópio z');
                  ylabel('velocidade angular (rad/s)')
            end
            title(titulo);
            hold on
            if save == 1
                filedir1 = split(mfilename('fullpath'), '\plots');
                dir = strcat(char(filedir1(1)),"/results/", file_date, "_", split(file_name, '.txt'));
                if ~exist(dir(1), 'dir')
                    mkdir(dir(1));
                end
                cd (dir(1));
                saveas(f,strcat(dir(1), "\", titulo),'png');
            end
        end
        function IMPRIMIR_INC(obj,indicador, tempo, inc_accel, inc_gyro, inc_final, save, fig,  file_date, file_name, view)
            if view == 1
                f = figure(fig);
                
            else
                 f = figure(fig);
                 f.Visible = 'off'; 
            end
            scr_siz = get(0,'ScreenSize') ;
            set(f, 'Position',  [1 scr_siz(4)/4 scr_siz(3) scr_siz(4)/2])
            
            plot(tempo, inc_final);
            hold on
            switch(indicador)
               case 1
                  titulo = ('Inclinação_1');
                  plot(tempo, inc_accel);
                  legend('final','accel')
                  xlabel('time (s)')
               case 2
                  titulo = ('Inclinação_2');
                  plot(tempo, inc_accel, tempo, inc_gyro);
                  legend('final','accel','gyro')
                  xlabel('time (s)')
            end
            
          
            ylabel('Inclinação (graus)')
            
            title(titulo);
            hold on
            if save == 1
                filedir1 = split(mfilename('fullpath'), '\plots');
                dir = strcat(char(filedir1(1)),"/results/", file_date, "_", split(file_name, '.txt'));
                if ~exist(dir(1), 'dir')
                    mkdir(dir(1));
                end
                cd (dir(1));
                saveas(f,strcat(dir(1), "\", titulo),'png');
            end
        end
    end
end