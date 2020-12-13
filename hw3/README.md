# HW3 - 网络访问和本地存储

**作业要求：** [requirements](https://gitee.com/chenguofan1999/mosad_-hw3)

## 我的程序

### 登录界面 & 个人信息

在校园网环境下使用用户名 *MOSAD* ，密码 *2020* 登录。

（非校园网环境可在 `SceneDelegate.m` / `Appdelegate.m` 中将程序入口改为 `GalleryViewController` , 跳过登录部分）

| 登录界面                                | 登录失败                                 | 个人信息                               |
| --------------------------------------- | ---------------------------------------- | -------------------------------------- |
| <img src="pics/login.png" width="500"/> | <img src="pics/login2.png" width="500"/> | <img src="pics/Info.png" width="500"/> |





### 图片浏览界面

#### 加载

|                  加载中                   |                 加载完成                 | 沙盒内缓存                              |
| :---------------------------------------: | :--------------------------------------: | --------------------------------------- |
| <img src="pics/loading.png" width="500"/> | <img src="pics/loaded.png" width="500"/> | <img src="pics/cache.png" width="600"/> |



#### 清空

**清空后点击加载**：立即加载出图片

| 清空前                                   | 清空后                                       | 再次点击加载                             |
| ---------------------------------------- | -------------------------------------------- | ---------------------------------------- |
| <img src="pics/loaded.png" width="500"/> | <img src="pics/AfterClear.png" width="500"/> | <img src="pics/loaded.png" width="500"/> |



#### 删除缓存

**删除后点击加载**: 需要加载 

| 删除缓存前                               | 删除缓存后                                    | 再次点击加载                              |
| ---------------------------------------- | --------------------------------------------- | ----------------------------------------- |
| <img src="pics/loaded.png" width="500"/> | <img src="pics/afterDelete.png" width="500"/> | <img src="pics/loading.png" width="500"/> |





## 实现 & 习得



1. 了解 IOS 的沙盒机制，学习基本的文件操作

   ```objc
   /*
    Document : 存储用户数据,需要备份的信息
    Library/Caches : 存储缓存文件,程序专用的支持文件
    Library/Preferences : 存储应用程序的偏好设置⽂件
    tmp : 存储临时文件,比如:下载的zip包,解压后的再删除
    xxx.app : 应用程序包
    iTunes在与iPhone同步时，会备份 `Documents` 和 `Preferences` 目录下的⽂件 。
   */
   
   // 获取程序的根目录
   NSString *homeDirectory = NSHomeDirectory();
   NSLog(@"homeDirectory = %@",homeDirectory);
   
   // 获取document目录
   NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   
   // 获取Caches目录
   NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
   
   // 获取Library目录
   NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
   
   // 获取Tmp目录
   NSString *tmpDirectory = NSTemporaryDirectory();
   
   // 获取xxx.app程序包
   NSBundle *myBundle = [NSBundle mainBundle];
   
   // 获取管理文件系统的单例
   NSFileManager *fileManager = [NSFileManager defaultManager];
   ```

2. 新接触两个基本UI控件

   - UIActivityIndicatorView : 加载指示，使用简单，放在图片中心，图片加载时 `startAnimating`, 加载完毕时 `stopAnimating`.
   - UIProgressView : 进度条，使用简单，可以直接用 `setProgress:` 方法设置进度.

3. 实现加载图片、文件读写涉及到的实用方法

   - ```objc
     + (instancetype)dataWithContentsOfFile:(NSString *)path;
     ```

     NSData 的方法，获取 filePath 处的文件的 NSData 对象，若没有这个文件，则得到 nil 。在这里用于查询缓存。

   - ```objc
     + (instancetype)dataWithContentsOfURL:(NSURL *)url; 
     ```

     NSData 的方法，得到 imageURL 对应的网络图片的 NSData 对象

   - ```objc
     + (UIImage *)imageWithData:(NSData *)data;
     ```

     UIImage 的方法,  (NSData *) -> (UIImage *), 和上一条一起用可从 URL 直接得到 (UIImage *)

   - ```objc
     - (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
     ```

     NSData 的方法，直接把 NSData 写入目标文件位置

   - ```objc
     - (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
     ```

     UITableView 的方法，只重新加载对应（多个）的 indexPath 的 Cell

4. 异步的实现

   实现异步是 TableView 提高用户体验的关键！这里实现了图片的异步加载，用的是 NSOperation:

   - ```objc
     @property (nonatomic, strong) NSOperationQueue *operationQueue;
     // 自定义队列, 会在子线程执行
     self.operationQueue = [[NSOperationQueue alloc]init];
     ```

   - ```objc
     NSBlockOperation *downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
     	// 加载任务
       // 如果下载成功
       if(downloadedImage)
       {
         // 存入沙盒中
         NSData *downloadedImageData = UIImagePNGRepresentation(downloadedImage);
         [downloadedImageData writeToFile:cacheFilePath atomically:YES];
       }
       
       // 刷新cell(一定要在主线程)
      	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [self.imageTable reloadRowsAtIndexPaths:@[indexPath]
          withRowAnimation:UITableViewRowAnimationNone];
     	}];
     }];
     
     [self.operationQueue addOperation:downloadOperation];
     ```

     

   

   

   



