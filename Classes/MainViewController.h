//
//  MainViewController.h
//  iFlite
//
//  Created by Brandon Fosdick on 03/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate>
{
    UITextField*    textInput;
}

@property (nonatomic, retain) IBOutlet UITextField *textInput;

- (IBAction)showInfo;

@end
