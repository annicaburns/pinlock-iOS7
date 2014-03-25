//
//  pl7InitialViewController.m
//  PinlockScreen_iOS7
//
//  Created by Annica Burns on 3/23/14.
//  Copyright (c) 2014 BroadPocket. All rights reserved.
//

#import "pl7InitialViewController.h"
#import "pl7ViewController.h"
#import "pl7AppDelegate.h"

@interface pl7InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblPin;

- (IBAction)btnCreatePINClicked:(id)sender;
- (IBAction)btnUnlockApplicationClicked:(id)sender;

@end

@implementation pl7InitialViewController

#pragma mark - Lifecycle and other Override Methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.lblPin.text = [NSString stringWithFormat:@"PIN: %@",[self getGlobalPIN]];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    pl7ViewController *destVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"createPIN"]) {
        [destVC setPinEntryState:stateSetPin];
    } else if ([segue.identifier isEqualToString:@"PINUnlock"]) {
        [destVC setPinEntryState:stateUnlockApp];
    }
}

#pragma mark - Custom Methods
- (NSString *)getGlobalPIN {
    pl7AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    NSString *gp = appDel.pin ? appDel.pin : @"EMPTY";
    return gp;
}

#pragma mark - Event Handlers
- (IBAction)btnCreatePINClicked:(id)sender {
    [self performSegueWithIdentifier:@"createPIN" sender:self];
}

- (IBAction)btnUnlockApplicationClicked:(id)sender {
    [self performSegueWithIdentifier:@"PINUnlock" sender:self];
}
@end
