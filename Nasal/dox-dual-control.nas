#############################################################################
##
##  Nasal for dual control of the DO-X over the multiplayer network.
##
##  Stolen from
##  Copyright (C) 2008 - 2010  Anders Gidenstam  (anders(at)gidenstam.org)
##  and modify by Marc Kraus (info(at)marc-kraus.de)
##  This file is licensed under the GPL license version 2 or later
##
###############################################################################

# Renaming (almost :)
var DCT = dual_control_tools;
######################################################################
# Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/DO-X/Models/dox.xml";
var copilot_type = "Aircraft/DO-X/Models/dox-copilot.xml";

props.globals.initNode("/sim/remote/pilot-callsign", "", "STRING");
######################################################################
# MP enabled properties.
# NOTE: These must exist very early during startup - put them
#       in the -set.xml file.

var pilot_aileron_rotation_deg   = "sim/multiplay/generic/float[3]";  # in dox-set.xml
var copilot_aileron_rotation_deg = "sim/multiplay/generic/float[0]";  # in dox-copilot-set.xml

var pilot_average_rpm_left = "sim/multiplay/generic/int[10]";   # in dox-set.xml
var pilot_average_rpm_right = "sim/multiplay/generic/int[11]";  # in dox-set.xml

var copilot_heading_correction_msg = "sim/multiplay/generic/string[0]";        # in dox-copilot-set.xml
var heading_correction_msg         = "/instrumentation/rdf/message-to-pilot";  # in dox-set.xml

var copilot_rdf_power_on = "sim/multiplay/generic/int[0]";        # in dox-copilot-set.xml
var copilot_select_vor_or_ndb = "sim/multiplay/generic/int[1]";   # in dox-copilot-set.xml
var copilot_adf_selected = "sim/multiplay/generic/int[2]";        # in dox-copilot-set.xml
var copilot_nav_selected = "sim/multiplay/generic/float[1]";      # in dox-copilot-set.xml
var pilot_rdf_power_on = "/instrumentation/rdf/power-on";
var pilot_select_vor_or_ndb = "/instrumentation/rdf/frequency-select-knob";  # in dox-set.xml
var pilot_adf_selected = "/instrumentation/adf/frequencies/selected-khz";    # in dox-set.xml
var pilot_nav_selected = "/instrumentation/nav/frequencies/selected-mhz";    # in dox-set.xml

var pilot_set_anchor = "sim/multiplay/generic/int[12]";  # in dox-set.xml
var copilot_see_anchor = "/controls/anchor";        # in dox-copilot-set.xml

var pilot_afn2_makeron = "sim/multiplay/generic/int[13]";          # in dox-set.xml
var pilot_afn2_heading_corr = "sim/multiplay/generic/float[4]";    # in dox-set.xml
var pilot_afn2_distance = "sim/multiplay/generic/float[5]";        # in dox-set.xml

var copilot_afn2_makeron = "/instrumentation/afn2/markeron";                 # in dox-copilot-set.xml
var copilot_afn2_heading_corr = "/instrumentation/afn2/heading-correction";  # in dox-copilot-set.xml
var copilot_afn2_distance = "/instrumentation/afn2/distance";                # in dox-copilot-set.xml

var pilot_vertical_speed = "sim/multiplay/generic/float[6]";       # in dox-set.xml
var pilot_turn_slip_skid = "sim/multiplay/generic/float[7]";       # in dox-set.xml
var pilot_turn_rate = "sim/multiplay/generic/float[8]";            # in dox-set.xml
var copilot_vertical_speed = "/instrumentation/vertical-speed-indicator/indicated-speed-fpm"; # default in copilot
var copilot_turn_slip_skid = "/instrumentation/slip-skid-ball/indicated-slip-skid";           # default in copilot
var copilot_turn_rate = "/instrumentation/turn-indicator/indicated-turn-rate";                # default in copilot

var pilot_magnetic_compass = "sim/multiplay/generic/float[9]";          # in dox-set.xml
var pilot_throttle_right = "sim/multiplay/generic/float[10]";           # in dox-set.xml
var pilot_throttle_left = "sim/multiplay/generic/float[11]";            # in dox-set.xml
var copilot_magnetic_compass = "/instrumentation/magnetic-compass/indicated-heading-deg";   # default in copilot
var copilot_throttle_right = "/controls/engines/throttle-pilot-right";                      # in dox-copilot-set.xml
var copilot_throttle_left = "/controls/engines/throttle-pilot-left";                        # in dox-copilot-set.xml

######################################################################
# Slow state properties for replication.

var fcs = "fdm/yasim/fcs";
###############################################################################
# Pilot MP property mappings and specific copilot connect/disconnect actions.
var l_dual_control         = "/fdm/yasim/fcs/dual-control/enabled";


######################################################################
# Used by dual_control to set up the mappings for the pilot.
var pilot_connect_copilot = func (copilot) {
    # Make sure dual-control is activated in the FDM FCS.
    settimer(func { setprop(l_dual_control, 1); }, 1);

    print("Open door and welcome the Copilot!");

    return 
        [
         ######################################################################
         # Process local properties for MP.
         ######################################################################
         # push local parameter in the float[]/int[] or whatever for MP
         DCT.Translator.new
         (props.globals.getNode("/instrumentation/vertical-speed-indicator/indicated-speed-fpm"),
          props.globals.getNode("/sim/multiplay/generic/float[6]", 1)),
         DCT.Translator.new
         (props.globals.getNode("/instrumentation/slip-skid-ball/indicated-slip-skid"),
          props.globals.getNode("/sim/multiplay/generic/float[7]", 1)),
         DCT.Translator.new
         (props.globals.getNode("/instrumentation/turn-indicator/indicated-turn-rate"),
          props.globals.getNode("/sim/multiplay/generic/float[8]", 1)),
         DCT.Translator.new
         (props.globals.getNode("/instrumentation/magnetic-compass/indicated-heading-deg"),
          props.globals.getNode("/sim/multiplay/generic/float[9]", 1)),
         DCT.Translator.new
         (props.globals.getNode("/controls/engines/throttle-pilot-right"),
          props.globals.getNode("/sim/multiplay/generic/float[10]", 1)),
         DCT.Translator.new
         (props.globals.getNode("/controls/engines/throttle-pilot-left"),
          props.globals.getNode("/sim/multiplay/generic/float[11]", 1)),

         ######################################################################
         # Process properties to send.
         ######################################################################
         # rotation-deg from copilot to the Pilot float
         DCT.Translator.new
         (copilot.getNode(copilot_rdf_power_on),
          props.globals.getNode(pilot_rdf_power_on, 1)),

         DCT.Translator.new
         (copilot.getNode(copilot_select_vor_or_ndb),
          props.globals.getNode(pilot_select_vor_or_ndb, 1)),

         DCT.Translator.new
         (copilot.getNode(copilot_aileron_rotation_deg),
          props.globals.getNode(pilot_aileron_rotation_deg, 1)),

         DCT.Translator.new
         (copilot.getNode(copilot_heading_correction_msg),
          props.globals.getNode(heading_correction_msg, 1)),

         DCT.Translator.new
         (copilot.getNode(copilot_adf_selected),
          props.globals.getNode(pilot_adf_selected, 1)),

         DCT.Translator.new
         (copilot.getNode(copilot_nav_selected),
          props.globals.getNode(pilot_nav_selected, 1))

        ];
}

######################################################################
var pilot_disconnect_copilot = func {
    setprop(l_dual_control, 0);
    print("Say Good Bye to Copilot!");
}

######################################################################
# Used by dual_control to set up the mappings for the copilot.
var copilot_connect_pilot = func (pilot) {

    # Map (some) properties needed to (e.g.) animate the MP/AI model.
    copilot_alias_aimodel(pilot);

    print("Copilot on board!");

    return
        [
         ######################################################################
         # Process received properties.
         ######################################################################
         ##################################################
         # Map airspeed for airspeed indicator. This is cheating!
         DCT.Translator.new
         (pilot.getNode("velocities/true-airspeed-kt"),
          props.globals.getNode("/instrumentation/" ~
                                "airspeed-indicator/indicated-speed-kt", 1)),

         ######################################################################
         # Process properties to send.

         # Map engine RPMs to the appropriate properties / NOTE: only 10 engines are supported on flightgear
         DCT.Translator.new
         (pilot.getNode("engines/engine[0]/rpm"),
          props.globals.getNode("engines/engine[0]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[1]/rpm"),
          props.globals.getNode("engines/engine[1]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[2]/rpm"),
          props.globals.getNode("engines/engine[2]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[3]/rpm"),
          props.globals.getNode("engines/engine[3]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[4]/rpm"),
          props.globals.getNode("engines/engine[4]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[5]/rpm"),
          props.globals.getNode("engines/engine[5]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[6]/rpm"),
          props.globals.getNode("engines/engine[6]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[7]/rpm"),
          props.globals.getNode("engines/engine[7]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[8]/rpm"),
          props.globals.getNode("engines/engine[8]/rpm", 1),1),
         DCT.Translator.new
         (pilot.getNode("engines/engine[9]/rpm"),
          props.globals.getNode("engines/engine[9]/rpm", 1),1),

         DCT.Translator.new
         (pilot.getNode(pilot_average_rpm_left),
          props.globals.getNode("controls/engines/average-rpm-left", 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_average_rpm_right),
          props.globals.getNode("controls/engines/average-rpm-right", 1),1),

         DCT.Translator.new
         (pilot.getNode(pilot_set_anchor),
          props.globals.getNode(copilot_see_anchor, 1),1),

         DCT.Translator.new
         (pilot.getNode(pilot_afn2_makeron),
          props.globals.getNode(copilot_afn2_makeron, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_afn2_heading_corr),
          props.globals.getNode(copilot_afn2_heading_corr, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_afn2_distance),
          props.globals.getNode(copilot_afn2_distance, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_vertical_speed),
          props.globals.getNode(copilot_vertical_speed, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_turn_slip_skid),
          props.globals.getNode(copilot_turn_slip_skid, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_turn_rate),
          props.globals.getNode(copilot_turn_rate, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_magnetic_compass),
          props.globals.getNode(copilot_magnetic_compass, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_throttle_right),
          props.globals.getNode(copilot_throttle_right, 1),1),
         DCT.Translator.new
         (pilot.getNode(pilot_throttle_left),
          props.globals.getNode(copilot_throttle_left, 1),1)

         ######################################################################
        ];
}

######################################################################
var copilot_disconnect_pilot = func {
    settimer(func { setprop(l_dual_control, 0); }, 1);
    print("Copilot from board!");
}

######################################################################
# More property aliases to animate the MP/AI model for the copilot.
#  Contains all 1:1 mappings that are not provided by other modules
#  (e.g. instruments).

var copilot_alias_aimodel = func(pilot) {
    # Whatever we need for animate the MP/AI model

    # so we can see the copilot in the copilot aircraft
    setprop(l_dual_control, 1); # set in copilots "fdm/yasim/fcs/dual-control/enabled"

}

