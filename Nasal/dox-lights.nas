# ==================================================
# Interior and Exterior lights and lighting
# ==================================================

###########################   Lights interior on/off  ###################################

var interiorLights = func {
  var p = getprop("/controls/lighting/panel");
  var n = getprop("/controls/lighting/navigationcabin");
  var e = getprop("/controls/lighting/engineerpanel");
  var r = getprop("/controls/lighting/radiocabin");
  var h = getprop("/controls/lighting/helpenginecabin");

  # if one of the lights is on, switch all off
  # else switch all on
  var c = p + n + e + r + h;

  if (c == 0) {
    setprop("/controls/lighting/panel",1);
    setprop("/controls/lighting/navigationcabin",1);
    setprop("/controls/lighting/engineerpanel",1);
    setprop("/controls/lighting/radiocabin",1);
    setprop("/controls/lighting/helpenginecabin",1);
  }else{
    setprop("/controls/lighting/panel",0);
    setprop("/controls/lighting/navigationcabin",0);
    setprop("/controls/lighting/engineerpanel",0);
    setprop("/controls/lighting/radiocabin",0);
    setprop("/controls/lighting/helpenginecabin",0);
  }
}

###############   Lights exterior on/off and flash of beacon and strobe  #################
# initialize the beacon param
beacon_switch = props.globals.getNode("/sim/model/lights/beacon/state", 1);
beacon_switch.setValue(0.0);

var beaconFlashlight = func{
    var val=getprop("/sim/model/lights/beacon/state") + 0.05;
    if(val >1.0) val = 0;
    setprop("/sim/model/lights/beacon/state",val);
    # increase at framerate time
    settimer(beaconFlashlight, 0);
}

# initialize the strobe param
strobe_switch = props.globals.getNode("/sim/model/lights/strobe/state", 1);
strobe_switch.setValue(0.0);

var strobeFlashlight = func{
    var val=getprop("/sim/model/lights/strobe/state") + 0.05;
    if(val >1.0) val = 0;
    setprop("/sim/model/lights/strobe/state",val);
    # increase at framerate time
    settimer(strobeFlashlight, 0.125);
}

# fire it up
beaconFlashlight();
strobeFlashlight();




