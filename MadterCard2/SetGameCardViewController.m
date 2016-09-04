//
//  SetGameCardViewController.m
//  set
//
//  Created by Dana Fleischer on 28/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "SetGameCardViewController.h"
#import "SetGameCardDeck.h"
#import "SetGameCard.h"
#import "SetCardView.h"


@implementation SetGameCardViewController
static const int PLAY_MODE_TYPE = 3;
static const int NUMBER_OF_CARDS = 12;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
}

- (Deck *)createDeck {
  return [[SetGameCardDeck alloc] init];
}

- (NSInteger)getPlayMode {
  return PLAY_MODE_TYPE;
}

/*
-(void)updateCardButtonTitle:(UIButton *)cardButton byCard:(Card *)card {
  [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
}

- (NSAttributedString *)titleForCard:(Card *)card {
  SetGameCard *setCard = (SetGameCard *)card;
  NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                      initWithString:
                                      [setCard.number stringByAppendingString:setCard.symbol]];
  UIColor *foregroundColor = [self getForegroundColorAttribute:setCard];
  UIColor *backgroundColor = [self getBackgroundColorAttribute:setCard];
  [title addAttributes:@{NSForegroundColorAttributeName: foregroundColor,
                         NSBackgroundColorAttributeName:backgroundColor}
                 range:NSMakeRange(0,[title length])];

  return title;
}

- (UIImage *)backgroundImageCard:(Card *)card {
  return [UIImage imageNamed:@"carfront"];
}

- (UIColor *)getForegroundColorAttribute:(SetGameCard *)card {
  UIColor *color = nil;
  if([card.color isEqualToString:@"red"]) {
    color = [UIColor redColor];
  } else if ([card.color isEqualToString:@"green"]) {
    color = [UIColor greenColor];
  } else {
    color = [UIColor purpleColor];
  }
  return color;
}

- (UIColor *)getBackgroundColorAttribute:(SetGameCard *)card {
  UIColor *color = nil;
  if([card.shading isEqualToString:@"solid"]) {
    color = [UIColor yellowColor];
  } else if ([card.shading isEqualToString:@"striped"]) {
    color = [UIColor blueColor];
  } else {
    color = [UIColor orangeColor];
  }
  return color;
}

//cahnged it's name to updateCardViewAfterSelected!!!! need to implement here
- (void) markCard:(UIButton *)cardButton ifSelected:(Card *)card{
  if(card.isChosen)
  {
    [cardButton setBackgroundColor:[UIColor yellowColor]];
  } else {
    [cardButton setBackgroundColor:nil];
  }

}
*/

- (void)initializeCardsViews:(NSMutableArray *)cardsViews accordingToCards:(NSMutableArray *)cards{
  for(SetGameCard *card in cards) {
    CGRect newCardFrame = CGRectZero;
    SetCardView *newCardView = [[SetCardView alloc] initWithFrame:newCardFrame];
    newCardView.symbol = card.symbol;
    newCardView.shading = card.shading;
    newCardView.color = card.color;
    newCardView.number = card.number;
    [cardsViews addObject:newCardView];
  }
}

- (NSUInteger)getNumberOfCards {
  return NUMBER_OF_CARDS;
}

- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
  [(SetCardView *)cardView setSelected:card.isChosen];
}

- (void)updateCardViewAsMatched:(UIView *)cardView {
  cardView.userInteractionEnabled = NO;
  cardView.alpha = 0.3f;
}

@end
