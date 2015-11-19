###############################################################################
##
##   Dornier DO J II - f - Bos (Wal)
##   by Marc Kraus :: Lake of Constance Hangar
##
##   Copyright (C) 2012 - 2014  Marc Kraus  (info(at)marc-kraus.de)
##
###############################################################################
# =============================================================================
#                     Radio Direction Finder RDF settings            
# =============================================================================
var debug_rdf = 0;

var rotation_degree = "/instrumentation/rdf/rotation-deg";
var carrier_name = "";
var carrier_distance = 9999999.9;

var mymod = func(x,y){
  var res = x/y;
  var resInt = int(res);
  var resSmall = y * resInt;
  return x - resSmall;
}

var indiBearingDeg = func(a,b){
  var diff = b-a;
  var newAngle = 0.0;
  if(diff > 180)
  {
      newAngle = mymod((diff + 180),360) - 180;
  }
  elsif(diff < -180)
  {
      newAngle = mymod((diff - 180),360) + 180;
  }
  else
  {
      newAngle = mymod(diff, 360);
  }
  return (360 - newAngle);
};

# Switch on/off
var clickRdfSwitch = func{
    var rdf = props.globals.getNode("/instrumentation/rdf/power-on", 1);
    var nv = props.globals.getNode("/instrumentation/nav/power-btn", 1);
    var av = props.globals.getNode("/instrumentation/adf/power-btn", 1);
    if(rdf.getValue()){
      rdf.setValue(0);
      nv.setValue(0);
      av.setValue(0);
    }else{
      rdf.setValue(1);
    }
}

setlistener("/instrumentation/rdf/power-on", func(state) {
    var state = state.getValue();
    var adf = props.globals.getNode("/instrumentation/adf/power-btn", 1);
    var nav = props.globals.getNode("/instrumentation/nav/power-btn", 1);
    if(state == 0){
      adf.setValue(0);
      nav.setValue(1);  # we need it always for correct afn2 working
    }else{
      adf.setValue(1);
      nav.setValue(1);
    }
});

############### Set always the right position of the RDF Aerial #################
var rdfAerialPos = func{
	if(debug_rdf) print ("rdfAerialPos laeuft");
  var state = getprop("/instrumentation/rdf/power-on");
  var freqSel = getprop("/instrumentation/rdf/frequency-select-knob"); # 0 = NDB, 1 = VOR or ILS
  # Schwabenland fake frequency is selected (195.20 Mhz)
  var selected_freq = getprop("/instrumentation/nav/frequencies/selected-mhz") or 0;

  var adfState = getprop("/instrumentation/adf/power-btn");
  var navState = getprop("/instrumentation/nav/power-btn");
  var adfRange = getprop("/instrumentation/adf/in-range");
  var navRange = getprop("/instrumentation/nav/in-range");

  if (state == 1){
    var rdfDeg = getprop(rotation_degree)*360; # rdfDeg is a float
    # freqSel 0 = NDB, 1 = VOR or ILS
    if(freqSel == 1){
      if((selected_freq > 195.19 and selected_freq < 195.21) or 
         (selected_freq > 197.09 and selected_freq < 197.11)){
        var aircraftDirDeg = getprop("/orientation/heading-magnetic-deg");
        var mp_cat = props.globals.getNode("/ai/models").getChildren("carrier");
        var tt = size(mp_cat);
        setprop("/instrumentation/rdf/cat-ship-in-range", 0);
        carrier_name = "";
        carrier_distance = 9999999.9;

        for(var i = 0; i < tt; i += 1) {

            if (mp_cat[i].getNode("name") != nil) var shipsName = mp_cat[i].getNode("name").getValue();

            if ((shipsName == "Schwabenland") and (selected_freq > 195.19 and selected_freq < 195.21)){
				      var ac_pos = geo.aircraft_position();
						  var schwabenland_pos = geo.Coord.new();
						  schwabenland_pos.set_latlon( getprop("/ai/models/carrier["~i~"]/position/latitude-deg"), 
                                           getprop("/ai/models/carrier["~i~"]/position/longitude-deg"));
						  var self_distance  = ac_pos.distance_to(schwabenland_pos);
              var dirDeg = ac_pos.course_to(schwabenland_pos);
              #screen.log.write(shipsName~" is "~self_distance~" out on heading "~dirDeg~" degree", 1.0, 0.1, 0.1);
              var indiDeg = indiBearingDeg(dirDeg,aircraftDirDeg);
              # set the range for the Schwabenland to 500 km
              if(self_distance < 500000){
                setprop("/instrumentation/rdf/cat-ship-in-range", 1);
                carrier_name = shipsName;
                carrier_distance = self_distance;
              }
            }
            if ((shipsName == "Westfalen") and (selected_freq > 197.09 and selected_freq < 197.11)){
				      var ac_pos = geo.aircraft_position();
						  var westfalen_pos = geo.Coord.new();
						  westfalen_pos.set_latlon( getprop("/ai/models/carrier["~i~"]/position/latitude-deg"), 
                                           getprop("/ai/models/carrier["~i~"]/position/longitude-deg"));
						  var self_distance  = ac_pos.distance_to(westfalen_pos);
              var dirDeg = ac_pos.course_to(westfalen_pos);
              #screen.log.write(shipsName~" is "~self_distance~" out on heading "~dirDeg~" degree", 1.0, 0.1, 0.1);
              var indiDeg = indiBearingDeg(dirDeg,aircraftDirDeg);
              # set the range for the Westfalen to 500 km
              if(self_distance < 500000){
                setprop("/instrumentation/rdf/cat-ship-in-range", 1);
                carrier_name = shipsName;
                carrier_distance = self_distance;
              }
            }
        }
        setprop("/instrumentation/nav/volume", 0);
        var vol = props.globals.getNode("/instrumentation/nav/volume", 1);
        setprop("/instrumentation/adf/volume-norm", 0);        

      }else{
        var aircraftDirDeg = getprop("/orientation/heading-magnetic-deg");
        var dirDeg = getprop("/instrumentation/nav/heading-deg");
        var indiDeg = indiBearingDeg(dirDeg,aircraftDirDeg);
        setprop("/instrumentation/nav/volume", 0);
        var vol = props.globals.getNode("/instrumentation/nav/volume", 1);
        setprop("/instrumentation/adf/volume-norm", 0);
        setprop("/instrumentation/rdf/cat-ship-in-range", 0);
        #screen.log.write("IndiDeg aus VOR" ~indiDeg, 1.0, 0.1, 0.1);  #for debug_rdf only
      }
    }else{
      var indiDeg = getprop("/instrumentation/adf/indicated-bearing-deg");
      setprop("/instrumentation/nav/volume", 0);
      setprop("/instrumentation/adf/volume-norm", 0);
      var vol = props.globals.getNode("/instrumentation/adf/volume-norm", 1);
      #screen.log.write("IndiDeg aus NDB" ~indiDeg, 1.0, 0.1, 0.1);  #for debug_rdf only
    }

    # calculate the difference between manuel aerial setting / rdf and 
    # automatic direction deg from FG / adf to set the volume of beacon morse code
    var rotDiff = abs(indiDeg - rdfDeg);
    if (rotDiff > 180){
      rotDiff = abs(360 - rotDiff);
    }

    # set volume in headset
    if(rotDiff < 91){
      # 1 - 0.2 = 0.8 steps, rotdiff from 90 degree to 0
      var volSet = 1 - 0.8/90 * rotDiff;
      vol.setValue(volSet);
    }else{
      vol.setValue(0.2);
    }

    # print(vol.getValue());
    # screen.log.write("Ergebnis:" ~rotDiff, 1.0, 0.1, 0.1);  #for debug_rdf only

  }elsif(adfState == 1 and adfRange == 1){
    var rdfDeg = getprop("/instrumentation/adf/indicated-bearing-deg");
  }else{
    var rdfDeg = 90;
  }

  setprop(rotation_degree, (rdfDeg/360));
  settimer(func{ rdfAerialPos(); }, 0);
};

#fire it up
rdfAerialPos();


# if state of RDF change, set the Aerial on 0 deg
setlistener("/instrumentation/rdf/power-on", func(pwon) {
      if (pwon.getBoolValue()){
        interpolate(rotation_degree, 0, 1.5);
      }else{
        interpolate(rotation_degree,-90, 2);
      }
});

############### Show the course correction deg ###################################
var rdfNavInfo = func {
    var rdfDeg = getprop(rotation_degree)*360;
    var freqSel = getprop("/instrumentation/rdf/frequency-select-knob"); # 0 = NDB, 1 = VOR or ILS
    # Schwabenland fake frequency is selected (195.20 Mhz)
    # Westfalen fake frequency is selected (197.10 Mhz)
    var selected_freq = getprop("/instrumentation/nav/frequencies/selected-mhz") or 0;
    var text2 = "";
    if(freqSel == 1){
      if((selected_freq > 195.19 and selected_freq < 195.21) or 
         (selected_freq > 197.09 and selected_freq < 197.11)){
        var controlRange = getprop("/instrumentation/rdf/cat-ship-in-range");
        var text = carrier_name;
        var c_d_km_int = int(carrier_distance/100);
        var c_d_km     = int(c_d_km_int*10)/100;          
        var c_d_nm_int = int(carrier_distance*0.005399568034557236);
        var c_d_nm     = int(c_d_nm_int*10)/100;
        var text2 = "Distance "~c_d_km~"km/ "~c_d_nm~"nm";
      }else{
        var controlRange = getprop("/instrumentation/nav/in-range");
        var text = getprop("/instrumentation/nav/nav-id");
        var dmeInRange = getprop("/instrumentation/dme/in-range");
        if(dmeInRange == 1){
          var dmeDistance = int(getprop("/instrumentation/dme/indicated-distance-nm"));
          text2 = "Distance "~dmeDistance~"nm";
        }
      }
    }else{
      var controlRange = getprop("/instrumentation/adf/in-range");
      var text = getprop("/instrumentation/adf/ident");
    }


    # there is a signal in range
    if (controlRange) {

      # build the heading correction message for the pilot
      mp_msg = "";

      var newRdfDeg = rdfDeg;
      if (rdfDeg > 180){
        newRdfDeg = abs(360 - rdfDeg);
      }
      headCorrection = int(newRdfDeg);

      if (rdfDeg > 180.5 and rdfDeg < 359.5){
        screen.log.write(text~" -> "~headCorrection~" degree to larboard", 1.0, 0.1, 0.1);
        mp_msg = text~" -> "~headCorrection~" degree to larboard";
      }elsif(rdfDeg > 0.5 and rdfDeg < 179.5){
        screen.log.write(text~" -> "~headCorrection~" degree to starboard", 1.0, 0.1, 0.1);
        mp_msg = text~" -> "~headCorrection~" degree to starboard";
      }elsif(rdfDeg >= 179.5 and rdfDeg <= 180.5){
        screen.log.write(text~" on 180 degree", 1.0, 0.1, 0.1);
        mp_msg = text~" on 180 degree";
      }elsif(rdfDeg >= 359.5 or rdfDeg <= 0.5){
        screen.log.write("Hold this heading. Beacon - "~text~" is straight ahead.", 1.0, 0.1, 0.1);
        mp_msg = "Hold this heading. Beacon - "~text~" is straight ahead.";
      }
      
      if(text2 != ""){
        screen.log.write(text2, 1.0, 0.1, 0.1);
        mp_msg = mp_msg~ " " ~text2;
      }

    }else{
        screen.log.write("Nonviable calculation. Please first find a viable signal in range.", 1.0, 0.1, 0.1);
        mp_msg = "";
    }
    setprop("/instrumentation/rdf/message-to-pilot",mp_msg);
}
############### Delete the Heading Correction Messages ###################################
var del_msg_from_navigator = func{
  setprop("/instrumentation/rdf/message-to-pilot","");
}
