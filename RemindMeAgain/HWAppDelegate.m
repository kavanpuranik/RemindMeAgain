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
    
    [self initDatePicker];
    
    [self initFormFields];

    NSLog(@"application started");
}

- (void)initFormFields {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *reminderText = [prefs stringForKey:@"reminderText"];
    if (reminderText == nil){
        reminderText = @"Get up. Take a Deep Breath. Stretch your legs.";
    }
    [reminderTextField setStringValue:reminderText];
    
    NSInteger reminderPeriodInSeconds = [prefs integerForKey:@"reminderPeriod"];
    if (reminderPeriodInSeconds == 0){
        reminderPeriodInSeconds = 15 * 60;
    }
    [self setReminderPeriod:reminderPeriodInSeconds];
}


- (void)applicationWillTerminate:(NSNotification *)notification {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[reminderTextField stringValue] forKey:@"reminderText"];
    [prefs setInteger:[self getReminderPeriod] forKey:@"reminderPeriod"];
    [prefs synchronize];
    
    NSLog(@"application ended");
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

    NSInteger intervalInSeconds = [self getReminderPeriod];    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: intervalInSeconds
                                                      target:self selector:@selector(startReminder:)
                                                    userInfo:[self userInfo] repeats:YES];
    
    self.repeatingTimer = timer;        
    [statusLabel setStringValue: @"Reminder is turned on."];
    NSLog(@"Started Timer...");
}

- (void)startReminder:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Notifying at %@", startDate);    
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
    NSLog(@"Stopping timer.");
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

- (NSInteger)getReminderPeriod {
    NSDate *periodDate = [periodPicker dateValue];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:periodDate];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger intervalInSeconds = hours * 60 * 60 + minutes * 60;
    
    NSLog(@"hours %ld minutes %ld", hours, minutes);
    NSLog(@"Interval set to %ld seconds", intervalInSeconds);
    return intervalInSeconds;
}

- (void)setReminderPeriod:(NSInteger)periodInSeconds {
    NSInteger reminderPeriodInMinutes = periodInSeconds / 60;
    NSLog(@"Reminder in minutes is %ld", reminderPeriodInMinutes);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMinute: reminderPeriodInMinutes % 60];
    [dateComponents setHour: reminderPeriodInMinutes / 60];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* result = [calendar dateFromComponents:dateComponents];
    
    [periodPicker setDateValue:result];
}

@end
