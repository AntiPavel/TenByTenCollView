//
//  ServerManager.h
//  TenByTenTest
//
//  Created by Павел Антонов on 25.07.15.
//  Copyright (c) 2015 Павел Антонов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

- (void) getImageUrlNameWithDate:(NSString *) date
                onSuccess:(void(^)(NSArray* imageUrls)) success
                onFailure:(void(^)( BOOL* isHaveUrl )) failure;

- (void) searchLastTop100Date: (NSString *) date
                    onSuccess:(void(^)(NSString * dateTop100UrlString)) success
                    onFailure:(void(^)( BOOL* isHaveHTMLData )) failure;


@end
