var exec = require('cordova/exec');

var vankeCamera = {
    getPictureFromCamera : function (max, success, error) {
        exec(success, error, 'VankeCamera', 'getPictureFromCamera', [max||4]);
    },

    getPictureFromAlbum : function (max, success, error) {
        exec(success, error, 'VankeCamera', 'getPictureFromAlbum', [max||4]);
    }
};

module.exports = vankeCamera;
