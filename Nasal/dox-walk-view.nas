###############################################################################
##
## DO-X flying boat for FlightGear.
## Walk view configuration.
##
##  Stolen from
##  Copyright (C) 2008 - 2010  Anders Gidenstam  (anders(at)gidenstam.org)
##  and modify by Marc Kraus (info(at)marc-kraus.de)
##
###############################################################################

# Constraints
var flightdeckConstraint =
    walkview.makeUnionConstraint(
        [
         # [ smallest x, smallest y, smallest z] in the DO-X
         # [ largest x, largest y, largest z] in the DO-X
         # Right hand seat. Sit down when entering.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([  -11.4, -0.10, -0.4], 
                                                [  -11.7,  0.75, -0.4]),
              func {
                  #print("Sitzt!");
                  walkview.active_walker().set_eye_height(0.81);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Between the pilots.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -11.4, -0.10, -0.4], 
                                                [ -11.3,  0.20, -0.4]),
              func {
                  #print("Steht im Cockpit auf!");
                  walkview.active_walker().set_eye_height(1.1);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Frontdeck window.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -12.4, -0.10, -0.4], 
                                                [ -11.4,  0.10, -0.4]),
              func {
                  #print("Geht ans Frontfenster!");
                  walkview.active_walker().set_eye_height(0.95);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Passing door to Navigation Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -11.3, -0.10, -0.4], 
                                                [ -10.4,  0.15, -0.4]),
              func {
                  #print("Geht in den Navigationsraum!");
                  walkview.active_walker().set_eye_height(1.1);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the Navigation Room.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -10.4, -0.89, -0.4], 
                                                [  -9.6,  0.89, -0.4]),
              func {
                  #print("Bewegt sich im Navigationsraum!");
                  walkview.active_walker().set_eye_height(1.1);
              },
              func(x, y) {
                  # Nothing.
              }),
         # behind in the Navigation Room.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ - 9.6, -0.89, -0.4], 
                                                [  -8.3,  0.89, -0.4]),
              func {
                  #print("Bewegt sich im hinteren Teil des Navigationsraum!");
                  walkview.active_walker().set_eye_height(1.1);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Passing door to Engineer Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -8.3, -0.15, -0.4], 
                                                [ -7.7,  0.15, -0.4]),
              func {
                  #print("Geht in den Maschinenraum!");
                  walkview.active_walker().set_eye_height(-0.05);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the Engineers Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -7.7, -0.30, -0.4], 
                                                [ -5.7,  0.30, -0.4]),
              func {
                  #print("Bewegt sich im Maschinenraum!");
                  walkview.active_walker().set_eye_height(1.25);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Passing to Radio Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -5.7, -0.08, -0.4], 
                                                [ -5.0,  0.08, -0.4]),
              func {
                  #print("Geht in den Funkraum!");
                  walkview.active_walker().set_eye_height(-0.05);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the Radio Room looking out the little Bulleyes
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -5.0, -1.15, -0.4], 
                                                [ -4.5,  1.15, -0.4]),
              func {
                  #print("Schaut aus den kleinen Fenster im Funkraum!");
                  walkview.active_walker().set_eye_height(0.15);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the Radio Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -4.5, -0.60, -0.4], 
                                                [ -2.9,  0.34, -0.4]),
              func {
                  #print("Bewegt sich im Funkraum!");
                  walkview.active_walker().set_eye_height(0.75);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Passing to the HelpEngine Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -2.9, -0.08, -0.4], 
                                                [ -2.3,  0.08, -0.4]),
              func {
                  #print("Geht in den Funkraum!");
                  walkview.active_walker().set_eye_height(-0.05);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the HelpEngine Room
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -2.3, -0.45, -0.4], 
                                                [ -2.0,  0.29, -0.4]),
              func {
                  #print("Bewegt sich im Funkraum!");
                  walkview.active_walker().set_eye_height(0.75);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the HelpEngine Room at the last End
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -2.0, -0.25, -0.4], 
                                                [ -0.9,  0.80, -0.4]),
              func {
                  #print("Bewegt sich im Funkraum ganz hinten!");
                  walkview.active_walker().set_eye_height(0.40);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the HelpEngine Room at the absolut last End
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -0.9, -0.25, -0.4], 
                                                [ -0.6,  0.90, -0.4]),
              func {
                  #print("Bewegt sich im Funkraum ganz, ganz hinten!");
                  walkview.active_walker().set_eye_height(0.25);
              },
              func(x, y) {
                  # Nothing.
              }),
         # in the HelpEngine Room at the realy absolut last End
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -0.6, -0.90, -0.4], 
                                                [ -0.2,  0.90, -0.4]),
              func {
                  #print("Bewegt sich im Funkraum ganz, ganz hinten!");
                  walkview.active_walker().set_eye_height(0.10);
              },
              func(x, y) {
                  # Nothing.
              })
        ]);

# The view manager.
var copilot_walker = walkview.Walker.new("1th Officer", flightdeckConstraint);

