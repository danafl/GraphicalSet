//
//  SetGameCard.h
//  set
//
//  Created by Dana Fleischer on 28/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "Card.h"

@interface SetGameCard : Card
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *number;

+(NSArray *)validSymbol;
+(NSArray *)validNumber;
+(NSArray *)validShading;
+(NSArray *)validColor;


@end
