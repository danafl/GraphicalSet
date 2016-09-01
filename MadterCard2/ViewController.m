//
//  ViewController.m
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//


#import "ViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "Grid.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardsViews;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Grid *gameGrid;


@end


@implementation ViewController

static const float ASPECT_RATIO = 0.6;
static const int MAX_CARD_HEIGHT = 100;


-(NSMutableArray *)cardsViews {
  if(!_cardsViews) {
    _cardsViews = [[NSMutableArray alloc] init];
  }
  return _cardsViews;
}

-(Grid *)gameGrid {
  if(!_gameGrid) {
    _gameGrid = [[Grid alloc] init];
  }
  return _gameGrid;
}

- (void)viewDidLoad {
  [self makeGameViewTransparent];
  [self initializeCardsViews];
}

-(void)viewDidLayoutSubviews {
  [self changeGridAccordingToLayout];
  [self putCardViewsInDeck];

}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self dealCards];
}

- (void)changeGridAccordingToLayout {
  self.gameGrid.minimumNumberOfCells = [self getNumerOfCards];
  self.gameGrid.size = CGSizeMake(self.gameView.frame.size.width,
                                  self.gameView.frame.size.height - MAX_CARD_HEIGHT) ;
  self.gameGrid.cellAspectRatio = ASPECT_RATIO;
  self.gameGrid.maxCellHeight = MAX_CARD_HEIGHT;
}

- (void)putCardViewsInDeck {
  int cardXPosition = (self.gameView.bounds.size.width - self.gameGrid.cellSize.width)/ 2;
  int cardYPosition = (self.gameView.bounds.size.height - self.gameGrid.cellSize.height);


  for(PlayingCardView *cardView in self.cardsViews) {
    CGRect newCardFrame = CGRectMake(cardXPosition, cardYPosition,
                                     self.gameGrid.cellSize.width,
                                     self.gameGrid.cellSize.height);
    cardView.frame = newCardFrame;
    [self.gameView addSubview:cardView];
  }
}

- (void)dealCards {
  [UIView animateWithDuration:1.0
                        delay:1.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
    for(int cardIndex = 0; cardIndex < [self.cardsViews count]; cardIndex++) {
      PlayingCardView *cardView = [self.cardsViews objectAtIndex:cardIndex];
      int cardRow = cardIndex / self.gameGrid.columnCount;
      int cardColumn = cardIndex % self.gameGrid.columnCount;
      cardView.frame = [self.gameGrid frameOfCellAtRow:cardRow inColumn:cardColumn];
    }
  }
                   completion:^(BOOL finished){}];
  /*[UIView animateWithDuration:1.0 delay:1.0 animations:^{
    for(int cardIndex = 0; cardIndex < [self.cardsViews count]; cardIndex++) {
      PlayingCardView *cardView = [self.cardsViews objectAtIndex:cardIndex];
      int cardRow = cardIndex / self.gameGrid.columnCount;
      int cardColumn = cardIndex % self.gameGrid.columnCount;
      cardView.frame = [self.gameGrid frameOfCellAtRow:cardRow inColumn:cardColumn];
    }
  }];*/
}

- (void)makeGameViewTransparent {
  self.gameView.opaque = NO;
  self.gameView.backgroundColor = [UIColor clearColor];
}

- (void)initializeCardsViews{
  for(PlayingCard *card in self.game.cards) {
    CGRect newCardFrame = CGRectMake(0, 0, 40, 64);
    PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:newCardFrame];
    newCardView.suit = card.suit;
    newCardView.rank = card.rank;
    [self.cardsViews addObject:newCardView];
  }
}



- (CardMatchingGame *)game{
  if(!_game)
  {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self getNumerOfCards]
                                              usingDeck:[self createDeck]
                                           withPlayMode:[self getPlayMode]];

  }
  return _game;
}


- (Deck *)createDeck
{
  return nil;
}

//////////////////////////////////////////////////////////////////////////
-(NSUInteger)getNumerOfCards {
  return 50;
}

- (IBAction)touchCArdButton:(UIButton *)sender {
  NSInteger cardIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:cardIndex];
  [self updateUI];
}


- (IBAction)touchResetButton:(UIButton *)sender {
  self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                usingDeck:[self createDeck]
                                             withPlayMode:[self getPlayMode]];
  [self updateUI];
}


- (void)updateUI
{
  for(UIButton *cardButton in self.cardButtons)
  {
    NSInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardIndex];
    [self updateCardButtonTitle:cardButton byCard:card];
    [cardButton setBackgroundImage:[self backgroundImageCard:card] forState:UIControlStateNormal];
    [self markCard:cardButton ifSelected:card];
    cardButton.enabled = !card.isMatched;
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];

}

//abstract - used only in setCard
- (void) markCard:(UIButton *)cardButton ifSelected:(Card *)card {

}

//abstract
- (void)updateCardButtonTitle:(UIButton *)cardButton byCard:(Card *)card {

}

//abstract
- (UIImage *)backgroundImageCard:(Card *)card
{
  return nil;
}

//abstract
- (NSInteger)getPlayMode
{
  return 0;
}


@end

