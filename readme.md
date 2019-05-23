本项目是调用lebang水印相机和水印相册的插件，项目本身依赖于Lebang项目
安装方法
```bash
ionic cordova plugin add https://github.com/shuto-cn/lebangCamera.git
```
使用方法：

```javascript
if(VankeCamera){
    VankeCamera.getPictureFromCamera(function (msg) {
        console.log("getPictureFromCamera",msg);
    },function (err) {
        console.error("getPictureFromCamera",err);
    });
    VankeCamera.getPictureFromAlbum(8,function (msg) {
        console.log("getPictureFromAlbum",msg);
    },function (err) {
        console.error("getPictureFromAlbum",err);
    });
}
```
