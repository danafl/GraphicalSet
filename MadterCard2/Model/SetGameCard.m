//
//  SetGameCard.m
//  set
//
//  Created by Dana Fleischer on 28/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "SetGameCard.h"

@implementation SetGameCard

static const int FIRST = 0;
static const int SECOND = 1;
static const int THIRD = 2;
static const int MATCHING_SCORE = 4;

-(int)match:(NSArray *)otherCards
{
  int score = 0;
  SetGameCard *secondCard = otherCards[FIRST];
  SetGameCard *thirdCard = otherCards[SECOND];

  BOOL symbolSameOrDifferent = [self areAllPropertyValuesSameOrDifferent:@[self.symbol,
                                                                           secondCard.symbol,
                                                                           thirdCard.symbol]];
  BOOL numberSameOrDifferent = [self areAllPropertyValuesSameOrDifferent:@[self.number,
                                                                           secondCard.number,
                                                                           thirdCard.number]];
  BOOL shadingSameOrDifferent = [self areAllPropertyValuesSameOrDifferent:@[self.shading,
                                                                            secondCard.shading,
                                                                            thirdCard.shading]];
  BOOL colorSameOrDifferent = [self areAllPropertyValuesSameOrDifferent:@[self.color,
                                                                          secondCard.color,
                                                                          thirdCard.color]];

  if(symbolSameOrDifferent && numberSameOrDifferent && shadingSameOrDifferent &&
     colorSameOrDifferent) {
    score += MATCHING_SCORE;
  }
  return score;
}



- (BOOL)areAllPropertyValuesSameOrDifferent:(NSArray *)properties {
  NSString *firstProperty = properties[FIRST];
  NSString *secondProperty = properties[SECOND];
  NSString *thirdProperty = properties[THIRD];

  if([firstProperty isEqualToString:secondProperty] &&
     [secondProperty isEqualToString:thirdProperty]){
    return YES;
  } else if ((![firstProperty isEqualToString:secondProperty]) &&
             (![secondProperty isEqualToString:thirdProperty]) &&
             (![firstProperty isEqualToString:thirdProperty])) {
    return YES;
  } else {
    return NO;
  }

}

- (NSString *)contents {
  return [NSString stringWithFormat:@"%@ %@ %@ %@ ", self.symbol, self.shading,
          self.color,self.number];
  //return nil;
}


+ (NSArray *)validSymbol {
  return @[@"▲", @"◼︎",@"●"];
}

+ (NSArray *)validNumber {
  return @[@"1",@"2",@"3"];
}

+ (NSArray *)validShading {
  return @[@"solid", @"striped",@"open"];
}

+ (NSArray *)validColor {
  return @[@"red", @"green",@"purple"];
}



- (void)setSymbol:(NSString *)symbol {
  if([[SetGameCard validSymbol] containsObject:symbol]){
    _symbol = symbol;
  }
}

- (void)setNumber:(NSString *)number
{
  if([[SetGameCard validNumber] containsObject:number]){
    _number = number;
  }
}

- (void)setShading:(NSString *)shading {
  if([[SetGameCard validShading] containsObject:shading]){
    _shading = shading;
  }
}

- (void)setColor:(NSString *)color {
  if([[SetGameCard validColor] containsObject:color]){
    _color = color;
  }
}




@end
