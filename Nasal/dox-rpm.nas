# ==================================================
# Averaged RPM of all engines locked in (clutch on)
# ==================================================
var calculateRPM = func(engines){
    var n = 0;
    var rpm = 0;
    foreach(var e; engines) {
        rpm += getprop("/engines/engine["~e~"]/rpm");
        n += 1;
    }
    if (rpm == 0) rpm = 0.1;
    var averageRPM = rpm/n;
    return averageRPM;
}

var updateRPM = func{
    #left engines
    var pilotenginesL = [];
    var list = [0,2,4,6,8,10];
    foreach(var n; list) {
        var clutch = getprop("/engines/engine["~n~"]/clutch");
        var running = getprop("/engines/engine["~n~"]/running");
        if(clutch == 1 and running == 1){
          append(pilotenginesL, n);
        }
    }
    #right engines
    var pilotenginesR = [];
    var list2 = [1,3,5,7,9,11];
    foreach(var r; list2) {
        var clutch2 = getprop("/engines/engine["~r~"]/clutch");
        var running2 = getprop("/engines/engine["~r~"]/running");
        if(clutch2 == 1 and running2 == 1){
          append(pilotenginesR, r);
        }
    }

    var rpmL = calculateRPM(pilotenginesL);
    var rpmR = calculateRPM(pilotenginesR);

    setprop("controls/engines/average-rpm-left", rpmL);
    setprop("controls/engines/average-rpm-right", rpmR);

    # For MP with sim/multiplay/generic/int for the copilot
    # You find the int[10] and [11] in the dox-set.xml
    setprop("sim/multiplay/generic/int[10]", int(rpmL));
    setprop("sim/multiplay/generic/int[11]", int(rpmR));

    # RPM updated 8 times / sec
    settimer(updateRPM, .125);
}

updateRPM();

