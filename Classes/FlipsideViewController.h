//
//  FlipsideViewController.h
//  iFlite
//
//  Created by Brandon Fosdick on 03/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	id <FlipsideViewControllerDelegate> delegate;

    UIPickerView*   voicePicker;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView* voicePicker;

- (IBAction)done;

- (void)setVoice:(unsigned)index;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (unsigned)numVoices;
- (void)setVoice:(unsigned)index;
- (const char*)voiceName:(unsigned)index;
@end

