//
//  ViewController.h
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface ViewController : UIViewController

- (void)updateUI;
- (Deck *)createDeck;
- (void)updateCardViewAsSelectedOrNot:(UIView *)cardView accordingToCard:(Card *)card;
- (NSInteger)getPlayMode;
- (void)initializeCardsViews:(NSMutableArray *)cardsViews accordingToCards:(NSMutableArray *)cards;
- (NSUInteger)getNumberOfCards;

/*
 - (void)updateCardButtonTitle:(UIButton *)cardButton byCard:(Card *)card;
 - (UIImage *)backgroundImageCard:(Card *)card;
 */




@end

