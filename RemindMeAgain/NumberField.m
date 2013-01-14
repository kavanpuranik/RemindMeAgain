//  NumberField.m
//  Created by Kavan Puranik
#import "NumberField.h"

@implementation NumberField

-(void) textDidChange:(NSNotification *)aNotification {
    
    NSString* value = [self stringValue];
    if ([value length] > 3) {
        [self setStringValue:[[value uppercaseString] substringWithRange:NSMakeRange(0, 3)]];
    } else {
        [self setStringValue:[value uppercaseString]];
    }
    	
	[self setIntValue:[self intValue]];
    
    // TODO read up about delegates first: http://mobiledevelopertips.com/objective-c/the-basics-of-protocols-and-delegates.html
    // make sure the notification is sent back to any delegate
    // [[self delegate] textDidChange:aNotification];
}

@end