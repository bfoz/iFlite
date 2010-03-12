//
//  MainViewController.m
//  iFlite
//
//  Created by Brandon Fosdick on 03/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>

#import "MainViewController.h"
#import "MainView.h"

static const char* phrases[] =
{
    "Watson, come here, I need you",
    "Great kid, don't get cocky",
    "I would rather kiss a wookie!",
    "Just do it",
    "Been there, done that",
    "Not all those who wander are lost",
};

#define VOICE_INDEX_TIME_AWB	0
#define VOICE_INDEX_US_AWB	1
#define VOICE_INDEX_US_KAL	2
#define VOICE_INDEX_US_KAL16	3
#define VOICE_INDEX_US_RMS	4
#define VOICE_INDEX_US_SLT	5

static const char* voiceNames[] =
{
    "Time AWB",
    "AWB",
    "Kal",
    "Kal16",
    "RMS",
    "SLT",
};

@implementation MainViewController

@synthesize phrasePicker;
@synthesize spinner;
@synthesize textInput;
@synthesize voiceLabel;

cst_voice *register_cmu_time_awb(const char *voxdir);
cst_voice *register_cmu_us_awb(const char *voxdir);
cst_voice *register_cmu_us_kal(const char *voxdir);
cst_voice *register_cmu_us_kal16(const char *voxdir);
cst_voice *register_cmu_us_rms(const char *voxdir);
cst_voice *register_cmu_us_slt(const char *voxdir);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
	flite_init();
	voices[VOICE_INDEX_TIME_AWB] = register_cmu_time_awb(NULL);
	voices[VOICE_INDEX_US_AWB] = register_cmu_us_awb(NULL);
	voices[VOICE_INDEX_US_KAL] = register_cmu_us_kal(NULL);
	voices[VOICE_INDEX_US_KAL16] = register_cmu_us_kal16(NULL);
	voices[VOICE_INDEX_US_RMS] = register_cmu_us_rms(NULL);
	voices[VOICE_INDEX_US_SLT] = register_cmu_us_slt(NULL);
	voice = voices[VOICE_INDEX_US_KAL];
    }
    return self;
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
    [controller setVoice:2];

	[controller release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [spinner release];
    [textInput release];
    [voiceLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (unsigned)numVoices
{
    return sizeof(voices)/sizeof(voices[0]);
}

- (void)setVoice:(unsigned)index
{
    voiceLabel.text = [NSString stringWithFormat:@"%s says", voiceNames[index], nil];
    voice = voices[index];
}

- (const char*)voiceName:(unsigned)index
{
    return voiceNames[index];
}

#pragma mark -
#pragma mark UITextFieldDelegate

void completion(SystemSoundID ssID, void* spinner)
{
    AudioServicesDisposeSystemSoundID(ssID);
    AudioServicesRemoveSystemSoundCompletion(ssID);
    [(UIActivityIndicatorView*)spinner stopAnimating];	// Stop the spinner
}

- (void) speak:(const char*)text
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
							 NSUserDomainMask,
							 YES);
    NSString* dir = [paths objectAtIndex:0];
    NSString* path = [NSString stringWithFormat: @"%@/%s", dir, "recording.wav"];

    flite_text_to_speech(text, voice, [path UTF8String]);

    NSURL* url = [NSURL fileURLWithPath:path isDirectory:NO];

    //Use audio sevices to create the sound
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);

    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, completion, spinner);

    [spinner startAnimating];		    // Start the spinner
    AudioServicesPlaySystemSound(soundID);  // Use audio services to play the sound
}

- (BOOL)textFieldShouldReturn:(UITextField*)field
{
    if( field.text.length )
	[self speak:[field.text UTF8String]];
    [textInput resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [NSString stringWithCString:phrases[row] encoding:NSASCIIStringEncoding];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self speak:phrases[row]];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return sizeof(phrases)/sizeof(phrases[0]);
}

@end
