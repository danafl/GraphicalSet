//
//  PlayingCard.h
//  MasterCard
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property(nonatomic) NSInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;

@end
