# ==================================================
#          AFN2 is working on VOR-DME               
# ==================================================

var afn2Direction = func{
  var state =  props.globals.getNode("/instrumentation/nav/dme-in-range", 1);
  
  if (state.getValue() == 1){

    var th = getprop("/orientation/heading-magnetic-deg") or 0;
    var navh = getprop("/instrumentation/nav/heading-deg") or 0;
    var dis = getprop("/instrumentation/nav/nav-distance") or 0;
    var gs = getprop("/instrumentation/nav/gs-in-range");
    var gsDis = getprop("/instrumentation/nav/gs-distance") or 0;
    var gearAglM = getprop("/position/gear-agl-m") or 0;

    # Heading correction
    var rotDiff = navh - th;
    if (rotDiff > 180){
      rotDiff = -(360 - rotDiff);
    }

    # Calculate the distance to the VOR-DME Beacon
    var disTerr = dis - gearAglM;
    if (disTerr < 100 and gs == 0){
      setprop("/instrumentation/afn2/markeron",1);
      setprop("/sim/multiplay/generic/int[13]",1);
    }else{
      setprop("/instrumentation/afn2/markeron",0);
      setprop("/sim/multiplay/generic/int[13]",0);
    }

    # If the target is an ILS Beacon take the gs altitude
    if(gs == 1){
      disTerr = gsDis - gearAglM;
      var middle = getprop("/instrumentation/marker-beacon/middle");
      if(middle == 1){
        setprop("/instrumentation/afn2/markeron",1);
        setprop("/sim/multiplay/generic/int[13]",1);
      }else{
        setprop("/instrumentation/afn2/markeron",0);
        setprop("/sim/multiplay/generic/int[13]",0);
      }
    }

    #screen.log.write("True Heading: "~rotDiff, 1.0, 0.7, 0.0);
    setprop("/instrumentation/afn2/heading-correction",rotDiff);
    setprop("/instrumentation/afn2/distance",disTerr);
    setprop("/sim/multiplay/generic/float[4]",rotDiff);
    setprop("/sim/multiplay/generic/float[5]",disTerr);
  
  }else{
    setprop("/instrumentation/afn2/heading-correction",0);
    setprop("/instrumentation/afn2/distance",0);
    setprop("/sim/multiplay/generic/float[4]",0);
    setprop("/sim/multiplay/generic/float[5]",0);
  }

  settimer(afn2Direction, 0);

};


#fire it up
afn2Direction();
