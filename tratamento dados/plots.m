classdef plots
    methods
        function IMPRIMIR(obj,indicador, tempo, dados, dados_f, save)
            figure(indicador)
            scr_siz = get(0,'ScreenSize') ;
            set(gcf, 'Position',  [1 scr_siz(4)/4 scr_siz(3) scr_siz(4)/2])
            
            
            
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
                  ylabel('aceleração angular (rad/s^2)');
               case 5
                  titulo = ('Giroscópio y');
                  ylabel('aceleração angular (rad/s^2)');
               case 6
                  titulo = ('Giroscópio z');
                  ylabel('aceleração angular (rad/s^2)')
            end
            title(titulo);
            hold on
            if save = 1
                filedir = split(mfilename('fullpath'), '\plots'); %get main folder
                saveas(gca,strcat(char(filedir(1)),'\plots\',titulo),'png');
            end
        end
    end
end