//
//  ViewController.m
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//


#import "ViewController.h"
#import "Grid.h"
#import "CardView.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) Grid *gameGrid;
@property (strong, nonatomic) NSMutableArray *cardsViews;
@property (nonatomic) BOOL gameStarted;
@property (strong, nonatomic) CardView *deckControlView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIAttachmentBehavior *attachment;


@end


@implementation ViewController

static const float ASPECT_RATIO = 0.6;
static const int MAX_CARD_HEIGHT = 100;


- (UIDynamicAnimator *)animator {
  if(!_animator) {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
  }
  return _animator;
}

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

- (CardView *)deckControlView {
  if(!_deckControlView) {
    _deckControlView = [self createDeckControlView];
  }
  return _deckControlView;
}

- (void)viewDidLoad {
  [self makeGameViewTransparent];
  [self createCardViewsOfCards:self.game.cards];
  [self addGesturesToDeckControlView];
  [self addPinchGestureToGame];

}

-(void)viewDidLayoutSubviews {
  if(self.animationNumber == 0 && (!([self.gameView.subviews containsObject:self.deckControlView]))) {
    [self changeGridAccordingToLayout];
    [self updateCardViewsLocations];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if(!self.gameStarted) {
    [self putCardViewsInDeck:self.cardsViews];
    [self animateMoveingCardViewsToPalcesOnGrid];
    self.gameStarted = YES;
  }

}

- (void)addGesturesToDeckControlView {
  [self.deckControlView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(panDeckControlView:)]];
  [self.deckControlView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapDeckControlView:)]];
}

- (void)addPinchGestureToGame {
  [self.gameView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(pinch:)]];
}

- (void)makeGameViewTransparent {
  self.gameView.opaque = NO;
  self.gameView.backgroundColor = [UIColor clearColor];
}

- (NSMutableArray *)createCardViewsOfCards:(NSMutableArray *)cards {
  NSMutableArray *newCardViews = [self initializeCardsViewsOfCards:cards];
  [self.cardsViews addObjectsFromArray:newCardViews];
  for(UIView *cardView in newCardViews){
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                    initWithTarget:self	action:@selector(tapCardView:)]];
    [self.gameView addSubview:cardView];
  }
  return newCardViews;
}

- (void)changeGridAccordingToLayout {
  self.gameGrid.minimumNumberOfCells = [self.cardsViews count];
  self.gameGrid.size = CGSizeMake(self.gameView.frame.size.width,
                                  self.gameView.frame.size.height - MAX_CARD_HEIGHT) ;
  self.gameGrid.cellAspectRatio = ASPECT_RATIO;
  self.gameGrid.maxCellHeight = MAX_CARD_HEIGHT;
}

- (void)updateCardViewsLocations {
  for(int cardIndex = 0; cardIndex < [self.cardsViews count]; cardIndex++) {
    UIView *cardView = [self.cardsViews objectAtIndex:cardIndex];
    int cardRow = cardIndex / self.gameGrid.columnCount;
    int cardColumn = cardIndex % self.gameGrid.columnCount;
    cardView.frame = [self.gameGrid frameOfCellAtRow:cardRow inColumn:cardColumn];
  }
}

- (void)putCardViewsInDeck:(NSMutableArray *)cardViews {
  for(UIView *cardView in cardViews) {
    cardView.frame = [self getDeckFrame];
  }
}

- (CGRect)getDeckFrame {
  int cardXPosition = (self.gameView.bounds.size.width - self.gameGrid.cellSize.width)/ 2;
  int cardYPosition = (self.gameView.bounds.size.height - self.gameGrid.cellSize.height);
  CGRect newCardFrame = CGRectMake(cardXPosition, cardYPosition,
                                   self.gameGrid.cellSize.width,
                                   self.gameGrid.cellSize.height);
  return newCardFrame;
}

- (void)animateMoveingCardViewsToPalcesOnGrid {
  __weak ViewController *weakSelf = self;
  [UIView animateWithDuration:1.0
                        delay:0.3
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [weakSelf updateCardViewsLocations];
                   }
                   completion:^(BOOL finished){[weakSelf updateCardViewsFaceAfterDealing];}];

}

- (void)animateMoveingSubclassSubviews {
  __weak ViewController *weakSelf = self;
  [UIView animateWithDuration:1.0
                        delay:0.3
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [weakSelf moveSubclassSubviewsToStartingLocations];
                   }
                   completion:^(BOOL finished){}];

}

- (void)animateMoveingCardViewsToDeck {
  self.animationNumber++;
  __weak ViewController *weakSelf = self;
  [UIView animateWithDuration:1.0
                        delay:0.3
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     for(UIView *view in self.gameView.subviews){
                       view.frame = [weakSelf getDeckFrame];
                     }
                   }
                   completion:^(BOOL finished){
                     if (finished){
                       self.deckControlView.frame = [self getDeckFrame];
                       [self.gameView addSubview:self.deckControlView];
                       self.animationNumber--;
                     }
                     }];

}


- (CardMatchingGame *)game{
  if(!_game)
  {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self getStartingNumberOfCards]
                                              usingDeck:[self createDeck]
                                           withPlayMode:[self getPlayMode]];
  }
  return _game;
}

- (Deck *)createDeck
{
  return nil;
}

- (NSUInteger)getStartingNumberOfCards {
  return 0;
}

- (NSUInteger)getMaxNumberOfCards {
  return 0;
}

- (IBAction)tapCardView:(UITapGestureRecognizer *)gesture{
  NSInteger cardIndex = [self.cardsViews indexOfObject:gesture.view];
  [self.game chooseCardAtIndex:cardIndex];
  [self updateUI];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateEnded) {
    [self animateMoveingCardViewsToDeck];
  }
}

- (IBAction)panDeckControlView:(UIPanGestureRecognizer *)gesture {
  CGPoint gesturePoint = [gesture locationInView:self.gameView];
  if(gesture.state == UIGestureRecognizerStateBegan) {
    [self attachDeckControlViewToPoint:gesturePoint];
  } else if (gesture.state == UIGestureRecognizerStateChanged) {
    self.attachment.anchorPoint = gesturePoint;
    [self attachCardsToDeckControlView];
  } else if (gesture.state == UIGestureRecognizerStateEnded) {
    [self.animator removeBehavior:self.attachment];

  }
}

- (void)attachDeckControlViewToPoint:(CGPoint)anchorPoint {
  self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.deckControlView attachedToAnchor:anchorPoint];
  [self.animator addBehavior:self.attachment];
}

- (void)attachCardsToDeckControlView {
  for(UIView *view in self.gameView.subviews) {
    view.frame = self.deckControlView.frame;
  }
}

- (IBAction)tapDeckControlView:(UITapGestureRecognizer *)gesture {
  [self animateMoveingCardViewsToPalcesOnGrid];
  [self animateMoveingSubclassSubviews];
  [self.deckControlView removeFromSuperview];
}


- (IBAction)touchResetButton:(UIButton *)sender {
  self.game = [[CardMatchingGame alloc] initWithCardCount:[self getStartingNumberOfCards]
                                                usingDeck:[self createDeck]
                                             withPlayMode:[self getPlayMode]];
  for(UIView *cardView in [self.cardsViews mutableCopy]) {
    [self removeCardViewFromBoard:cardView];
  }
  [self createCardViewsOfCards:self.game.cards];
  self.gameGrid.minimumNumberOfCells = [self.cardsViews count];
  [self putCardViewsInDeck:self.cardsViews];
  [self animateMoveingCardViewsToPalcesOnGrid];
  [self resetSubclassSubviews];
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

- (CardView *)createDeckControlView {
  return nil;
}

- (NSMutableArray *)initializeCardsViewsOfCards:(NSMutableArray *)cards{
  return nil;
}

- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card{
}

- (void)updateCardViewAsMatched:(UIView *)cardView {
}

- (void)removeCardViewFromBoard:(UIView *)cardView {
    [cardView removeFromSuperview];
    [self.cardsViews removeObject:cardView];
}

- (NSInteger)getPlayMode
{
  return 0;
}

- (CGFloat)getGameViewWidth {
  return self.gameView.bounds.size.width;
}

- (CGFloat)getGameViewHeight {
  return self.gameView.bounds.size.width;
}

- (void)updateCardViewsFaceAfterDealing {
  if([self isCardFaceUpAfterDealing]) {
    for(CardView *cardView in self.cardsViews) {
      cardView.faceUp = YES;
    }
  }
}

- (BOOL)isCardFaceUpAfterDealing {
  return NO;
}

- (void)addSubviewToGameView:(UIView *)view {
  [self.gameView addSubview:view];
}

- (void)addCards:(NSUInteger)numberOfCards {
  NSMutableArray *newCards = [self.game addCardsToGame:numberOfCards];
  NSMutableArray *newCardsViews = [self createCardViewsOfCards:newCards];
  self.gameGrid.minimumNumberOfCells = [self.cardsViews count];
  [self putCardViewsInDeck:newCardsViews];
  [self animateMoveingCardViewsToPalcesOnGrid];
}

- (void)resetSubclassSubviews {
  [self makeSubclassSubviewsReappear];
  [self moveSubclassSubviewsToStartingLocations];
}

- (void)makeSubclassSubviewsReappear {

}

- (void)moveSubclassSubviewsToStartingLocations {

}



@end

