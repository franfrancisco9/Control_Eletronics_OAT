classdef visualizador_aeronave < handle
    %
    %    Create spacecraft animation
    %
    %--------------------------------
    properties
        body_handle
    	Vertices
    	Faces
    	facecolors
        plot_initialized
    end
    %--------------------------------
    methods
        %------constructor-----------
        function self = visualizador_aeronave
            self.body_handle = [];
            [self.Vertices, self.Faces, self.facecolors] = self.define_spacecraft();
            self.plot_initialized = 0;           
        end
        %---------------------------
        function self=update(self, state)
            global largura;
            global altura;
            if self.plot_initialized==0
                h = figure(3); clf;
                set(3, 'Name', 'Visualizador Aeronave', 'NumberTitle','off')
                h.Position = [0, 0 , largura/2+80 altura];
                self=self.drawBody(state.pn, state.pe, -state.h,...
                                   state.phi, state.theta, state.psi);
                title('Spacecraft')
                xlabel('East')
                ylabel('North')
                zlabel('-Down')
                view(40,50)  % defenir angulo de visao da figura
                axis([-250,250,-250,250,-250,250]);
                hold on
                grid on
                self.plot_initialized = 1;
            else
                self=self.drawBody(state.pn, state.pe, -state.h,... 
                                   state.phi, state.theta, state.psi);

            end
        end
        %---------------------------
        function self = drawBody(self, pn, pe, pd, phi, theta, psi)
            Vertices = self.rotate(self.Vertices, phi, theta, psi);   % rodar corpo rigido 
            Vertices = self.translate(Vertices, pn, pe, pd);     % translaçao apos rotaçao
            % transformar vertices de NED para ENU (para matlab)
            R = [...
                0, 1, 0;...
                1, 0, 0;...
                0, 0, -1;...
                ];
            Vertices = R*Vertices;
            if isempty(self.body_handle)
                self.body_handle = patch('Vertices', Vertices', 'Faces', self.Faces,...
                                             'FaceVertexCData',self.facecolors,...
                                             'FaceColor','flat');
            else
                set(self.body_handle,'Vertices',Vertices','Faces',self.Faces);
                drawnow
            end
        end 
        %---------------------------
        function pts=rotate(self, pts, phi, theta, psi)
            % defenir a matriz de rotaçao
            R_roll = [...
                        1, 0, 0;...
                        0, cos(phi), sin(phi);...
                        0, -sin(phi), cos(phi)];
            R_pitch = [...
                        cos(theta), 0, -sin(theta);...
                        0, 1, 0;...
                        sin(theta), 0, cos(theta)];
            R_yaw = [...
                        cos(psi), sin(psi), 0;...
                        -sin(psi), cos(psi), 0;...
                        0, 0, 1];
            R = R_roll*R_pitch*R_yaw;   % referencial de inercia para o do corpo
            R = R';  % referencial do corpo para inercial
            % Rotacao dos vertices
            pts = R*pts;
        end
        %---------------------------
        % Translacao dos vertices com pn, pe, pd
        function pts = translate(self, pts, pn, pe, pd)
            pts = pts + repmat([pn;pe;pd],1,size(pts,2));
        end
        %---------------------------
        function [V, F, colors] = define_spacecraft(self)
            % Defenicao dos vertices (localizaçao fisica dos vertices)
            V = [...
                10   0    0;... % point 1
                5   2.5    -2.5;... % point 2
                5   -2.5    -2.5;... % point 3
                5   -2.5    2.5;... % point 4
                5   2.5   2.5;... % point 5
                -30   0   0;... % point 6
                0   20  0;... % point 7
                -10  20   0;... % point 8
                -10  -20  0;... % point 9
                0 -20  0;... % point 10
                -20 10  0;... % point 11
                -30  10  0;... % point 12
                -30  -10  0;... % point 13
                -20  -10  0;... % point 14
                -20  0  0;... % point 15
                -30  0  -5;... % point 16
            ]';

            % defenir faces como conjunto de vertices em cima
            F = [...
                    1, 2,  3;...  % front
                    1, 3,  4;...  % back
                    1, 4,  5;...  % back
                    1, 2,  5;...  % back
                    2, 3, 6;...  % back
                    6, 3,  4;...  % back
                    6, 5,  2;...  % back
                    6, 5,  4;...  % back
                    7, 8,  9;...  % back
                    9, 10,  7;...  % back
                    6,15,  16;...  % back
                    11, 12,  13;...  % back
                    11, 13,  14;...  % back
                    ];

            % defenir as cores de cada face 
            myred = [1, 0, 0];
            mygreen = [0, 1, 0];
            myblue = [0, 0, 1];
            myyellow = [1, 1, 0];
            mycyan = [0, 1, 1];

            colors = [...
                myred;...    % front
                mygreen;...  % back
                myblue;...   % right
                myyellow;... % left
                mycyan;...   % top
                mycyan;...   % bottom
                mycyan;...   % top
                mycyan;...   % bottom
                mycyan;...   % top
                mycyan;...   % bottom
                mycyan;...   % top
                mycyan;...   % bottom
                mycyan;...   % top
                ];
        end
    end
end