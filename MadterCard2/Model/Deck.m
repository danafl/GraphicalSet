//
//  Deck.m
//  MasterCard
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (nonatomic,strong) NSMutableArray *cards;
@end

@implementation Deck

- (NSMutableArray *)cards
{
  if(!_cards)
  {
    _cards = [[NSMutableArray alloc] init];

  }
  return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
  if(atTop)
  {
    [self.cards insertObject:card atIndex:0];
  }else{
    [self.cards addObject:card];
  }
}

-(void)addCard:(Card *)card
{
  [self.cards addObject:card];
}

-(Card *)drawRandomCard
{
  Card *randomCard = nil;
  if([self.cards count])
  {
    unsigned index = arc4random() % [self.cards count];
    randomCard = self.cards[index];
    //remove the card from the deck
    [self.cards removeObjectAtIndex:index];
  }


  return randomCard;


}

@end
