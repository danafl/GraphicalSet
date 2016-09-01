//
//  SetGameCardDeck.m
//  set
//
//  Created by Dana Fleischer on 28/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "SetGameCardDeck.h"
#import "SetGameCard.h"

@implementation SetGameCardDeck

- (instancetype) init
{
  self = [super init];
  if(self) {
    for(NSString *symbol in [SetGameCard validSymbol]) {
      for(NSString *number in [SetGameCard validNumber]) {
        for(NSString *shading in [SetGameCard validShading]) {
          for(NSString *color in [SetGameCard validColor]) {
            SetGameCard *card = [[SetGameCard alloc] init];
            card.symbol = symbol;
            card.number = number;
            card.shading = shading;
            card.color = color;
            [self addCard:card];
          }
        }


      }
    }
  }
  return self;
}

@end
