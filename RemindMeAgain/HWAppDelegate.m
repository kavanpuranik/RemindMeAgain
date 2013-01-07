//
//  HWAppDelegate.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 1/5/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "HWAppDelegate.h"

@implementation HWAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [reminderTextField setStringValue:@"Get up. Take a Deep Breath. Stretch your legs."];
    
    [self initDatePicker];
    NSLog(@"application started");
}

- (IBAction)startStopReminder:(id)sender {
    if ([[startStopButton title] isEqualToString:@"Turn On"]){        
        [self startReminderTimer];
        [startStopButton setTitle:@"Turn Off"];
        [statusLabel setStringValue: @"Reminder is On"];
    } else {
        [self stopReminderTimer];
        [startStopButton setTitle:@"Turn On"];
        [statusLabel setStringValue: @"Reminder is Off"];
    }
    
}

- (void) startReminderTimer {
    
    // Cancel any preexisting timer
    [self.repeatingTimer invalidate];
    
    NSDate *periodDate = [periodPicker dateValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:periodDate];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger intervalInSeconds = hours * 60 * 60 + minutes * 60;
    
    NSLog(@"hours %ld minutes %ld", hours, minutes);
    NSLog(@"Interval set to %ld seconds", intervalInSeconds);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: intervalInSeconds
                                                      target:self selector:@selector(startReminder:)
                                                    userInfo:[self userInfo] repeats:YES];
    
    self.repeatingTimer = timer;
    
    NSLog(@"Started Timer...");
    [statusLabel setStringValue: @"Reminder is turned on."];
}

- (void)startReminder:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Timer started on %@", startDate);
    
    NSString* reminderText = [reminderTextField stringValue];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Remind Me";
    notification.informativeText = reminderText;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void) stopReminderTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
    NSLog(@"Ended Timer.");
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date] };
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)initDatePicker
{
      NSLocale*  my24HourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
     [periodPickerCell setLocale:my24HourLocale];
     [periodPickerCell setFormatter:[[NSDateFormatter alloc] initWithDateFormat:@"%H:%M" allowNaturalLanguage:NO] ];
     [periodPickerCell setTitle:@"00:30"];
}

@end
