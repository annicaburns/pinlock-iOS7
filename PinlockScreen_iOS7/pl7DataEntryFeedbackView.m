//
//  pl7DataEntryFeedbackView.m
//  PinlockScreen_iOS7
//
//  Created by Annica Burns on 3/23/14.
//  Copyright (c) 2014 BroadPocket. All rights reserved.
//

#import "pl7DataEntryFeedbackView.h"

@implementation pl7DataEntryFeedbackView

+ (instancetype)feedbackDot:(CGFloat)radius {
    
    pl7DataEntryFeedbackView *dot = [[pl7DataEntryFeedbackView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, radius*2.0f, radius*2.0f)];
    dot.layer.cornerRadius = radius;
    dot.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    dot.layer.borderWidth = 2.0f;
    return dot;
    
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
