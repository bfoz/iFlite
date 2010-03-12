//
//  MainViewController.h
//  iFlite
//
//  Created by Brandon Fosdick on 03/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

#import "flite.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView*   phrasePicker;
    UIActivityIndicatorView*	spinner;
    UITextField*    textInput;
    UILabel*	    voiceLabel;

    cst_voice*	voices[6];
    cst_voice*	voice;
}

@property (nonatomic, retain) IBOutlet UIPickerView* phrasePicker;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, retain) IBOutlet UITextField *textInput;
@property (nonatomic, retain) IBOutlet UILabel* voiceLabel;

- (IBAction)showInfo;

@end
