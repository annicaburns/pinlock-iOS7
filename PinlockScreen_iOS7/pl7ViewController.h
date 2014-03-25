//
//  pl7ViewController.h
//  PinlockScreen_iOS7
//
//  Created by Annica Burns on 3/22/14.
//  Copyright (c) 2014 BroadPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, statePinEntry) {
    stateSetPin   = 0,  //default
    stateConfirmPin = 1,
    stateUnlockApp = 2
};

@interface pl7ViewController : UIViewController

@property (assign, nonatomic) statePinEntry pinEntryState;

@end
