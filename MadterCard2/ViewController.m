//
//  ViewController.m
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//


#import "ViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "CardView.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Grid *gameGrid;
@property (strong, nonatomic) NSMutableArray *cardsViews;
@property (nonatomic) BOOL gameStarted;


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
  [self createCardViews];

}

-(void)viewDidLayoutSubviews {
  [self changeGridAccordingToLayout];
  [self updateCardViewsLocations];

}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if(!self.gameStarted) {
    [self putCardViewsInDeck];
    [self dealCards];
  }

}

- (void)makeGameViewTransparent {
  self.gameView.opaque = NO;
  self.gameView.backgroundColor = [UIColor clearColor];
}

- (void)createCardViews {
  [self initializeCardsViews:self.cardsViews accordingToCards:self.game.cards];
  for(UIView *cardView in self.cardsViews){
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                    initWithTarget:self	action:@selector(tapCardView:)]];
    [self.gameView addSubview:cardView];
    
  }
}

- (void)changeGridAccordingToLayout {
  self.gameGrid.minimumNumberOfCells = [self getNumberOfCards];
  self.gameGrid.size = CGSizeMake(self.gameView.frame.size.width,
                                  self.gameView.frame.size.height - MAX_CARD_HEIGHT) ;
  self.gameGrid.cellAspectRatio = ASPECT_RATIO;
  self.gameGrid.maxCellHeight = MAX_CARD_HEIGHT;
}

-(void)updateCardViewsLocations {
  for(int cardIndex = 0; cardIndex < [self.cardsViews count]; cardIndex++) {
    UIView *cardView = [self.cardsViews objectAtIndex:cardIndex];
    int cardRow = cardIndex / self.gameGrid.columnCount;
    int cardColumn = cardIndex % self.gameGrid.columnCount;
    cardView.frame = [self.gameGrid frameOfCellAtRow:cardRow inColumn:cardColumn];
  }
}

- (void)putCardViewsInDeck {
  int cardXPosition = (self.gameView.bounds.size.width - self.gameGrid.cellSize.width)/ 2;
  int cardYPosition = (self.gameView.bounds.size.height - self.gameGrid.cellSize.height);
  for(UIView *cardView in self.cardsViews) {
    CGRect newCardFrame = CGRectMake(cardXPosition, cardYPosition,
                                     self.gameGrid.cellSize.width,
                                     self.gameGrid.cellSize.height);
    cardView.frame = newCardFrame;
  }
}

- (void)dealCards {
  __weak ViewController *weakSelf = self;
  [UIView animateWithDuration:1.0
                        delay:1.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [weakSelf updateCardViewsLocations];
                   }
                   completion:^(BOOL finished){}];
}


- (CardMatchingGame *)game{
  if(!_game)
  {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self getNumberOfCards]
                                              usingDeck:[self createDeck]
                                           withPlayMode:[self getPlayMode]];
  }
  return _game;
}


- (Deck *)createDeck
{
  return nil;
}

- (NSUInteger)getNumberOfCards {
  return 0;
}

- (IBAction)tapCardView:(UITapGestureRecognizer *)gesture{
  if(!self.gameStarted) {
    self.gameStarted = YES;
  }
  NSInteger cardIndex = [self.cardsViews indexOfObject:gesture.view];
  [self.game chooseCardAtIndex:cardIndex];
  [self updateUI];
}


- (IBAction)touchResetButton:(UIButton *)sender {
  self.game = [[CardMatchingGame alloc] initWithCardCount:[self getNumberOfCards]
                                                usingDeck:[self createDeck]
                                             withPlayMode:[self getPlayMode]];
  [self removeCardViewsFromBoard:[self.cardsViews mutableCopy]];
  [self createCardViews];
  [self putCardViewsInDeck];
  [self dealCards];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}


- (void)updateUI
{
  for(UIView *cardView in self.cardsViews) {
    NSInteger cardIndex = [self.cardsViews indexOfObject:cardView];
    Card *card = [self.game cardAtIndex:cardIndex];
    [self updateCardViewAsSelectedOrNot:cardView accordingToCard:card];
    if(card.isMatched) {
      [self updateCardViewAsMatched:(UIView *)cardView];
    }
  }
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];

}

- (void)initializeCardsViews:(NSMutableArray *)cardsViews accordingToCards:(NSMutableArray *)cards{
}

- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
}

- (void)updateCardViewAsMatched:(UIView *)cardView {
}

- (void)removeCardViewsFromBoard:(NSMutableArray *)cardViews {
  for(UIView *cardView in cardViews) {
    [cardView removeFromSuperview];
    [self.cardsViews removeObject:cardView];
  }
}

- (NSInteger)getPlayMode
{
  return 0;
}




@end

