var exec = require('cordova/exec');

var vankeCamera = {
	getPictureFromCamera : function (success, error) {
	    exec(success, error, 'VankeCamera', 'getPictureFromCamera', []);
	},
	
		getPictureFromAlbum : function (max, success, error) {
	    exec(success, error, 'VankeCamera', 'getPictureFromAlbum', [max||4]);
	}
};

module.exports = vankeCamera;