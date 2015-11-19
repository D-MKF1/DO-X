# ==================================================
# Before pilot can start with throttle,
# the clutch must set in the engineer panel
# ==================================================

# Click function for the Clutch settings
var clickClutch = func(n){
    var e = props.globals.getNode("/engines/engine["~n~"]/clutch", 1);
var text = {
    0: "Outer larboard front engine",
    1: "Outer starboard front engine",
    2: "Middle larboard front engine",
    3: "Middle starboard front engine",
    4: "Inner larboard front engine",
    5: "Inner starboard front engine",
    6: "Outer larboard back engine",
    7: "Outer starboard back engine",
    8: "Middle larboard back engine",
    9: "Middle starboard back engine",
    10: "Inner larboard back engine",
    11: "Inner starboard back engine"
};

    if(e.getValue()){
      e.setValue(0);
      screen.log.write(text[n]~ "-> unlocked", 1.0, 0.7, 0.0);
    }else{
      e.setValue(1);
      screen.log.write(text[n]~ "-> locked", 0.0, 0.7, 0.0);
    }
}

#############  scrollfunction for whatever you want increase or decrease ####################
var scrollGear = func(scale,path){
    var val=getprop(path) + (scale);
    if(val >1.0) val = 1.0;
    if(val < 0.0) val = 0.0;
    setprop(path,val);
}

# Les moteurs numérotés vue de dessus 
#
#              avant
#              |   | 
#  gauche 0 2  4   5 3 1 droite
#         6 8 10  11 9 7
#              |   |
#               \ /
#             arrière
#                |

#############  Throttle Control for the keybord PgUp and PgDown by pilot ###############
#................ called from the /Nasal/dox-keyboard.xml

# all engines
var throttleControl = func{

  # Initialization for the count of locked engines (so they are under pilots control)
  # the unlocked engines are under engineer control
    var pilotengines = [];
    var sel = props.globals.getNode("/sim/input/selected", 1);
    var engs = props.globals.getNode("/controls/engines").getChildren("engine");

    foreach(var e; engs) {
        var index = e.getIndex();
        var s = sel.getChild("engine", index, 1);
        if(s.getType() == "NONE") s.setBoolValue(1);
        var clutch = getprop("/engines/engine["~index~"]/clutch");
        #print("Clutch" ~index~": "~clutch);
        if(clutch == 1){
          append(pilotengines, { index: index, controls: e, selected: s });
        }
    }
    controlRootThrottle(arg[0],arg[1],pilotengines,"all");
}

####################### only the locked engines on the left (larboard) #####################
#.called from the /Nasal/dox-keyboard.xml and the /Interior/Panel/Throttle/throttle.xml

#left engines
var throttleControlL = func{
    var pilotenginesL = [];
    var list = [0,2,4,6,8,10];

    foreach(var n; list) {
        var sel = props.globals.getNode("/sim/input/selected", 1);
        var e = props.globals.getNode("/controls/engines/engine["~n~"]");
        var s = sel.getChild("engine", n, 1);
        if(s.getType() == "NONE") s.setBoolValue(1);
        var clutch = getprop("/engines/engine["~n~"]/clutch");
        #print("Larboard-Clutch" ~n~": "~clutch);
        if(clutch == 1){
          append(pilotenginesL, {index: n, controls: e, selected: s});
        }
    }
    controlRootThrottle(arg[0],arg[1],pilotenginesL,"left");
}

####################### only the locked engines on the right (starboard) #####################
#.called from the /Nasal/dox-keyboard.xml and the /Interior/Panel/Throttle/throttle.xml

#right engines
var throttleControlR = func{
    var pilotenginesR = [];
    var list = [1,3,5,7,9,11];

    foreach(var n; list) {
        var sel = props.globals.getNode("/sim/input/selected", 1);
        var e = props.globals.getNode("/controls/engines/engine["~n~"]");
        var s = sel.getChild("engine", n, 1);
        if(s.getType() == "NONE") s.setBoolValue(1);
        var clutch = getprop("/engines/engine["~n~"]/clutch");
        #print("Starboard-Clutch" ~n~": "~clutch);
        if(clutch == 1){
          append(pilotenginesR, {index: n, controls: e, selected: s});
        }
    }
    controlRootThrottle(arg[0],arg[1],pilotenginesR,"right");
}


###################   Main functionn for the throttle increase decrease ######################
#.......................called only from the functions in this file
var controlRootThrottle = func{
  # arg[0] is the throttle increment
  # arg[1] is the auto-throttle target speed increment
  # both comming from the dox-keyboard.xml an go through the function before.
    var thropiL = props.globals.getNode("/controls/engines/throttle-pilot-left", 1);
    var thropiR = props.globals.getNode("/controls/engines/throttle-pilot-right", 1);
    
    # only for control on terminal
    #var t1 = getprop("/controls/engines/throttle-pilot-left");
    #var t2 = getprop("/controls/engines/throttle-pilot-right");
    #print("Hello from "~arg[3]~" L: "~t1~" R: "~t2~" before increase/decrease");

    var auto = props.globals.getNode("/autopilot/locks/speed", 1);
    var passive = props.globals.getNode("/autopilot/locks/passive-mode", 1);
    if (!auto.getValue() or passive.getValue()) {
        foreach(var e; arg[2]) {
            if(e.selected.getValue()) {
                var node = e.controls.getNode("throttle", 1);
                var val = node.getValue() + arg[0];
                node.setValue(val < -1.0 ? -1.0 : val > 1.0 ? 1.0 : val);
            }
        }
        # increase or decrease the left or right throttle gear for pilot
        if(arg[3] == "all"){
          scrollGear(arg[0],"controls/engines/throttle-pilot-left");
          scrollGear(arg[0],"controls/engines/throttle-pilot-right");
        }
        if(arg[3] == "left"){
          scrollGear(arg[0],"controls/engines/throttle-pilot-left");
        }
        if(arg[3] == "right"){
          scrollGear(arg[0],"controls/engines/throttle-pilot-right");
        }
    } else {
        var node = props.globals.getNode("/autopilot/settings/target-speed-kt", 1);
        if (node.getValue() == nil) {
            node.setValue(0.0);
        }
        node.setValue(node.getValue() + arg[1]);
        if (node.getValue() < 0.0) {
            node.setValue(0.0);
        }
    }

    # only for control on terminal
    #var t3 = getprop("/controls/engines/throttle-pilot-left");
    #var t4 = getprop("/controls/engines/throttle-pilot-right");
    #print("Hello from "~arg[3]~" L: "~t3~" R: "~t4~" after increase/decrease");
}

#############  scrollfunction for the single throttle gears at engineer panel ###############

var engControl = func(scale,eng,ctrl) {
    var clutch = getprop("/engines/engine["~eng~"]/clutch");
    if (clutch == 0) {
      scrollGear(scale,"controls/engines/engine["~eng~"]/"~ctrl);
    }
}


############# Argh... it is nessecary to  hear, what the engines done, ######################
############ cause the pilots Throttle Gear find not the right position ####################
# We build a new joystick function
# Joystick axis handlers (use cmdarg).  Shouldn't be called from
# other contexts.  A non-null argument reverses the axis direction.
var doxAxisHandler = func(pre, post) {
    func(invert = 0) {
      var engines = [];
      var sel = props.globals.getNode("/sim/input/selected", 1);
      var engs = props.globals.getNode("/controls/engines").getChildren("engine");
      foreach(var e; engs) {
          var index = e.getIndex();
          var s = sel.getChild("engine", index, 1);
          if(s.getType() == "NONE") s.setBoolValue(1);
          var clutch = getprop("/engines/engine["~index~"]/clutch");
          if(clutch == 1){
            append(engines, { index: index, controls: e, selected: s });
          }
      }
      var val = cmdarg().getNode("setting").getValue();
      if(invert) val = -val;
      foreach(var e; engines){
          if(e.selected.getValue())
              setprop(pre ~ e.index ~ post, (1 - val) / 2);
      }
    setprop("controls/engines/throttle-pilot-left",((1 - val) / 2));
    setprop("controls/engines/throttle-pilot-right",((1 - val) / 2));
    }
}

# And now, overwrite the original joystick function
controls.throttleAxis = doxAxisHandler("/controls/engines/engine[", "]/throttle");








