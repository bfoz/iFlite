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

#define VOICE_INDEX_TIME_AWB	0
#define VOICE_INDEX_US_AWB	1
#define VOICE_INDEX_US_KAL	2
#define VOICE_INDEX_US_KAL16	3
#define VOICE_INDEX_US_RMS	4
#define VOICE_INDEX_US_SLT	5

@implementation MainViewController

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


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
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
    [textInput release];
    [voiceLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

void completion(SystemSoundID ssID, void* clientData)
{
    AudioServicesDisposeSystemSoundID(ssID);
    AudioServicesRemoveSystemSoundCompletion(ssID);
}

- (BOOL)textFieldShouldReturn:(UITextField*)field
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
							 NSUserDomainMask,
							 YES);
    NSString* dir = [paths objectAtIndex:0];
    NSString* path = [NSString stringWithFormat: @"%@/%s", dir, "recording.wav"];

    flite_text_to_speech([field.text UTF8String], voice, [path UTF8String]);

    NSURL* url = [NSURL fileURLWithPath:path isDirectory:NO];

    //Use audio sevices to create the sound
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID);

    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, completion, NULL);

    //Use audio services to play the sound
    AudioServicesPlaySystemSound(soundID);

    [textInput resignFirstResponder];
    return YES;
}

@end
