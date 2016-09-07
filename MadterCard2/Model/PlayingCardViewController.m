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
static const int STARTING_NUMBER_OF_CARDS = 50;

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc]init];
}

- (NSInteger)getPlayMode
{
  return PLAY_MODE_TYPE;
}

- (NSMutableArray *)initializeCardsViewsOfCards:(NSMutableArray *)cards{
  NSMutableArray *cardsViews = [[NSMutableArray alloc] init];
  for(PlayingCard *card in cards) {
    CGRect newCardFrame = CGRectZero;
    PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:newCardFrame];
    newCardView.suit = card.suit;
    newCardView.rank = card.rank;
    [cardsViews addObject:newCardView];
  }
  return cardsViews;
}

- (NSUInteger)getStartingNumberOfCards {
  return STARTING_NUMBER_OF_CARDS;
}


- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
  [(PlayingCardView *)cardView setFaceUp:card.isChosen];
}

- (void)updateCardViewAsMatched:(UIView *)cardView {
  cardView.userInteractionEnabled = NO;
  cardView.alpha = 0.3f;
}

- (BOOL)isCardFaceUpAfterDealing {
  return NO;
}

- (CardView *)createDeckControlView {
  CGRect newCardFrame = CGRectZero;
  PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:newCardFrame];
  return newCardView;
}


@end
