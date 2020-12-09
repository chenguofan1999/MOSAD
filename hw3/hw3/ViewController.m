//
//  ViewController.m
//  hw3
//
//  Created by itlab on 12/7/20.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    
    /*
     
     Document : 存储用户数据,需要备份的信息
     Library/Caches : 存储缓存文件,程序专用的支持文件
     Library/Preferences : 存储应用程序的偏好设置⽂件
     tmp : 存储临时文件,比如:下载的zip包,解压后的再删除
     xxx.app : 应用程序包
     iTunes在与iPhone同步时，会备份 `Documents` 和 `Preferences` 目录下的⽂件 。
    
     */
    
//    // 获取程序的根目录
//    NSString *homeDirectory = NSHomeDirectory();
//    NSLog(@"homeDirectory = %@",homeDirectory);
//
//    // 获取document目录
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"documentPath = %@",documentPath);
//
//    // 获取Caches目录
//    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"cachesPath = %@",cachesPath);
//
//    // 获取Library目录
//    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"libraryPath = %@",libraryPath);
//
//    // 获取Tmp目录
//    NSString *tmpDirectory = NSTemporaryDirectory();
//    NSLog(@"tmpDirectory = %@",tmpDirectory);
//
//    // 获取xxx.app程序包
//    NSBundle *myBundle = [NSBundle mainBundle];
//    NSLog(@"app程序包 = %@",myBundle);
//
//    // 获取管理文件系统的单例
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // test1: 创建文件夹
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *testPath = [documentPath stringByAppendingPathComponent:@"test"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL res = [fileManager createDirectoryAtPath:testPath withIntermediateDirectories:YES attributes:nil error:nil];
//    if (res) {
//        NSLog(@"文件夹创建成功: %@",testPath);
//    }else{
//        NSLog(@"文件夹创建失败");
//    }
//
    
    // test2: 创建文件
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *testPath = [documentPath stringByAppendingPathComponent:@"test.txt"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL res = [fileManager createFileAtPath:testPath contents:nil attributes:nil];
//    if (res) {
//        NSLog(@"文件夹创建成功: %@",testPath);
//    }else{
//        NSLog(@"文件夹创建失败");
//    }
    
    // test3: 写数据到文件
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *testPath = [documentPath stringByAppendingPathComponent:@"test.txt"];
//
//    NSString *content=@"测试写入！";
//    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    if (res) {
//        NSLog(@"文件写入成功：%@",testPath);
//    }else {
//        NSLog(@"文件写入失败");
//    }
    
    // test4: 读文件数据
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *testPath = [documentPath stringByAppendingPathComponent:@"test.txt"];
//    NSString *content=[NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"文件读取成功: %@",content);
    
    // test5: 删除文件
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *testPath = [documentPath stringByAppendingPathComponent:@"test.txt"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL res=[fileManager removeItemAtPath:testPath error:nil];
//    if (res) {
//        NSLog(@"文件删除成功");
//    }else
//        NSLog(@"文件删除失败");
//    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:testPath]?@"YES":@"NO");
}
    

@end
