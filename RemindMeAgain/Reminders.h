//
//  Reminders.h
//  RemindMeAgain
//
//  Created by Kavan Puranik on 6/25/13.
//  Copyright (c) 2013 Kavan Puranik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@interface Reminders : NSObject {
    
    NSDictionary* remindersMap;
}

- (Reminder*) getReminderById:(NSString*)reminderId;

-(NSArray*) getAllReminders;

@end
