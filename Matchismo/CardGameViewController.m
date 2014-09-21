//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Quynh Nguyen on 18/09/2014.
//  Copyright (c) 2014 ___QuynhNguyen___. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int count;
@property (strong, nonatomic) CardMatchingGame *cardGame;
@end

@implementation CardGameViewController

- (CardMatchingGame *) cardGame
{
    if (!_cardGame)
        _cardGame = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[self createDeck]];
    
    return _cardGame;
}

- (PlayingCardDeck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.cardGame chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.cardGame cardAtIndex:cardButtonIndex];
        
        //Retrospection can be used here to make sure the card is
        //  an instance of PlayingCard at runtime
        if ([card isMemberOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            UIColor *textColour = playingCard.inRed? [UIColor redColor]: [UIColor blackColor];
            if (playingCard.inRed)
                [cardButton setTitleColor:textColour forState:UIControlStateNormal];
        }
        
        [cardButton setTitle:[self titleForCard: card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backGroundImageForCard: card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.cardGame.score];
}

- (NSString *) titleForCard: (Card *)card
{
    return (card.isChosen? card.contents: @"");
}

- (UIImage *) backGroundImageForCard: (Card *)card
{
    return [UIImage imageNamed:(card.isChosen? @"cardfront": @"cardback")];
}

@end