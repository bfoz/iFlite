//
//  iFliteAppDelegate.h
//  iFlite
//
//  Created by Brandon Fosdick on 03/07/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@class MainViewController;

@interface iFliteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

