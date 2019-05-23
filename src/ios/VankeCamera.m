/********* VankeCamera.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface VankeCamera : CDVPlugin {
  // Member variables go here.
}

- (void)getPictureFromCamera:(CDVInvokedUrlCommand*)command;
- (void)getPictureFromAlbum:(CDVInvokedUrlCommand*)command;
@end

@implementation VankeCamera

    //打开水印相机,返回拍摄的照片(Base64格式)
- (void)getPictureFromCamera:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    //warn：：：请使用反射调用乐邦的方法 否则由于缺少依赖极光的项目的独立包将无法编译
    
    //成功获取到照片后调用此方法: pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:base64Data];
    
    //未获取到照片返回具体原因
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"getPictureFromCamera::未实现的方法!"];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
    //打开水印相册,返回选择的照片数组([Base64格式])
- (void)getPictureFromAlbum:(CDVInvokedUrlCommand*)command
    {
        CDVPluginResult* pluginResult = nil;
        int max = [command.arguments objectAtIndex:0];//最大选择照片数量
        max = max <= 0 ? 2 : max;
        
        //warn：：：请使用反射调用乐邦的方法 否则由于缺少依赖极光的项目的独立包将无法编译
        
        //成功获取到照片后调用此方法:pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:base64Array];
        
        //未获取到照片返回具体原因
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"getPictureFromAlbum::未实现的方法!"];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
@end
