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
//@property (weak, nonatomic) IBOutlet PlayingCardView *PlayingCardView;

@end

@implementation PlayingCardViewController
/*
-(void)viewDidLoad {
  [super viewDidLoad];
  self.PlayingCardView.suit = @"♥︎";
  self.PlayingCardView.rank = 13;
  self.PlayingCardView.faceUp = YES;
}*/


static const int PLAY_MODE_TYPE = 2;

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




@end
