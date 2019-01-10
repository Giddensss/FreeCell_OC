# Free Cell(Objective-C)
An Objective-C version of classical Windows game Free Cell, using MVC pattern. The game design is following the original Free Cell. This version contains the function of cheking whether the player is entering a dead-end, and function of auto finish.

![screenshot](https://github.com/Giddensss/image-folder/blob/master/free_cell_screenshot.png)

# Key Code
## /supports/const.h

All constants are defined in this head file, including some macros. The values of some constants should be fixed since we fixed the window size. Don't change those constants with fixed valus(which have been labeled), unless the layout of the main window in storyboard is changed. Otherwise, the UI may look strange.


## /listener+callbacks/UIListener.h

The protocal of main UI listener. It is implemented by main UI view(ViewController.h). A listener object is defined in game model(Game.h): 
```objective-c
@property id<UIListener> myUIListener
```
The listener is used for communication between game model(Game.m) and main UI(ViewController.m). Model will call the appropriate method to update the UI.

## /view/ViewController.m

The implementation of main view controller. 

## /model/Game.h

The game model which deals with the game logic, including card movement, card collecting, game status checking, and auto finish.

```objective-c
-(void) autoFinish
```
This is the public API for excuting auto finish. It will be called from main menu. This method will call an internal auto finish method
```objective-c
-(void) autoFinish:(BOOL) isForce
```
passing a **YES** as the parameter.
