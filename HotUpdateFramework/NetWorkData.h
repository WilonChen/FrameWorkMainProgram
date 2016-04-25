//
//  NetWorkData.h
//  PacteraFramework
//
//  Created by wilon on 16/3/9.
//  Copyright © 2016年 wilon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkData : NSObject
- (void)donloadData:(void (^)(NSString *path))path;

@end
