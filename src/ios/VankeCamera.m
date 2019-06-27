/********* VankeCamera.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "UIImage+base64.h"
#import "VKWatermarkCameraController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <Photos/Photos.h>

@interface VankeCamera : CDVPlugin {
    // Member variables go here.
}

- (void)getPictureFromCamera:(CDVInvokedUrlCommand*)command;
- (void)getPictureFromAlbum:(CDVInvokedUrlCommand*)command;
@end


@interface VankeCamera()<ZTImagePickerControllerDelegate,ZLPhotoPickerViewControllerDelegate>
@property (nonatomic,strong) NSString* callbackId;
@property (nonatomic,assign) NSInteger maxSelectionCount;
@end

@implementation VankeCamera

//打开水印相机,返回拍摄的照片(Base64格式)
- (void)getPictureFromCamera:(CDVInvokedUrlCommand*)command
{
    self.maxSelectionCount = [[command.arguments objectAtIndex:0] integerValue];//最大选择照片数量
    self.callbackId = command.callbackId;
    [self checkCameraAuthorization];
}


-(void)checkCameraAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"访问受限"
                                                            message:@"请前往“设置”中允许“助英台”访问您的相机"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"设置", nil];
            [alert show];
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                    //判断是否有摄像头
                    if([UIImagePickerController isSourceTypeAvailable:sourceType])
                    {
                        VKWatermarkCameraController *picker = [[VKWatermarkCameraController alloc] init];
                        picker.maxSelectionCount = self.maxSelectionCount;
                        picker.isNeedAlbum = YES;
                        picker.delegate = self;
                        [GlobalSettings sharedSettings].isWaterCamera = YES;
                        picker.isHomeJump = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
                                                          animated:YES
                                                        completion:nil];
                    }
                } else {
                    [self failedCallBack:@"授权被拒绝，无法访问相机！"];
                }
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            VKWatermarkCameraController *picker = [[VKWatermarkCameraController alloc] init];
            picker.maxSelectionCount = self.maxSelectionCount;
            picker.isNeedAlbum = YES;
            picker.delegate = self;
            [GlobalSettings sharedSettings].isWaterCamera = YES;
            picker.isHomeJump = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]
                                              animated:YES
                                            completion:nil];
        }
            break;
        default:
            break;
    }
}

//打开水印相册,返回选择的照片数组([Base64格式])
- (void)getPictureFromAlbum:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    self.maxSelectionCount = [[command.arguments objectAtIndex:0] integerValue];//最大选择照片数量
    
    [self checkAlbumAuthorization];
}


-(void)checkAlbumAuthorization
{
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
                    pickerVc.status = PickerViewShowStatusWaterPhotos;
                    pickerVc.delegate = self;
                    pickerVc.maxCount = self.maxSelectionCount;
                    [self.viewController presentViewController:pickerVc animated:YES completion:nil];
                }
                    break;
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"访问受限"
                                                                    message:@"请前往“设置”中允许“助英台”访问您的相册"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"设置", nil];
                    [alert show];
                    break;
                }
                    
                case PHAuthorizationStatusRestricted: {
                    [self failedCallBack:@"因系统原因，无法访问相册！"];
                    break;
                }
                    
                default:
                    break;
            }
        });
    }];
}

#pragma mark-h5 callback
- (void)successCallBack:(NSArray *)imageArr
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:imageArr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)failedCallBack:(NSString *)errorStr
{
    //未获取到照片返回具体原因
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}


#pragma mark-delegate
-(void)imagePickerControllerUseAlbumImage:(ZTImagePickerController *)picker images:(NSArray *)images
{
    NSMutableArray *imageArr = [NSMutableArray array];
    for (UIImage *image in images) {
        [imageArr addObject:[image toBase64]];
    }
    [self successCallBack:imageArr];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
{
    if (assets.count > 0) {
        NSMutableArray<UIImage *> *oriImageArr = [NSMutableArray array];
        for (MLSelectPhotoAssets *asset in assets) {
            [oriImageArr addObject:asset.originImage];
        }
        NSMutableArray *imageArr = [NSMutableArray array];
        for (UIImage *image in oriImageArr) {
            [imageArr addObject:[image toBase64]];
        }
        [self successCallBack:imageArr];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [AppUtility openApplicationSetting];
}
@end
