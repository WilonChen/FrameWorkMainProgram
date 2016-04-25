//
//  NetWorkData.m
//  PacteraFramework
//
//  Created by wilon on 16/3/9.
//  Copyright © 2016年 wilon. All rights reserved.
//

#import "NetWorkData.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@implementation NetWorkData

- (void)donloadData:(void (^)(NSString *path))path {
    
    //@"http://51biaoshi.com/package/zhangguoqi.zip"
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//      这里写自己服务器的地址，其实我不想写出来的，我觉得大家都知道。
    NSURL *URL = [NSURL URLWithString:@"http://51biaoshi.com/package/PacteraFramework.framework.zip"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        path([filePath absoluteString]);
    }];
    
    [downloadTask resume];
}
@end
