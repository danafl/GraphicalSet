//
//  CardView.m
//  set
//
//  Created by Dana Fleischer on 04/09/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (void)setFaceUp:(BOOL)faceUp
{
  if(faceUp != _faceUp) {
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                      _faceUp = faceUp;
                    }
                    completion:^(BOOL finished) {}];
    [self setNeedsDisplay];
  }

}



@end
