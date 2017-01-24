# DO X 
#
# Fire up the menu dialog system
#
# stolen from Gary Neely aka 'Buckaroo's Lockheed 1049h

Menu = {};

Menu.new = func {
  obj = { parents : [Menu],
          engineer : nil
        };
  obj.init();
  return obj;
};

Menu.init = func {
  me.engineer = gui.Dialog.new("/sim/gui/dialogs/dox/engineer/dialog","Aircraft/DO-X/Dialogs/dox-engineer-menu.xml");
}
