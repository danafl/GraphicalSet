//
//  SetCardView.h
//  set
//
//  Created by Dana Fleischer on 04/09/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *number;
@property (nonatomic) BOOL selected;


@end
