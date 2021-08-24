clear
close all

% Iniciar a gravaçao do video
VIDEO = 0;  % 1 para gravar video das figuras, 0 para nao gravar, vai gravar a figura que estiver selecionada a cada momento
if VIDEO==1, video=video_writer('Aeronaves_video.mp4', SIM.ts_video); end

run('../Parametros/Simulacao_Parametros')  % Carregar SIM: Obter parametros de simulacao
run('../Parametros/Aeronave_Parametros')  % Carregar MAV: Obter parametros da aeronave

% Inicializar o visualizador da aeronave e das varáveis
mav_view = visualizador_aeronave();  
data_view = visualizador_variaveis();

% Inicializar elementos da arquitetura
mav = dinamica(SIM.ts_simulation, MAV);
% Inicilizar o tempo de simulacao
sim_time = SIM.start_time;
% Inicializar as forças, momentos e sliders/butoes
fx = 0;
fy = 0; 
fz = 0;
Mx = 0; 
My = 0; 
Mz = 0;          
%Calcular Tamanho Ecra
set(0,'units','pixels');
%Obter informaçao pixel
Pix_SS = get(0,'screensize');
%Obter altura e largura ecra
global altura;
global largura;
altura = Pix_SS(4);
largura  = Pix_SS(3);

hfig = figure(1); 
set(1, 'Name', 'Interface de Controlo Aeronave', 'NumberTitle','off')
hfig.Position = [largura/2+80, altura/2 , largura/2-80 altura/2-80];
hold on;
data12 = 0.5;
data22 = 0.5;
data32 = 0.5;
data42 = 0.5;
data52 = 0.5;
data62 = 0.5;
control2 = 1;
control3=1;
% Variaveis e parametros dos sliders e butoes de interaçao do utilizador
global zero;
zero = 1;
global Recomecar;
Recomecar = 1;
global Fim;
Fim = 1;
global Pausa;
Pausa = 1;
global data1;
data1 = 0.5;
global data2; 
data2 = 0.5;
global data3; 
data3 = 0.5;
global data4; 
data4 = 0.5;
global data5;
data5 = 0.5;
global data6;
data6 = 0.5;

ax = axes('Parent',hfig,'position',[0 0  50 50]);
slider1 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.05,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider1',...
         'Callback',@slider_callback1);
text(0.001,0.002,'-90')
text(0.0185,0.002,'+90')
text(0.01,0.0005,'Fx')

slider2 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.2,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider2',...
         'Callback',@slider_callback2);
text(0.001,0.005,'-90')
text(0.0185,0.005,'+90')
text(0.01,0.0035,'Fy')

slider3 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.35,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider3',...
         'Callback',@slider_callback3);
text(0.001,0.008,'-90')
text(0.0185,0.008,'+90')
text(0.01,0.0065,'Fz')

slider4 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.5,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider4',...
         'Callback',@slider_callback4);
text(0.001,0.011,'-0.9')
text(0.0185,0.011,'+0.9')
text(0.01,0.0095,'Mx')

slider5 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.65,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider5',...
         'Callback',@slider_callback5);
text(0.001,0.014,'-0.9')
text(0.0185,0.014,'+0.9')
text(0.01,0.0125,'My')

slider6 = uicontrol('Parent', hfig,'Style','slider',...
         'Units','normalized',...
         'Position',[0.1,0.8,0.8,0.1],...
         'Value',0.5,...
         'Tag','slider6',...
         'Callback',@slider_callback6);
text(0.001,0.017,'-0.9')
text(0.0185,0.017,'+0.9')
text(0.01,0.0155,'Mz')

button = uicontrol('Parent', hfig,'Style','pushbutton',...
         'Units','normalized',...
         'Position',[0.5 0.925 0.2 0.05],...
         'String','Zero',...
         'Callback',@button_callback);
     
button2 = uicontrol('Parent', hfig,'Style','pushbutton',...
         'Units','normalized',...
         'Position',[0.7 0.925 0.2 0.05],...
         'String','Recomecar',...
         'Callback',@button_callback2);
button3 = uicontrol('Parent', hfig,'Style','pushbutton',...
         'Units','normalized',...
         'Position',[0.1 0.925 0.2 0.05],...
         'String','Fim',...
         'Callback',@button_callback3);
button4 = uicontrol('Parent', hfig,'Style','pushbutton',...
         'Units','normalized',...
         'Position',[0.3 0.925 0.2 0.05],...
         'String','Pausa',...
         'Callback',@button_callback4);
     
% Loop principal da simulaçao
disp('Clicar Fim para sair, Recomecar para repetir simulacao e Zero para por sliders no 0');
disp('Clicar Pausa para parar simulaçao a um dado instante e clicar de novo para retomar');
while Fim ~= 0
    if (Recomecar == 0)
        sim_time = SIM.start_time;
        Recomecar = 1;
    end
    while sim_time < SIM.end_time
        %-------Variaçao das forças e momentos com os sliders-------------
            if (control3 ~= Pausa)
                while (control3 ~= Pausa)
                    if (Fim == 0)
                        break;
                    end
                    if (Recomecar == 0)
                        fx = 0;
                        fy = 0; 
                        fz = 0;
                        Mx = 0; 
                        My = 0; 
                        Mz = 0; 
                        Recomecar = 1;
                        slider1.Value = 0.5;
                        slider2.Value = 0.5;
                        slider3.Value = 0.5;
                        slider4.Value = 0.5;
                        slider5.Value = 0.5;
                        slider6.Value = 0.5;
                        mav_view = visualizador_aeronave();  
                        data_view = visualizador_variaveis();
                        sim_time = SIM.start_time;
                        mav = dinamica(SIM.ts_simulation, MAV);
                        break
                    end
                    if (zero == 0)
                        fx = 0;
                        fy = 0; 
                        fz = 0;
                        Mx = 0; 
                        My = 0; 
                        Mz = 0; 
                        zero = 1;
                        slider1.Value = 0.5;
                        slider2.Value = 0.5;
                        slider3.Value = 0.5;
                        slider4.Value = 0.5;
                        slider5.Value = 0.5;
                        slider6.Value = 0.5;
                    end
                    pause(0.005);
                end
            end

            if (Fim == 0)
                break;
            end
            if (data12 ~= data1)
                data12 = data1;
                fx = map(0,1,-90,90,data12);
            end
            if (data22 ~= data2)
                data22 = data2;
                fy = map(0,1,-90,90,data22); 
            end
            if (data32 ~= data3)
                data32 = data3;
                fz = -map(0,1,-90,90,data32);
            end
            if (data42 ~= data4)
                data42 = data4;
                Mx = map(0,1,-0.9,0.9,data42);
            end
            if (data52 ~= data5)
                data52 = data5;
                My = map(0,1,-0.9,0.9,data52);
            end
            if (data62 ~= data6)
                data62 = data6;
                Mz = map(0,1,-0.9,0.9,data62); 
            end
            if (zero == 0)
                fx = 0;
                fy = 0; 
                fz = 0;
                Mx = 0; 
                My = 0; 
                Mz = 0; 
                zero = 1;
                slider1.Value = 0.5;
                slider2.Value = 0.5;
                slider3.Value = 0.5;
                slider4.Value = 0.5;
                slider5.Value = 0.5;
                slider6.Value = 0.5;
            end

             if (Recomecar ~= 0)
                forces_moments = [fx; fy; fz; Mx; My; Mz];

                %-------Sistema fisico-------------
                mav.update_state(forces_moments, MAV);

                %-------Update dos visualizadores-------------
                mav_view.update(mav.true_state);  % Corpo do Mav
                data_view.update(mav.true_state,... % Estados Verdadeiros
                                 mav.true_state,... % Estados Estimados (nesta fase iguais)
                                 mav.true_state,... % Estados Comandados (nesta fase iguais)
                                 SIM.ts_simulation); 
                if VIDEO, video.update(sim_time);  end

                %-------Incremento do Tempo-------------
                sim_time = sim_time + SIM.ts_simulation;
             else
                fx = 0;
                fy = 0; 
                fz = 0;
                Mx = 0; 
                My = 0; 
                Mz = 0; 
                Recomecar = 1;
                slider1.Value = 0.5;
                slider2.Value = 0.5;
                slider3.Value = 0.5;
                slider4.Value = 0.5;
                slider5.Value = 0.5;
                slider6.Value = 0.5;
                mav_view = visualizador_aeronave();  
                data_view = visualizador_variaveis();
                sim_time = SIM.start_time;
                mav = dinamica(SIM.ts_simulation, MAV);

             end
    end
    pause(0.005);
end

close all
disp("Programa Terminado");
if VIDEO, video.close(); end

% Funçoes para funcionamento dos sliders e butoes
function slider_callback1(hObject,eventdata)
        global data1;
		sval = hObject.Value;
		data1 = sval;
end
    function slider_callback2(hObject,eventdata)
        global data2;
		sval = hObject.Value;
		data2 = sval;
    end
    function slider_callback3(hObject,eventdata)
        global data3;
		sval = hObject.Value;
		data3 = sval;
    end
    function slider_callback4(hObject,eventdata)
        global data4;
		sval = hObject.Value;
		data4 = sval;
    end
    function slider_callback5(hObject,eventdata)
        global data5;
		sval = hObject.Value;
		data5 = sval;
    end
    function slider_callback6(hObject,eventdata)
        global data6;
		sval = hObject.Value;
		data6 = sval;
    end
    function button_callback(hObject,eventdata)
        global zero;
        zero = 0;
    end
    function button_callback2(hObject,eventdata)
        global Recomecar;
        Recomecar = 0;
    end
    function button_callback3(hObject,eventdata)
        global Fim;
        Fim = 0;
    end
    function button_callback4(hObject,eventdata)
        global Pausa;
        Pausa = -Pausa;
    end