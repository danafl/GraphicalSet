//
//  PlayingCardDeck.m
//  MasterCard
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "PlayingCardDeck.h"


@implementation PlayingCardDeck
- (instancetype) init
{
  self = [super init];
  if(self)
  {
    for(NSString *suit in [PlayingCard validSuits] )
    {
      for(NSUInteger rank =1; rank <= [PlayingCard maxRank]; rank++)
      {
        PlayingCard *card = [[PlayingCard alloc] init];
        card.suit = suit;
        card.rank = rank;
        [self addCard:card];
      }
    }
  }
  return self;
}

@end
