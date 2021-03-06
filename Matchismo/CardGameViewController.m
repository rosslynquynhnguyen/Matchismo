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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@property (nonatomic) int count;
@property (strong, nonatomic) CardMatchingGame *cardGame;
@end

@implementation CardGameViewController

- (CardMatchingGame *) cardGame
{
    NSUInteger matchingCards = [self.gameModeButton selectedSegmentIndex] + 2;
    if (!_cardGame)
        _cardGame = [[CardMatchingGame alloc] initWithCardCount: [self.cardButtons count]
                                                      usingDeck: [self createDeck]
                                                           with: matchingCards ];
    
    return _cardGame;
}

- (PlayingCardDeck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = (int)[self.cardButtons indexOfObject: sender];
    [self.cardGame chooseCardAtIndex: chosenButtonIndex];
    [self updateUI];
    
    if (self.gameModeButton.enabled) self.gameModeButton.enabled = NO;
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = (int)[self.cardButtons indexOfObject:cardButton];
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

- (IBAction)changeGameMode: (UISegmentedControl *)sender
{
//    int selectedIndex = [sender selectedSegmentIndex];
//    NSString *title = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
//    NSLog(@"index = %d: %@", selectedIndex, title);
    
    [self restartGame];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1) //index of the yes button
    {
        [self restartGame];
        self.gameModeButton.enabled = YES;
    }
}

- (void) restartGame
{
    self.cardGame = nil;
    [self updateUI];
}

- (IBAction)touchRestart:(UIButton *)sender
{
    if (self.cardGame.gameStarted)
    {
        // create a simple confirmation dialog
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Restart Game?"
                                    message: @"Are you sure you want to abandon the current game and restart?"
                                   delegate: self
                          cancelButtonTitle: @"No"
                          otherButtonTitles: @"Yes",
                          nil];
        [alert show];
        //[alert release];
    }
    else [self restartGame];
}

@end


