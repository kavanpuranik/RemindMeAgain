//
//  Reminders.m
//  RemindMeAgain
//
//  Created by Kavan Puranik on 6/25/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import "Reminders.h"

@implementation Reminders

- (id)init
{
    self = [super init];
    if (self) {
        [self initReminderMap];
    }
    return self;
}

- (void) initReminderMap
{
    Reminder* reminderOne = [[Reminder alloc] initWithReminderId:@"Primary"];
    Reminder* reminderTwo = [[Reminder alloc] initWithReminderId:@"Secondary"];
    
    remindersMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                    reminderOne, @"1",
                    reminderTwo, @"2",
                    nil];
}

-(Reminder*) getReminderById:(NSString*)reminderId
{
    return [remindersMap objectForKey:reminderId];
}

@end
