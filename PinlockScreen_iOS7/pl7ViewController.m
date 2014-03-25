//
//  pl7ViewController.m
//  PinlockScreen_iOS7
//
//  Created by Annica Burns on 3/22/14.
//  Copyright (c) 2014 BroadPocket. All rights reserved.
//

#import "pl7ViewController.h"
#import "pl7DataEntryFeedbackView.h"
#import "pl7AppDelegate.h"


//NSString const *pinLockCancelButtonLabel_Cancel = @"Cancel";
//NSString const *pinLockCancelButtonLabel_Delete = @"Delete";
#define pinLockCancelButtonLabel_Cancel @"Cancel"
#define pinLockCancelButtonLabel_Delete @"Delete"
CGFloat const pinLockDotRadius = 6.0f;
NSInteger const pinLockPinLength = 4;

@interface pl7ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTextFeedback;
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UIView *viewVisualFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnLogOut;

@property (strong, nonatomic) NSMutableString *numbersEntered;
@property (strong, nonatomic) NSMutableArray *feedbackViewData;

@property (assign, nonatomic) NSInteger shakeCount;
@property (assign, nonatomic) NSInteger shakeDirection;
@property (strong, nonatomic) NSString *firstPin;
@property (strong, nonatomic) NSString *currentInstructions;
@property (strong, nonatomic) NSString *currentTextFeedback;
@property (assign, nonatomic) BOOL cancelButtonShowsDelete;

- (IBAction)btnCancelDeleteButtonClicked:(id)sender;
- (IBAction)btnLogOutButtonClicked:(id)sender;
- (IBAction)numberButtonClicked:(id)sender;

@end

@implementation pl7ViewController

#pragma mark - Lifecycle and other Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetViewTo:self.pinEntryState];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Methods and Accessors
- (void)updateInstructions {
    switch (self.pinEntryState) {
        case stateConfirmPin:
            self.lblInstructions.text = @"Verify PIN";
            break;
        case stateUnlockApp:
            self.lblInstructions.text = @"Enter PIN";
            break;
        default:
            //stateSetPIN
            self.lblInstructions.text = @"Create PIN";
            break;
    }
}
- (void)updateTextFeedback {
    self.lblTextFeedback.text = nil;
}
- (void)updateCancelDeleteButton {
    self.cancelButtonShowsDelete = [self.numbersEntered length] > 0;
    if (self.cancelButtonShowsDelete) {
        [self.btnCancelDelete setTitle:pinLockCancelButtonLabel_Delete forState:UIControlStateNormal];
    } else {
        [self.btnCancelDelete setTitle:pinLockCancelButtonLabel_Cancel forState:UIControlStateNormal];
    }
    [self.btnCancelDelete setEnabled:YES];
}
- (void)updateLogoutButton {
//    NSLog(@"%s pinEntryState: %ld",__PRETTY_FUNCTION__,self.pinEntryState);
    switch (self.pinEntryState) {
        case stateUnlockApp:
            [self.btnLogOut setTitle:@"Log Out" forState:UIControlStateNormal];
            [self.btnLogOut setEnabled:YES];
            break;
        default:
            //stateSetPIN
            [self.btnLogOut setTitle:nil forState:UIControlStateNormal];
            [self.btnLogOut setEnabled:NO];
            break;
    }
}
- (void)addDots {
    if([self isViewLoaded]) {
        [[self.viewVisualFeedback subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.feedbackViewData removeAllObjects];
        self.feedbackViewData = [NSMutableArray array];
        
        CGFloat neededWidth =  pinLockPinLength * pinLockDotRadius;
        CGFloat shiftBetweenDots = (self.viewVisualFeedback.frame.size.width - neededWidth )/(pinLockPinLength +2);
        CGFloat indent = 1.5* shiftBetweenDots;
        if(shiftBetweenDots > pinLockDotRadius * 5.0f) {
            shiftBetweenDots = pinLockDotRadius * 5.0f;
            indent = (self.viewVisualFeedback.frame.size.width - neededWidth  - shiftBetweenDots *(pinLockPinLength > 1 ? pinLockPinLength - 1 : 0))/2;
        }
        for(int i=0; i < pinLockPinLength; i++) {
            pl7DataEntryFeedbackView * dot = [pl7DataEntryFeedbackView feedbackDot:pinLockDotRadius];
            CGRect dotFrame = dot.frame;
            dotFrame.origin.x = indent + i * pinLockDotRadius + i*shiftBetweenDots;
            dotFrame.origin.y = (CGRectGetHeight(self.viewVisualFeedback.frame) - pinLockDotRadius)/2.0f;
            dot.frame = dotFrame;
            [self.viewVisualFeedback addSubview:dot];
            [self.feedbackViewData addObject:dot];
        }
    }
}
- (void)fillDot:(NSInteger)symbolIndex {
    if(symbolIndex>=self.feedbackViewData.count) {
        return;
    }
    pl7DataEntryFeedbackView *dot = [self.feedbackViewData objectAtIndex:symbolIndex];
    dot.backgroundColor = [UIColor whiteColor];
}
- (void)emptyDot:(NSInteger)symbolIndex {
    if (symbolIndex>=self.feedbackViewData.count) {
        return;
    }
    pl7DataEntryFeedbackView *dot = [self.feedbackViewData objectAtIndex:symbolIndex];
    dot.backgroundColor = [UIColor clearColor];
}
- (void)shakeDots {
    [UIView animateWithDuration:0.03 animations:^ {
         self.viewVisualFeedback.transform = CGAffineTransformMakeTranslation(5*self.shakeDirection, 0);
     } completion:^(BOOL finished) {
         if(self.shakeCount >= 15) {
             self.viewVisualFeedback.transform = CGAffineTransformIdentity;
             return;
         }
         self.shakeCount++;
         self.shakeDirection = self.shakeDirection * -1;
         [self shakeDots];
     }];
}
- (BOOL)checkGlobalPin:(NSString *)pin {
    pl7AppDelegate *appDel = (pl7AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [pin isEqualToString:appDel.pin];
}
- (void)setGlobalPIN:(NSString *)newPIN {
    pl7AppDelegate *appDel = (pl7AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setPin:newPIN];
}
- (void)resetViewTo:(statePinEntry)state  {
    [self setPinEntryState:state];
    [self addDots];
    [self updateInstructions];
    [self updateTextFeedback];
    [self updateCancelDeleteButton];
    [self updateLogoutButton];
    self.numbersEntered = [NSMutableString new];
}
- (void)dismissView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Event Handlers
- (IBAction)btnCancelDeleteButtonClicked:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        if ([btn.titleLabel.text isEqualToString:pinLockCancelButtonLabel_Cancel]) {
//            NSLog(@"%s btnCancelClicked",__PRETTY_FUNCTION__);
            [self dismissView];
        }
        else if ([btn.titleLabel.text isEqualToString:pinLockCancelButtonLabel_Delete]) {
            if ([self.numbersEntered length] > 0) {
                [self emptyDot:self.numbersEntered.length - 1];
                NSRange range = NSMakeRange(self.numbersEntered.length - 1, 1);
                [self.numbersEntered deleteCharactersInRange:range];
                [self updateCancelDeleteButton];
            }
        }
    }
}
- (IBAction)btnLogOutButtonClicked:(id)sender {
    //clear out PIN and dismiss app
    [self setGlobalPIN:nil];
    [self dismissView];
    
}
- (IBAction)numberButtonClicked:(id)sender {
    [self.numbersEntered appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
    [self fillDot:self.numbersEntered.length - 1];
    [self updateCancelDeleteButton];
    if (self.pinEntryState == stateUnlockApp) {
        [self.btnCancelDelete setEnabled:NO];
        [self.btnLogOut setEnabled:NO];
        if (pinLockPinLength == self.numbersEntered.length && [self checkGlobalPin:self.numbersEntered]) {

            self.lblTextFeedback.text = @"Correct PIN";
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissView];
            });
        }
        else if (pinLockPinLength == self.numbersEntered.length) {
            self.shakeDirection = 1;
            self.shakeCount = 0;
            [self shakeDots];
            [self resetViewTo:stateUnlockApp];
        }
    } else {
        if (pinLockPinLength == self.numbersEntered.length){
            if (self.pinEntryState == stateSetPin) {
                // reset and prepare for confirmation stage
                self.firstPin  = self.numbersEntered;
                [self resetViewTo:stateConfirmPin];
            } else {
                if ([self.firstPin isEqualToString:self.numbersEntered]) {
                    // this pin matches the original >> set pin property of app delegate, dismiss view
                    [self setGlobalPIN:self.firstPin];
                    [self dismissView];
                } else {
                    // this pin does NOT match the original >> shake the visual feedback view, reset the state to the EnterPIN state, update text feedback with the error
                    self.shakeDirection = 1;
                    self.shakeCount = 0;
                    [self shakeDots];
                    [self resetViewTo:stateSetPin];
                    self.lblTextFeedback.text = @"PIN's did not match";
                }
            }
        }
    }
    
}

@end
