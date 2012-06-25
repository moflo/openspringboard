OpenSpringBoard
===============

UIKit based Spingboard clone, similar to Three20's TTLauncherView. This code is based on our Fieldforce app which was approved by Apple, so hopefully it's compliant with their terms, but YMMV.

"Sringboard" is the native iOS app launcher, OpenSpringBoard is a clone written in UIKit (4.1). Helpful if you're trying to create Facebook, LinkedIn or other "homescreen" based navigation apps. Includes custom UIView container for tool icon, text, badge. Animation of selecting (longpress), edit mode (dancing icons!) and changing the order of icons.

WIP: current focus is on animation and gathering feedback on the look & feel; next we'll refactor to a delegate protocol to set initial icon order, respond to reorder change requests, updating icon badge count, icon image and state settings (on/off/disabled?).


![OpenSpringBoard Example, Fieldforce](http://s3.amazonaws.com/cocoa_controls_production/ios_screens/103/full.png?1303687190)


To-Do
-----

- Refactor to a delegate protocol (done)
- Refactor OpenSpringBoard to a UIView (is this needed?)
- Remove NIB dependencies, create all views programmatically
- Add callback for button press (done)
- Add callback for reorder event
- Add delete capabilities
- Support horizontal and landscape modes
- Move from fixed to dynamic pages
- Fix bug when ordering icons across multiple pages
