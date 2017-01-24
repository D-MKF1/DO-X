###############################################################################
setlistener("/sim/signals/fdm-initialized", func {
    # Disable the autopilot menu.
    gui.menuEnable("autopilot", 0);
});


################################################################################
# Support the sound
setlistener("/controls/engines/average-rpm-left", func(rpm) {
    var rpm = rpm.getValue();
    if (rpm >= 500){
      setprop("/engines/engine[0]/mp-osi",20);
      setprop("/engines/engine[0]/running",1);
    }
    if (rpm < 500){
      setprop("/engines/engine[0]/mp-osi",0);
      setprop("/engines/engine[0]/running",1);
    }
    if (rpm < 100){
      setprop("/engines/engine[0]/mp-osi",0);
      setprop("/engines/engine[0]/running",0);
    }
});

setlistener("/controls/engines/average-rpm-right", func(rpm) {
    var rpm = rpm.getValue();
    if (rpm >= 500){
      setprop("/engines/engine[1]/mp-osi",20);
      setprop("/engines/engine[1]/running",1);
    }
    if (rpm < 500){
      setprop("/engines/engine[1]/mp-osi",0);
      setprop("/engines/engine[1]/running",1);
    }
    if (rpm < 100){
      setprop("/engines/engine[1]/mp-osi",0);
      setprop("/engines/engine[1]/running",0);
    }
});
