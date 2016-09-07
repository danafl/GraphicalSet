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

@interface SetGameCardViewController()
@property (strong,nonatomic) SetCardView *addCardsVeiw;
@end


@implementation SetGameCardViewController
static const int PLAY_MODE_TYPE = 3;
static const int STARTING_NUMBER_OF_CARDS = 12;
static const int CARDS_TO_ADD = 3;


- (void)viewDidLoad {
  [self initializeAddCardsView];
  [super viewDidLoad];
  [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.addCardsVeiw.frame = [self getDeckFrame];
}

- (Deck *)createDeck {
  return [[SetGameCardDeck alloc] init];
}

- (NSInteger)getPlayMode {
  return PLAY_MODE_TYPE;
}

- (NSMutableArray *)initializeCardsViewsOfCards:(NSMutableArray *)cards{
  NSMutableArray *cardsViews = [[NSMutableArray alloc] init];
  for(SetGameCard *card in cards) {
    CGRect newCardFrame = CGRectZero;
    SetCardView *newCardView = [[SetCardView alloc] initWithFrame:newCardFrame];
    newCardView.symbol = card.symbol;
    newCardView.shading = card.shading;
    newCardView.color = card.color;
    newCardView.number = card.number;
    [cardsViews addObject:newCardView];
  }
  return cardsViews;
}

- (NSUInteger)getStartingNumberOfCards {
  return STARTING_NUMBER_OF_CARDS;
}



- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
  [(SetCardView *)cardView setSelected:card.isChosen];
}

- (void)updateCardViewAsMatched:(UIView *)cardView {
  self.animationNumber++;
  [UIView animateWithDuration:1.0
                   animations:^{
                     int x = [self getGameViewWidth]/2;
                     int y = [self getGameViewHeight];
                     cardView.center = CGPointMake(x, -y);
                   }
                   completion:^(BOOL finished) {
                     [self removeCardViewFromBoard:cardView];
                     self.animationNumber--;
                     [self animateMoveingCardViewsToPalcesOnGrid];
                   }];
}

- (BOOL)isCardFaceUpAfterDealing {
  return YES;
}

- (void)initializeAddCardsView {
  self.addCardsVeiw = [[SetCardView alloc] init];
  [self.addCardsVeiw addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                 initWithTarget:self	action:@selector(tapAddCardsView:)]];
  [self addSubviewToGameView:self.addCardsVeiw];
}

- (IBAction)tapAddCardsView:(UITapGestureRecognizer *)gesture{
  [self addCards:CARDS_TO_ADD];
  self.addCardsVeiw.frame = [self getDeckFrame];
  if([self.game deckFinished]) {
    self.addCardsVeiw.hidden = YES;
  }
}

- (void)makeSubclassSubviewsReappear {
  self.addCardsVeiw.hidden = NO;
}

- (void)moveSubclassSubviewsToStartingLocations {
  self.addCardsVeiw.frame = [self getDeckFrame];
}

- (CardView *)createDeckControlView {
  CGRect newCardFrame = CGRectZero;
  SetCardView *newCardView = [[SetCardView alloc] initWithFrame:newCardFrame];
  return newCardView;
}




@end
