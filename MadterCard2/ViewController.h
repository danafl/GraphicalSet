//
//  ViewController.h
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"


@interface ViewController : UIViewController

- (void)updateUI;
- (Deck *)createDeck;
- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card;
- (NSInteger)getPlayMode;
- (void)initializeCardsViews:(NSMutableArray *)cardsViews accordingToCards:(NSMutableArray *)cards;
- (NSUInteger)getNumberOfCards;
- (void)updateCardViewAsMatched:(UIView *)cardView;
- (void)removeCardViewFromBoard:(UIView *)cardView;
- (CGFloat)getGameViewWidth;
- (CGFloat)getGameViewHeight;
- (BOOL)isCardFaceUpAfterDealing;
- (void)addSubviewToGameView:(UIView *)view;
- (void)addCards:(NSUInteger)numberOfCards;
- (CGRect)getDeckFrame;
- (void)moveCardViewsToPalcesOnGrid;

@property (nonatomic) int animationNumber;
@property (strong, nonatomic) CardMatchingGame *game;



@end

