"""
mavsim_python
    - Beard & McLain, PUP, 2012
    - Update history:
        27/10/2021 - FF
"""
import sys
sys.path.append('..')
import numpy as np
import parameters.simulation_parameters as SIM
from aircraft.mav_viewer import mav_viewer
from aircraft.data_viewer import data_viewer
from aircraft.wind_simulation import wind_simulation
from aircraft.autopilot import autopilot
from aircraft.mav_dynamics import mav_dynamics
from tools.signals import signals
from tools.autopilot_Command import autopilotCommand
from message_types.msg_autopilot import msg_autopilot
from message_types.msg_delta import msg_delta

# initialize the visualization
mav_view = mav_viewer()  # initialize the mav viewer
data_view = data_viewer()  # initialize view of data plots

# initialize elements of the architecture
wind = wind_simulation(SIM.ts_simulation)
mav = mav_dynamics(SIM.ts_simulation)
ctrl = autopilot(SIM.ts_simulation)

# autopilot commands
commands = msg_autopilot()
Va_command = signals(dc_offset=25.0, amplitude=3.0,
                     start_time=2.0, frequency=0.01)
h_command = signals(dc_offset=100.0, amplitude=15.0,
                    start_time=0.0, frequency=0.02)
chi_command = signals(dc_offset=np.radians(
    180), amplitude=np.radians(45), start_time=5.0, frequency=0.015)

commandWindow = autopilotCommand()
# initialize the simulation time
sim_time = SIM.start_time

# main simulation loop
while sim_time < SIM.end_time:
    commandWindow.setAutopilot(autopilot)

    # -------autopilot commands-------------
    commandWindow.root.update_idletasks()
    commandWindow.root.update()
    commands.airspeed_command = commandWindow.slideVa.get()  # Va_command.square(sim_time)
    commands.course_command = np.deg2rad(commandWindow.slideChi.get())  # chi_command.square(sim_time)
    commands.altitude_command = commandWindow.slideH.get()  # h_command.square(sim_time)

    # -------controller-------------
    if not commandWindow.paused:
        estimated_state = mav.msg_true_state  # uses true states in the control
        delta, commanded_state = ctrl.update(commands, estimated_state, sim_time)
        if (not commandWindow.autopilot):
            delta.from_array(np.array([[delta_e, delta_a, delta_r, delta_t]]).T)

        # -------physical system-------------
        current_wind = wind.update()  # get the new wind vector
        mav.update_state(delta, current_wind)  # propagate the MAV dynamics

        # -------update viewer-------------
        mav_view.update(mav.msg_true_state)  # plot body of MAV
        data_view.update(mav.msg_true_state,  # true states
                         estimated_state,  # estimated states
                         commanded_state,  # commanded states
                         delta,
                         SIM.ts_simulation)
    # -------increment time-------------
    if not commandWindow.paused:
        sim_time += SIM.ts_simulation
    if not commandWindow.open:
        break
input("Press any key to shutdown...")
