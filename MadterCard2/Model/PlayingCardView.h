//
//  PlayingCardView.h
//  set
//
//  Created by Dana Fleischer on 31/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"


@interface PlayingCardView : CardView
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;



@end


