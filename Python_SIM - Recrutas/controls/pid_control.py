"""
pid_control
    - Beard & McLain, PUP, 2012
    - Update history:
        27/10/2021 - FF
        11/11/2021 - FF
"""

import sys
import numpy as np
sys.path.append('..')

class pidControl:
    """
    Controlador PID - Define um controlador multifacetado que funciona para cada um dos parâmetros do aeromodelo.
    	INIT_Input: kp, ki, kd da variável a controlar; sim_time; sigma; limites de satuação;
    	UPDATE_Input: prev_u (assegurar continuidade no delta_t); y_ref (valor de referência); y (valor atual); reset_flag;
    	UPDATE_WITH_RATE_Input: y_ref; y; ydot (primeira derivada da variável de controlo); reset_flag;
    	Output: u_sat (variável que representa o valor do próximo estado no controlo - já com saturações)
    """
    def __init__(self, kp=0.0, ki=0.0, kd=0.0, Ts=0.01, sigma=0.05, low_limit=0.0, high_limit = 1.0):
    	self.kp = kp
    	self.ki = ki
    	self.kd = kd
    	self.Ts = Ts
    	self.high_limit = high_limit
    	self.low_limit = low_limit
    	self.integrator = 0.0
    	self.error_delay_1 = 0.0
    	self.error_dot_delay_1 = 0.0
    	self.y_dot = 0.0
    	self.y_delay_1 = 0.0
    	self.y_dot_delay_1 = 0.0


    	# gains for differentiator
    	self.a1 =
    	self.a2 =

    def update(self, y_ref, y, reset_flag=False):
    	if reset_flag is True:
    		self.integrator = 0.0
    		self.error_delay_1 = 0.0
    		self.y_dot = 0.0
    		self.y_delay_1 = 0.0
    		self.y_dot_delay_1 = 0.0
        # compute the error
    	error =
        # update the integrator using trapazoidal rule
    	self.integrator =
        # update the differentiator
    	error_dot =
        # PID control
    	u =


        # saturate PID control at limit
    	u_sat = self._saturate(u)
        # integral anti-windup
        #   adjust integrator to keep u out of saturation
    	if np.abs(self.ki) > 0.0001:
    		self.integrator =

        # update the delayed variables
    	self.error_delay_1 = error
    	self.error_dot_delay_1 = error_dot
    	return u_sat

    def update_with_rate(self, y_ref, y, ydot, reset_flag=False):
    	if reset_flag is True:
    		self.integrator = 0.0
    		self.error_delay_1 = 0.0
        # compute the error
    	error =
        # update the integrator using trapazoidal rule
    	self.integrator =

        # PID control
    	u =


        # saturate PID control at limit
    	u_sat = self._saturate(u)
        # integral anti-windup
        #   adjust integrator to keep u out of saturation
    	if np.abs(self.ki) > 0.0001:
    		self.integrator =

    	self.error_delay_1 = error
    	return u_sat

    def _saturate(self, u):
    	# saturate u at +- self.limit

    	if u >= self.high_limit:
    		u_sat =
    	elif u <= self.low_limit:
    		u_sat =
    	else:
    		u_sat =
    	return u_sat
