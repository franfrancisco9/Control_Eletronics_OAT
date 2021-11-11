"""
autopilot block for mavsim_python
    - Beard & McLain, PUP, 2012
    - Update history:
        27/10/2021 - FF
"""

import sys

sys.path.append('..')

import numpy as np
from controls.pid_control import pidControl
from parameters import control_parameters as AP
from message_types.msg_state import msg_state
from message_types.msg_delta import msg_delta
import math


class autopilot:
    """
    autopilot - Controlar automaticamente a dinâmica e atitude do aeromodelo.
    	Inputs: msgAutopilot; delta_throttle; mavDynamics.true_state; SIM.start_time
    	Outputs: msg_state; msg_delta
    """

    def __init__(self, ts_control):
        # instantiate lateral controllers
        self.aileron_from_roll = pidControl(kp=AP.roll_kp, ki=AP.roll_ki, kd=AP.roll_kd, Ts=ts_control, sigma=0.05,
                                            low_limit=-AP.delta_a_max, high_limit=AP.delta_a_max)
        self.roll_from_course = pidControl(kp=AP.course_kp, ki=AP.course_ki, kd=0, Ts=ts_control, sigma=0.05,
                                           low_limit=-np.pi / 7.2, high_limit=np.pi / 7.2)

        # instantiate longitudinal controllers
        self.elevator_from_pitch = pidControl(kp=AP.pitch_kp, ki=0, kd=AP.pitch_kd, Ts=ts_control, sigma=0.05,
                                              low_limit=-AP.delta_e_max, high_limit=AP.delta_e_max)
        self.throttle_from_airspeed = pidControl(kp=AP.airspeed_throttle_kp, ki=AP.airspeed_throttle_ki, kd=0,
                                                 Ts=ts_control, sigma=0.05, low_limit=0, high_limit=AP.throttle_max)
        self.pitch_from_airspeed = pidControl(kp=AP.airspeed_pitch_kp, ki=AP.airspeed_pitch_ki, kd=0, Ts=ts_control,
                                              sigma=0.05, low_limit=-np.pi / 6, high_limit=np.pi / 6)
        self.pitch_from_altitude = pidControl(kp=AP.altitude_kp, ki=AP.altitude_ki, kd=0, Ts=ts_control, sigma=0.05,
                                              low_limit=-np.pi / 6, high_limit=np.pi / 6)

        # inicialize message
        self.commanded_state = msg_state()
        self.delta = msg_delta()

    def update(self, cmd, state, ts_control):
        # pn = state.pn;  		# inertial North position
        # pe = state.pe;  		# inertial East position
        h = state.h  # altitude
        Va = state.Va  # airspeed
        # alpha = state.alpha; 	# angle of attack
        # beta = state.beta;  	# side slip angle
        phi = state.phi  # roll angle
        theta = state.theta  # pitch angle
        chi = state.chi  # course angle
        p = state.p  # body frame roll rate
        q = state.q  # body frame pitch rate
        # r = state.r; 			# body frame yaw rate
        # Vg = state.Vg; 		# ground speed
        # wn = state.wn; 		# wind North
        # we = state.we; 		# wind East
        # psi = state.psi; 		# heading
        # bx = state.bx; 		# x-gyro bias
        # by = state.by; 		# y-gyro bias
        # bz = state.bz; 		# z-gyro bias

        Va_c = cmd.airspeed_command  # commanded airspeed (m/s)
        h_c = cmd.altitude_command  # commanded altitude (m)
        chi_c = cmd.course_command  # commanded course (rad)

        if ts_control == 0:
            reset_flag = 1
        else:
            reset_flag = 0

        # lateral autopilot

        phi_c = 
        phi_c =
        delta_a =
        delta_r =

        # longitudinal autopilot
        # saturate the altitude command

        # state machine

        # take_off_zone
        if h <= AP.altitude_take_off_zone:


        # climb_zone
        elif h <= h_c - AP.altitude_hold_zone:


        # descend_zone
        elif h >= h_c + AP.altitude_hold_zone:


        # altitude_hold_zone
        else:


        delta_e =

        # construct output and commanded states

        u = np.array([[delta_e], [delta_a], [delta_r], [delta_t]])
        self.delta.from_array(u)

        self.commanded_state.h = cmd.altitude_command
        self.commanded_state.Va = cmd.airspeed_command
        self.commanded_state.phi = phi_c
        self.commanded_state.theta = theta_c
        self.commanded_state.chi = cmd.course_command

        return self.delta, self.commanded_state