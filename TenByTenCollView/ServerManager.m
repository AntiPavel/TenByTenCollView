//
//  ServerManager.m
//  TenByTenTest
//
//  Created by Павел Антонов on 25.07.15.
//  Copyright (c) 2015 Павел Антонов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface ServerManager()

@end

@implementation ServerManager

static NSString* stringDate     = nil;
static NSString* urlString      = nil;
static NSString* imgNamesString = nil;

+ (ServerManager*) sharedManager {

    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

#pragma mark - Date UTC

- (void) getUTCDateInString {
    
    NSDate * dateNow = [NSDate date];
    
    NSDateFormatter* dateForm = [[NSDateFormatter alloc] init];
    
    [dateForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateForm setDateFormat:@"yyyy/MM/dd/HH/"];
    
    stringDate = [dateForm stringFromDate: dateNow];
}

- (void) getImageUrlNameWithDate:(NSString *) date
                    onSuccess:(void(^)(NSArray* imageUrls)) success
                    onFailure:(void(^)( BOOL* isHaveUrl )) failure;
{
    
    NSLog(@"urlString: %@", urlString);
    
    NSLog(@"stringDate: %@", stringDate);
    
    NSRange searchRange = NSMakeRange(0, [imgNamesString length]);
    
    NSMutableArray* imageUrls = [NSMutableArray array];
    
    while (YES) {
        
        NSRange range = [imgNamesString rangeOfString: @".jpg\"" options:0 range: searchRange];
        
        if (range.location != NSNotFound) {
            
            NSInteger index = range.location + range.length;
            
            searchRange.location = index;
            searchRange.length = [imgNamesString length] - index;
                
            range = [imgNamesString rangeOfString:@"</a></td>" options:0 range: searchRange];
            
            NSInteger imageNameLocation = searchRange.location + 1;
            
            NSString* str1 = [imgNamesString substringFromIndex: imageNameLocation];
            
            NSInteger imageNameLenght = range.location - searchRange.location -1;
            
            NSString* imageName = [str1 substringToIndex: imageNameLenght];
            
            [imageUrls addObject: [NSURL URLWithString:[urlString stringByAppendingString: imageName]]];
            
            index = range.location + range.length;
            
            searchRange.location = index;
            searchRange.length = [imgNamesString length] - index;
            
        } else {
            
            success(imageUrls);
            break;
        }
    }

}


- (void) searchLastTop100Date: (NSString *) dateNow
                    onSuccess:(void(^)(NSString * dateTop100UrlString)) success
                    onFailure:(void(^)( BOOL* isHaveHTMLData )) failure;
{
    [self getUTCDateInString];
    
    NSString* searchingElement = @"log.html";
    
    NSString* baseUriString = @"http://tenbyten.org/Data/global/";
    
    urlString = [baseUriString stringByAppendingString: stringDate];
    
    NSURL* url = [NSURL URLWithString: urlString];
    
    imgNamesString = [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error: nil];
    
    NSRange range = [imgNamesString rangeOfString: searchingElement];
    
    NSInteger stepHour = -3600;
    
    while (range.location == NSNotFound) {
        
        NSDate * dateNow = [NSDate dateWithTimeIntervalSinceNow: stepHour];
        
        NSDateFormatter* dateForm = [[NSDateFormatter alloc] init];
        
        [dateForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateForm setDateFormat:@"yyyy/MM/dd/HH/"];
        
        stringDate = [dateForm stringFromDate: dateNow];
        
         urlString = [baseUriString stringByAppendingString: stringDate];
        
        url = [NSURL URLWithString: urlString];
        
        imgNamesString= [NSString stringWithContentsOfURL: url encoding: NSUTF8StringEncoding error: nil];
        
        range = [imgNamesString rangeOfString: searchingElement];
        
        stepHour = stepHour - 3600;
        
        if (range.location != NSNotFound) {
            success(urlString);
        }
    }

}

@end
