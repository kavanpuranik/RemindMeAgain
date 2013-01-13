//
//  HWAppDelegate.h
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/5/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenubarController.h"
#import "PanelController.h"

@interface HWAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate, PanelControllerDelegate>
{
    
    IBOutlet NSTextField *reminderTextField;
    IBOutlet NSDatePicker *periodPicker;
    IBOutlet NSDatePickerCell *periodPickerCell;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSButton *startStopButton;

}

@property (assign) IBOutlet NSWindow *window;

@property (weak) NSTimer *repeatingTimer;

- (IBAction)startStopReminder:(id)sender;

- (NSDictionary *)userInfo;


@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

- (IBAction)togglePanel:(id)sender;

@end
