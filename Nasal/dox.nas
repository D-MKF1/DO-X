# DO X 
#
#	set up menu dialogs
#
# stolen from Gary Neely aka 'Buckaroo's Lockheed 1049h


DoxMain = {};

DoxMain.new = func {
  obj = { parents : [DoxMain]
        };
  obj.init();
  return obj;
}

# global variables in dox namespace, for call by XML
DoxMain.instantiate = func {
   globals.dox.menusystem = Menu.new();
}

DoxMain.init = func {
   me.instantiate();
}

DOXL = setlistener("/sim/signals/fdm-initialized", func {
  thedox = DoxMain.new();
  removelistener(DOXL);
  }
);


# Change view to 
var changeView = func (n){
  var actualView = props.globals.getNode("/sim/current-view/view-number", 1);
  if (actualView.getValue() == n){
    actualView.setValue(0);
  }else{
    actualView.setValue(n);
  }
}

# help on water control the rudder with turn thruster
setlistener("/controls/flight/rudder", func(r) {
    var r = r.getValue() or 0;
    var a = getprop("/position/altitude-agl-ft") or 0;
    if (a < 15) setprop("/controls/special/towel", r * 0.8);
}, 0, 1);

props.globals.initNode("/instrumentation/doors/window/position-norm",0,"DOUBLE");

var FrontWindow = func {
   var frontwindow = getprop("/instrumentation/doors/window/position-norm") or 0;
   if (frontwindow < 1){
      interpolate("/instrumentation/doors/window/position-norm", 1  , 1);
   }else{
      interpolate("/instrumentation/doors/window/position-norm", 0  , 1);
   }
}

