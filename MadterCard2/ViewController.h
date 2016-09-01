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
- (void) markCard:(UIButton *)cardButton ifSelected:(Card *)card;
- (void)updateCardButtonTitle:(UIButton *)cardButton byCard:(Card *)card;
- (UIImage *)backgroundImageCard:(Card *)card;
- (NSInteger)getPlayMode;
- (void)initializeCardsViews;

@end

