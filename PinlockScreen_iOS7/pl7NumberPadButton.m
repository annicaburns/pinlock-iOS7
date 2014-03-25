//
//  pl7NumberPadButton.m
//  PinlockScreen_iOS7
//
//  Created by Annica Burns on 3/22/14.
//  Copyright (c) 2014 BroadPocket. All rights reserved.
//

#import "pl7NumberPadButton.h"

@implementation pl7NumberPadButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.layer setCornerRadius:CGRectGetHeight(rect)/2.0];
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    self.layer.borderWidth = 1.5f;
}
- (void)setHighlighted:(BOOL)highlighted {
    if(highlighted) {
        self.layer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    }
    else {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;

    }
}

@end
