function select_profile_pic(thumbnail_crop_width, thumbnail_crop_height) {
    $('#profile_photo_upload').click();
    $('#profile_photo_upload').change(function (e) {
        $('.modal-dialog').addClass('modal-lg');

        //showing local image
        var tmppath = URL.createObjectURL(e.target.files[0]);

        //cropper image
        var $image = $("img#crop_profile_pic").fadeIn().attr('src', tmppath),
            canvasData;

        //showing image in modal
        $('.modal-window').modal('show');

        //applying cropper on a image
        $('.modal-window').on('shown.bs.modal', function () {
            $image.cropper({
                strict: true,
                guides: true,
                highlight: true ,
                dragCrop: false,
                cropBoxMovable: true,
                cropBoxResizable: false,
                modal: true,
                built: function () {
                    // Strict mode: set crop box data first
                    canvasData = $image.cropper('getCanvasData');
                    var cropBox = {
                        width  : thumbnail_crop_width,
                        height : thumbnail_crop_height
                    };
                    $image.cropper('setCropBoxData', cropBox);
                    $image.cropper('setCanvasData', canvasData);
                }
            });
        }).submit('#submit_crop', function () {
            $('.modal-window').modal('hide');
            cropBoxData = $image.cropper('getCropBoxData');
            canvasData = $image.cropper('getCanvasData');
            var getData = $image.cropper('getData');

            $('#width').val(getData.width);
            $('#height').val(getData.height);
            $('#x').val(getData.x);
            $('#y').val(getData.y);
            $image.cropper('destroy');
        });
    });
}


