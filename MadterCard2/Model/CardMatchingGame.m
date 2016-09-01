//
//  CardMatchingGame.m
//  MadterCard2
//
//  Created by Dana Fleischer on 23/08/2016.
//  Copyright © 2016 Dana Fleischer. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) NSInteger score;
@end


@implementation CardMatchingGame

static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)lastChosenCards
{
  if(!_lastChosenCards)
  {
    _lastChosenCards = [[NSMutableArray alloc] init];
  }
  return _lastChosenCards;
}

- (NSMutableArray *)cards
{
  if(!_cards)
  {
    _cards = [[NSMutableArray alloc]init];
  }
  return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
  self = [super init];
  if(self)
  {
    for(int i = 0; i < count; i++)
    {
      Card *card = [deck drawRandomCard];
      if(card) {
        [self.cards addObject:card];
      } else {
        //if there are not enough cards - return nil
        self = nil;
        break;
      }
    }
  }
  return self;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
                     withPlayMode:(NSInteger)playMode {
  self = [self initWithCardCount:count usingDeck:deck];
  self.playMode = playMode;
  return self;
}

-(void)chooseCardAtIndex:(NSUInteger)index
{
  Card *card = [self cardAtIndex:index];

  //find the other cosen cards
  NSMutableArray *chosenCards = [[NSMutableArray alloc]init];

  //get all the chosen cards
  for(Card *otherCard in self.cards)
  {
    if(otherCard.isChosen && !otherCard.isMatched)
    {
      [chosenCards addObject:otherCard];
    }
  }


  self.lastChoiceMatched = NO;
  self.scoreChange = 0;


  if(!card.isMatched)
  {
    //If the card was chosen already - unchoose it.
    if(card.isChosen)
    {
      card.chosen = NO;
      [chosenCards removeObject:card];
    }else{
      //Change the score and the matched. state of the chosen cards
      //Try to match only if the right number of cards were selected.
      if([chosenCards count] == self.playMode - 1)
      {
        int matchScore = [card match:chosenCards];
        if(matchScore)
        {
          self.lastChoiceMatched = YES;
          self.scoreChange = matchScore * MATCH_BONUS;
          self.score += self.scoreChange;
          card.matched = YES;
          for (Card *otherCard in chosenCards)
          {
            otherCard.matched = YES;
          }

        }
        else{
          self.scoreChange = MISMATCH_PENALTY;
          self.score -= self.scoreChange;
          for (Card *otherCard in chosenCards)
          {
            otherCard.chosen = NO;
          }
        }

      }
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;

    }
  }

  //update the cards of the last play
  self.lastChosenCards = chosenCards;

  //the card is chosen in this play, unless it is not chosen (was chosen before)
  if(card.chosen)
  {
    [self.lastChosenCards addObject:card];
  }

}

- (Card *)cardAtIndex:(NSUInteger)index {
  return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (instancetype)init
{
  return nil;
}


@end
