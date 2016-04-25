//
//  ViewController.m
//  Model
//
//  Created by wilon on 16/3/8.
//  Copyright © 2016年 wilon. All rights reserved.
//

#define kMapZipMd5 @"eaa04e2eca81b220b43a7425a0b418b0"
#define kTmpZipPath [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/bundle.GSPzip.tmp"]
#define kTmpZipInfoPath [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/bundleInfo.plist"]
#define kMapDownLoadPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bundle.GSP.zip"]
#define FileHashDefaultChunkSizeForReadingData 1024*10

#import "ViewController.h"
#import "GSPZipArchive.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NetWorkData.h"
#import <HotUpdateFramework/Interface.h>

@interface ViewController ()
@property (nonatomic, copy)  NSString * filePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor redColor]];
    
    
    [self getData];
   
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button addTarget:self action:@selector(authorAndUnzipMapfile) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"网络下载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *testbtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 220, 100, 100)];
    [testbtn setBackgroundColor:[UIColor yellowColor]];
    [testbtn addTarget:self action:@selector(testFramework) forControlEvents:UIControlEventTouchUpInside];
    [testbtn setTitle:@"iTunes 共享" forState:UIControlStateNormal];
    [testbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:testbtn];
    
}
- (void) getData {
    NetWorkData *data = [[NetWorkData alloc] init];
    [data donloadData:^(NSString *path) {
        _filePath = path;
    }];
}
- (void)authorAndUnzipMapfile

{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
        
//        NSString * filePath = kMapDownLoadPath;
        
        
        NSString *path = [_filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        
        GSPZipArchive * zipArchive = [[GSPZipArchive alloc]init];
        
        
        
        BOOL bZip = NO;
        
        if ([zipArchive UnzipOpenFile:path]) {
            
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documentDirectory = nil;
            if ([paths count] != 0)
                documentDirectory = [paths objectAtIndex:0];
            
            if ([zipArchive UnzipFileTo:documentDirectory overWrite:YES]) {
                
                bZip = YES;
                
                if ([zipArchive UnzipCloseFile]) {
                    
                    NSFileManager * fm = [NSFileManager defaultManager];
                    
                    [fm removeItemAtPath:path error:NULL];
                    
                }
                
                
                
            }
            
        }
        
        
        
        if (!bZip) {
            
            NSFileManager * fm = [NSFileManager defaultManager];
            
            [fm removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/China400.bundle"] error:NULL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"地图包解析失败,请重新解析" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
            });
            
        }
        
        
        //md5验证
        
//        NSString * fileMd5 = [self getFileMD5WithPath:_filePath];
//
//        if ([fileMd5 isEqualToString:kMapZipMd5]) {
//
//            GSPZipArchive * zipArchive = [[GSPZipArchive alloc]init];
//            
//            
//            
//            BOOL bZip = NO;
//            
//            if ([zipArchive UnzipOpenFile:_filePath]) {
//                
//                if ([zipArchive UnzipFileTo:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] overWrite:YES]) {
//                    
//                    bZip = YES;
//                    
//                    if ([zipArchive UnzipCloseFile]) {
//                        
//                        NSFileManager * fm = [NSFileManager defaultManager];
//                        
//                        [fm removeItemAtPath:_filePath error:NULL];
//                        
//                    }
//                    
//                    
//                    
//                }
//                
//            }
//            
//            
//            
//            if (!bZip) {
//                
//                NSFileManager * fm = [NSFileManager defaultManager];
//                
//                [fm removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/China400.bundle"] error:NULL];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"地图包解析失败,请重新解析" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    
//                    [alertView show];
//                    
//                });
//                
//            }
//            
//            
//            
//        }
        
//        else{//验证失败，文件有问题，删除本地文件
//            
//            NSFileManager * fm = [NSFileManager defaultManager];
//            
//            [fm removeItemAtPath:_filePath error:NULL];
//            
//            [fm removeItemAtPath:kTmpZipInfoPath error:NULL];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"地图包下载失败,请重新下载或联系管理员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                
//                [alertView show];
//                
//            });
//            
//        }
    });
    
}

-(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}


-(void)testFramework
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0)
    documentDirectory = [paths objectAtIndex:0];
    
    //拼接我们放到document中的framework路径
    NSString *libName = @"HotUpdateFramework.framework";
    NSString *destLibPath = [documentDirectory stringByAppendingPathComponent:libName];
    
    //判断一下有没有这个文件的存在　如果没有直接跳出
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:destLibPath]) {
        NSLog(@"There isn't have the file");
        return;
    }
    
    //复制到程序中
    NSError *error = nil;
    
    //    加载方式一：使用dlopen加载动态库的形式　使用此种方法的时候注意头文件的引入
    //        void* lib_handle = dlopen([destLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LOCAL);
    //        if (!lib_handle) {
    //            NSLog(@"Unable to open library: %s\n", dlerror());
    //            return;
    //        }
    ////    加载方式一　关闭的方法
    ////     Close the library.
    //        if (dlclose(lib_handle) != 0) {
    //            NSLog(@"Unable to close library: %s\n",dlerror());
    //        }
    
    //    加载方式二：使用NSBundle加载动态库
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
    if (frameworkBundle && [frameworkBundle load]) {
        NSLog(@"bundle load framework success.");
    }else {
        NSLog(@"bundle load framework err:%@",error);
        return;
    }
    
    /*
     *通过NSClassFromString方式读取类
     *PacteraFramework　为动态库中入口类
     */
    Class pacteraClass = NSClassFromString(@"Interface");
    if (!pacteraClass) {
        NSLog(@"Unable to get TestDylib class");
        return;
    }
    
    /*
     *初始化方式采用下面的形式
     　alloc　init的形式是行不通的
     　同样，直接使用PacteraFramework类初始化也是不正确的
     *通过- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
     　方法调用入口方法（showView:withBundle:），并传递参数（withObject:self withObject:frameworkBundle）
     */
    NSObject *pacteraObject = [pacteraClass new];
    [pacteraObject performSelector:@selector(showView:withBundle:) withObject:self withObject:frameworkBundle];
    
}


//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demozipfile.zip" ofType:nil];
//    BOOL result;
//    ZipArchive *za = [[ZipArchive alloc] init];
//    if ([za UnzipOpenFile:filePath]) {
//        result = [za UnzipFileTo:[self dataFilePath:@"2011"] overWrite:YES];
//        [za UnzipCloseFile];
//    }
//    [za release];
//    if (result) {
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self dataFilePath:@"2011/nga_519887.png"]];
//        imageView.image = image;
//        [image release];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
