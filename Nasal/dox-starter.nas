# ==================================================
# Start up engine by engine
# ==================================================
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
####################  Controll of the Engines  ###################################

var switchEngine = func(eng){
  var status = getprop("engines/engine["~eng~"]/running");
  var clutch = getprop("engines/engine["~eng~"]/clutch");
  var as = getprop("/instrumentation/airspeed-indicator/true-speed-kt");
  var mix = getprop("engines/engine["~eng~"]/mixture");
  var r1 = getprop("engines/engine["~eng~"]/rpm");
  var magnetos = props.globals.getNode("/controls/engines/engine["~eng~"]/magnetos", 1);
  var cutoff = props.globals.getNode("/controls/engines/engine["~eng~"]/cutoff", 1);
  var mpinhg = props.globals.getNode("/controls/engines/engine["~eng~"]/mp-inhg", 1);
  var mposi = props.globals.getNode("/controls/engines/engine["~eng~"]/mp-osi", 1);
  var starter = props.globals.getNode("/controls/engines/engine["~eng~"]/starter", 1);
  var cranking = props.globals.getNode("/controls/engines/engine["~eng~"]/cranking", 1);

  # engine is running
  # speed is not above 35kt (80 km/h)
  # speed is higher than 35kt, clutch must be unlocked
  if (status == 1){
    if (as < 35){
        r1 = 10;
        mix = 0.0;
        magnetos.setValue(0);
        mpinhg.setValue(0);
        mposi.setValue(0);
        cutoff.setValue(1);
        magnetos.setAttribute("writable", 0);
        cutoff.setAttribute("writable", 0);
        mpinhg.setAttribute("writable", 0);
        mposi.setAttribute("writable", 0);
        screen.log.write("WARNING: One Engine -> off", 1.0, 0.1, 0.1)
    }elsif (clutch == 0){
        r1 = 10;
        mix = 0.0;
        magnetos.setValue(0);
        mpinhg.setValue(0);
        mposi.setValue(0);
        cutoff.setValue(1);
        magnetos.setAttribute("writable", 0);
        cutoff.setAttribute("writable", 0);
        mpinhg.setAttribute("writable", 0);
        mposi.setAttribute("writable", 0);
        screen.log.write("WARNING: One Engine -> off", 1.0, 0.1, 0.1);
    }else{
        screen.log.write("Unlock this engine first - you are to faster than 80 km/h!", 1.0, 0.7, 0.0);
    }
  # or start up this engine
  }else {
    r1 = 300;
    mix = 1.0;

    starter.setValue(1);
    cranking.setValue(1);

    magnetos.setAttribute("writable", 1);
    cutoff.setAttribute("writable", 1);
    mpinhg.setAttribute("writable", 1);
    mposi.setAttribute("writable", 1);
    magnetos.setValue(1);
    cutoff.setValue(0);
  }
  setprop("engines/engine["~eng~"]/rpm", r1);
  setprop("engines/engine["~eng~"]/mixture", mix);
  # switch starter of if engine is running
  if (status == 1 ){
    starter.setValue(0);
    cranking.setValue(0);
  }
}

###############  Use for keybord startup with s ###################################
var startEngines = func{

  var r0 = getprop("engines/engine[0]/running");
  var r1 = getprop("engines/engine[1]/running");
  var r2 = getprop("engines/engine[2]/running");
  var r3 = getprop("engines/engine[3]/running");
  var r4 = getprop("engines/engine[4]/running");
  var r5 = getprop("engines/engine[5]/running");
  var r6 = getprop("engines/engine[6]/running");
  var r7 = getprop("engines/engine[7]/running");
  var r8 = getprop("engines/engine[8]/running");
  var r9 = getprop("engines/engine[9]/running");  
  var r10 = getprop("engines/engine[10]/running");
  var r11 = getprop("engines/engine[11]/running");

  if(!r4) {
    switchEngine(4);
    return
  }else{
    setprop("/controls/engines/engine[4]/starter", 0);
    setprop("/controls/engines/engine[4]/cranking", 0);
  }
  if(!r5) {
    switchEngine(5);
  }else{
    setprop("/controls/engines/engine[5]/starter", 0);
    setprop("/controls/engines/engine[5]/cranking", 0);
  }
  if(!r10) {
    switchEngine(10);
    return
  }else{
    setprop("/controls/engines/engine[10]/starter", 0);
    setprop("/controls/engines/engine[10]/cranking", 0);
  }
  if(!r11) {
    switchEngine(11);
    return
  }else{
    setprop("/controls/engines/engine[11]/starter", 0);
    setprop("/controls/engines/engine[11]/cranking", 0);
  }
  if(!r2) {
    switchEngine(2);
    return
  }else{
    setprop("/controls/engines/engine[2]/starter", 0);
    setprop("/controls/engines/engine[2]/cranking", 0);
  }
  if(!r3) {
    switchEngine(3);
    return
  }else{
    setprop("/controls/engines/engine[3]/starter", 0);
    setprop("/controls/engines/engine[3]/cranking", 0);
  }
  if(!r8) {
    switchEngine(8);
  }else{
    setprop("/controls/engines/engine[8]/starter", 0);
    setprop("/controls/engines/engine[8]/cranking", 0);
  }
  if(!r9) {
    switchEngine(9);
    return
  }else{
    setprop("/controls/engines/engine[9]/starter", 0);
    setprop("/controls/engines/engine[9]/cranking", 0);
  }
  if(!r0) {
    switchEngine(0);
    return
  }else{
    setprop("/controls/engines/engine[0]/starter", 0);
    setprop("/controls/engines/engine[0]/cranking", 0);
  }
  if(!r1) {
    switchEngine(1);
    return
  }else{
    setprop("/controls/engines/engine[1]/starter", 0);
    setprop("/controls/engines/engine[1]/cranking", 0);
  }
  if(!r6) {
    switchEngine(6);
    return
  }else{
    setprop("/controls/engines/engine[6]/starter", 0);
    setprop("/controls/engines/engine[6]/cranking", 0);
  }
  if(!r7) {
    switchEngine(7);
    return
  }else{
    setprop("/controls/engines/engine[7]/starter", 0);
    setprop("/controls/engines/engine[7]/cranking", 0);
  }
}

###############  use for keybord cutoff with S ###################################
var stopEngines = func{

  var r0 = getprop("engines/engine[0]/running");
  var r1 = getprop("engines/engine[1]/running");
  var r2 = getprop("engines/engine[2]/running");
  var r3 = getprop("engines/engine[3]/running");
  var r4 = getprop("engines/engine[4]/running");
  var r5 = getprop("engines/engine[5]/running");
  var r6 = getprop("engines/engine[6]/running");
  var r7 = getprop("engines/engine[7]/running");
  var r8 = getprop("engines/engine[8]/running");
  var r9 = getprop("engines/engine[9]/running");  
  var r10 = getprop("engines/engine[10]/running");
  var r11 = getprop("engines/engine[11]/running");

  if(r7) {
    switchEngine(7);
    return
  }
  if(r6) {
    switchEngine(6);
  }
  if(r1) {
    switchEngine(1);
    return
  }
  if(r0) {
    switchEngine(0);
    return
  }
  if(r9) {
    switchEngine(9);
    return
  }
  if(r8) {
    switchEngine(8);
    return
  }
  if(r3) {
    switchEngine(3);
    return
  }
  if(r2) {
    switchEngine(2);
    return
  }
  if(r11) {
    switchEngine(11);
    return
  }
  if(r10) {
    switchEngine(10);
    return
  }
  if(r5) {
    switchEngine(5);
    return
  }
  if(r4) {
    switchEngine(4);
    return
  }
}
