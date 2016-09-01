//
//  PlayingCard.m
//  MasterCard
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
  int score = 0;

  for(PlayingCard *otherCard in otherCards)
  {
    score += [self compareCards:self withOther:otherCard];

  }

  //if there are 3 cards chosen, check the other- improve for n cards??
  if([otherCards count] == 2)
  {
    PlayingCard *first = otherCards[0];
    PlayingCard *second = otherCards[1];
    score += [self compareCards:first withOther:second];
  }
  return score;
}

- (NSInteger)compareCards:(PlayingCard *)first withOther:(PlayingCard *)second
{
  int score = 0;
  if([first.suit isEqualToString:second.suit])
  {
    score += 1;
  }else if(first.rank == second.rank){
    score += 4;
  }
  return score;

}

- (NSString *)contents
{
  NSArray *rankStrings = [PlayingCard rankStrings];
  return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
  return @[@"♠︎", @"♣︎",@"♥︎",@"♦︎"];
}

@synthesize suit = _suit;

- (NSString *)suit
{
  return _suit ? _suit:@"?";
}

- (void)setSuit:(NSString *)suit
{
  if([[PlayingCard validSuits] containsObject:suit])
  {
    _suit = suit;
  }
}




+ (NSArray *)rankStrings
{
  return @[@"?", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", @"10", @"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
  return [[PlayingCard rankStrings] count] -1;
}


@end