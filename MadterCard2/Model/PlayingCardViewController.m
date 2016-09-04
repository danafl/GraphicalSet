//
//  PlayingCardViewController.m
//  set
//
//  Created by Dana Fleischer on 28/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardViewController()

@end

@implementation PlayingCardViewController

static const int PLAY_MODE_TYPE = 2;
static const int NUMBER_OF_CARDS = 50;

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc]init];
}

- (NSInteger)getPlayMode
{
  return PLAY_MODE_TYPE;
}

-(void)updateCardButtonTitle:(UIButton *)cardButton byCard:(Card *)card{
  [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"carfront" : @"cardback"];
}

- (void)initializeCardsViews:(NSMutableArray *)cardsViews accordingToCards:(NSMutableArray *)cards{
  for(PlayingCard *card in cards) {
    CGRect newCardFrame = CGRectZero;
    PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:newCardFrame];
    newCardView.suit = card.suit;
    newCardView.rank = card.rank;
    [cardsViews addObject:newCardView];
  }
}

- (NSUInteger)getNumberOfCards {
  return NUMBER_OF_CARDS;
}

- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
  [(PlayingCardView *)cardView setFaceUp:card.isChosen];
}



@end
