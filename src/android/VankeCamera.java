package com.vanke.cordova.camera;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class VankeCamera extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getPictureFromCamera")) {
            this.getPictureFromCamera(callbackContext);
            return true;
        }else if (action.equals("getPictureFromAlbum")) {
            int max = args.getInt(0);
            this.getPictureFromAlbum(max, callbackContext);
            return true;
        }
        return false;
    }

	  /**
	  * 打开水印相机拍照并返回照片base64数据
	  * @param callbackContext 回调函数
	  */
    private void getPictureFromCamera(CallbackContext callbackContext) {
    	
    	//warn：：：请使用反射调用乐邦的方法 否则由于缺少依赖极光的项目的aar包将无法编译
    		
    		//如果获取到照片 调用	callbackContext.success(base64Data);

        //如果没有获取到照片 调用 callbackContext.error("未获取到照片的原因");

        callbackContext.error("getPictureFromCamera::此方法未实现!");
    }
    /**
	  * 打开水印相册 返回照片base64数据
	  * @param max 最大选择数量
	  * @param callbackContext 回调函数
	  */
    private void getPictureFromAlbum(int max, CallbackContext callbackContext) {
        max = max <=0 ? 2 : max;//最大选择照片数量
        
        //warn：：：请使用反射调用乐邦的方法 否则由于缺少依赖极光的项目的aar包将无法编译
        
        //如果获取到照片 调用	callbackContext.success(base64Data[]);

        //如果没有获取到照片 调用 callbackContext.error("未获取到照片的原因");
        callbackContext.error("getPictureFromAlbum::此方法未实现!");
    }
}
