# ==================================================
# The Helpengine is the main-generator for the battery,
# also the lights and functions in this aircraft.
# ==================================================

#####################  scrollfunction for the lever ###########################

var helpEngControl = func(scale) {
  # scrollGear() is found in dox-clutch.nas
  scrollGear(scale,"controls/engines/helpengine-lever");

  # if the helpengine-lever is set on middle position. 
  # the generator work with max. power.
  var state_lever = getprop("controls/engines/helpengine-lever");
  if (state_lever < 0.5){
    scrollGear((scale * 2),"controls/lighting/brightness");
  }
}

