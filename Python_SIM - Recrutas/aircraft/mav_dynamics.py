"""
mav_dynamics
    - this file implements the dynamic equations of motion for MAV
    - use unit quaternion for the attitude state
    - Beard & McLain, PUP, 2012
    - Update history:
        27/10/2021 - FF
        11/11/2021 - FF

"""
import sys
sys.path.append('..')
import numpy as np

# load message types
from message_types.msg_state import msg_state
from message_types.msg_delta import msg_delta
import parameters.aerosonde_parameters as MAV
from tools.tools import Quaternion2Rotation, Quaternion2Euler

class mav_dynamics:
    def __init__(self, Ts):
        self._ts_simulation = Ts
        # set initial states based on parameter file
        # _state is the 13x1 internal state of the aircraft that is being propagated:
        # _state = [pn, pe, pd, u, v, w, e0, e1, e2, e3, p, q, r]
        # We will also need a variety of other elements that are functions of the _state and the wind.
        # self.true_state is a 19x1 vector that is estimated and used by the autopilot to control the aircraft:
        # true_state = [pn, pe, h, Va, alpha, beta, phi, theta, chi, p, q, r, Vg, wn, we, psi, gyro_bx, gyro_by, gyro_bz]
        self._state = np.array([[MAV.pn0],  # (0)
                               [MAV.pe0],   # (1)
                               [MAV.pd0],   # (2)
                               [MAV.u0],    # (3)
                               [MAV.v0],    # (4)
                               [MAV.w0],    # (5)
                               [MAV.e0],    # (6)
                               [MAV.e1],    # (7)
                               [MAV.e2],    # (8)
                               [MAV.e3],    # (9)
                               [MAV.p0],    # (10)
                               [MAV.q0],    # (11)
                               [MAV.r0]])   # (12)
        # store wind data for fast recall since it is used at various points in simulation
        self._wind = np.array([[0.], [0.], [0.]])  # wind in NED frame in meters/sec
        self._update_velocity_data()
        # store forces to avoid recalculation in the sensors function
        self._forces = np.array([[0.], [0.], [0.]])
        self._Va =
        self._alpha =
        self._beta =
        # initialize true_state message
        self.msg_true_state = msg_state()

    ###################################
    # public functions
    def update_state(self, delta, wind):
        '''
            Integrate the differential equations defining dynamics, update sensors
            delta = (delta_a, delta_e, delta_r, delta_t) are the control inputs
            wind is the wind vector in inertial coordinates
            Ts is the time step between function calls.
        '''
        # get forces and moments acting on rigid body
        forces_moments = self._forces_moments(delta)

        # Integrate ODE using Runge-Kutta RK4 algorithm
        time_step = self._ts_simulation
        k1 = self._derivatives(self._state, forces_moments)
        k2 = self._derivatives(self._state + time_step/2.*k1, forces_moments)
        k3 = self._derivatives(self._state + time_step/2.*k2, forces_moments)
        k4 = self._derivatives(self._state + time_step*k3, forces_moments)
        self._state += time_step/6.0 * (k1 + 2.0*k2 + 2.0*k3 + k4)

        # normalize the quaternion
        e0 = self._state.item(6)
        e1 = self._state.item(7)
        e2 = self._state.item(8)
        e3 = self._state.item(9)

        normE = np.sqrt(e0**2+e1**2+e2**2+e3**2)
        self._state[6][0] = self._state.item(6)/normE
        self._state[7][0] = self._state.item(7)/normE
        self._state[8][0] = self._state.item(8)/normE
        self._state[9][0] = self._state.item(9)/normE

        # update the airspeed, angle of attack, and side slip angles using new state
        self._update_velocity_data(wind)

        # update the message class for the true state
        self._update_msg_true_state()

    ###################################
    # private functions
    def _derivatives(self, state, forces_moments):
        """
        for the dynamics xdot = f(x, u), returns f(x, u)
        """
        # extract the states
        pn = state.item(0)
        pe = state.item(1)
        pd = state.item(2)
        u = state.item(3)
        v = state.item(4)
        w = state.item(5)
        e0 = state.item(6)
        e1 = state.item(7)
        e2 = state.item(8)
        e3 = state.item(9)
        p = state.item(10)
        q = state.item(11)
        r = state.item(12)
        #   extract forces/moments
        fx = forces_moments.item(0)
        fy = forces_moments.item(1)
        fz = forces_moments.item(2)
        l = forces_moments.item(3)
        m = forces_moments.item(4)
        n = forces_moments.item(5)


        # position kinematics
        pn_dot =
        pe_dot =
        pd_dot =

        # position dynamics
        mass = MAV.mass
        u_dot =
        v_dot =
        w_dot =

        # rotational kinematics
        e0_dot =
        e1_dot =
        e2_dot =
        e3_dot =

        # rotational dynamics
        p_dot =
        q_dot =
        r_dot =

        # collect the derivative of the states
        x_dot = np.array([[pn_dot, pe_dot, pd_dot, u_dot, v_dot, w_dot,
                           e0_dot, e1_dot, e2_dot, e3_dot, p_dot, q_dot, r_dot]]).T
        return x_dot

    def _update_velocity_data(self, wind=np.zeros((6,1))):
        # Split wind into components
        self._ur =   # u - uw
        self._vr =   # v - vw
        self._wr =   # w - ww
        # compute airspeed
        self._Va =
        # compute angle of attack
        self._alpha =
        # compute sideslip angle
        self._beta = _

    def _forces_moments(self, delta):
        """"
        return the forces on the UAV based on the state, wind, and control surfaces
        :param delta: np.matrix(delta_a, delta_e, delta_r, delta_t)
        :return: Forces and Moments on the UAV np.matrix(Fx, Fy, Fz, Ml, Mn, Mm)
        """
        # assert delta.shape == (4,1)
        de = delta.elevator
        da = delta.aileron
        dr = delta.rudder
        dt = delta.throttle
        e0 = self._state.item(6)
        e1 = self._state.item(7)
        e2 = self._state.item(8)
        e3 = self._state.item(9)
        p = self._state.item(10)
        q = self._state.item(11)
        r = self._state.item(12)


        Fg =

        M_e = 25
        sig =
        cla =
        cda =
        cxa =

        cxq =

        cxde =

        cza =

        czq =

        czde =

        c =
        b =

        Fa =

        F = Fg + Fa

        Fp =

        fx = F.item(0)\
            + Fp

        fy = F.item(1)
        fz = F.item(2)

        #  Moment time!!!
        Ma =

        Mp =

        M = Mp + Ma
        # l m and n
        Mx = M.item(0)
        My = M.item(1)
        Mz = M.item(2)

        return np.array([[fx, fy, fz, Mx, My, Mz]]).T

    def _update_msg_true_state(self):
        # update the class structure for the true state:
        #   [pn, pe, h, Va, alpha, beta, phi, theta, chi, p, q, r, Vg, wn, we, psi, gyro_bx, gyro_by, gyro_bz]
        phi, theta, psi = Quaternion2Euler(self._state[6:10])
        self.msg_true_state.pn = self._state.item(0)
        self.msg_true_state.pe = self._state.item(1)
        self.msg_true_state.h = -self._state.item(2)
        self.msg_true_state.u = self._state.item(3)
        self.msg_true_state.v = self._state.item(4)
        self.msg_true_state.w = self._state.item(5)
        self.msg_true_state.Va = self._Va
        self.msg_true_state.alpha = self._alpha
        self.msg_true_state.beta = self._beta
        self.msg_true_state.phi = phi
        self.msg_true_state.theta = theta
        self.msg_true_state.psi = psi
        self.msg_true_state.Vg = np.sqrt(
            (self._state.item(3)) ** 2 + (self._state.item(4)) ** 2 + (self._state.item(5)) ** 2)
        Vg = np.array([self._state.item(3), self._state.item(4), self._state.item(5)])
        Vg_M = np.linalg.norm(Vg)
        Vg_h = np.array([self._state.item(3), self._state.item(4), 0.])
        Vg_h_M = np.linalg.norm(Vg_h)
        Va_h = np.array([self._ur, self._vr, 0.])
        Va_h_M = np.linalg.norm(Va_h)
        self.msg_true_state.gamma = np.arccos(Vg.dot(Vg_h) / (Vg_M * Vg_h_M))
        num = Vg_h.dot(Va_h)
        den = (Vg_h_M * Va_h_M)
        frac = np.round(num / den, 8)
        self.msg_true_state.chi = psi + self._beta + np.arccos(frac)
        self.msg_true_state.p = self._state.item(10)
        self.msg_true_state.q = self._state.item(11)
        self.msg_true_state.r = self._state.item(12)
        self.msg_true_state.wn = self._wind.item(0)
        self.msg_true_state.we = self._wind.item(1)

    def _prop_force_moment_calc(self, delta_t):
        V_in = MAV.V_max*delta_t
        a = MAV.C_Q0*MAV.Made_up
