# ==================================================
# Engines oil temperature IN and OUT
# Version totalement à refaire.... c'est temporaire
# Working version .... is temporary
# ==================================================

setlistener("/engines/engine[0]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[0]/oiltemp-degci", degci);
    setprop("/engines/engine[0]/oiltemp-degco", degco);
});

setlistener("/engines/engine[1]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[1]/oiltemp-degci", degci);
    setprop("/engines/engine[1]/oiltemp-degco", degco);
});

setlistener("/engines/engine[2]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[2]/oiltemp-degci", degci);
    setprop("/engines/engine[2]/oiltemp-degco", degco);
});

setlistener("/engines/engine[3]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[3]/oiltemp-degci", degci);
    setprop("/engines/engine[3]/oiltemp-degco", degco);
});

setlistener("/engines/engine[4]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[4]/oiltemp-degci", degci);
    setprop("/engines/engine[4]/oiltemp-degco", degco);
});

setlistener("/engines/engine[5]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[5]/oiltemp-degci", degci);
    setprop("/engines/engine[5]/oiltemp-degco", degco);
});

setlistener("/engines/engine[6]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[6]/oiltemp-degci", degci);
    setprop("/engines/engine[6]/oiltemp-degco", degco);
});

setlistener("/engines/engine[7]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[7]/oiltemp-degci", degci);
    setprop("/engines/engine[7]/oiltemp-degco", degco);
});

setlistener("/engines/engine[8]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[8]/oiltemp-degci", degci);
    setprop("/engines/engine[8]/oiltemp-degco", degco);
});

setlistener("/engines/engine[9]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[9]/oiltemp-degci", degci);
    setprop("/engines/engine[9]/oiltemp-degco", degco);
});

setlistener("/engines/engine[10]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[10]/oiltemp-degci", degci);
    setprop("/engines/engine[10]/oiltemp-degco", degco);
});

setlistener("/engines/engine[11]/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degco = (degf - 32) * (5 / 9);
    var degci = degco - (degco / 2);
    setprop("/engines/engine[11]/oiltemp-degci", degci);
    setprop("/engines/engine[11]/oiltemp-degco", degco);
});

