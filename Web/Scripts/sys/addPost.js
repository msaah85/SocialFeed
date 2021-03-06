﻿/// <reference path="common.js" />
/// <reference path="DataService.js" />

var
    newPostManager = function () {
        var
            init = function () {
                pageEvents();

                getProperties();
            },

            getProperties = function () {
                // Social settings
                var uRL = '/api/data/GetDataDirect',
                    data = { actionName: 'Settings_Social' },
                    settingCallBack = function (data) {
                        data = commonManger.decoData(data).list;


                        var
                            //                   0                      1                   2                     3                   4                     5                   6                   7
                            myVariables = ['Facebook_Active', 'Facebook_PageURL', 'Facebook_AccessToken', 'Instagram_Active', 'Instagram_UserID', 'Instagram_Password', 'Facebook_PageID', 'Post_DefaultMessage'],

                            fbActive = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[0])
                                    return v.Value;
                            }),
                            fbPostURL = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[1])
                                    return v.Value;
                            }),
                            fbURL = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[6])
                                    return v.Value;
                            }),
                            fbToken = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[2])
                                    return v.Value;
                            }),
                            instActive = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[3])
                                    return v.Value;
                            }),
                            instID = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[4])
                                    return v.Value;
                            }),
                            instPass = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[5])
                                    return v.Value;
                            }),
                            defaultMesg = $.grep(data, function (v, k) {
                                if (v.Name === myVariables[7])
                                    return v.Value;
                            }),
                            socialHtml = '';
                        
                        // show default post message
                        $('#message').val(defaultMesg[0].Value);
                        
                        // showing social page
                        if (fbActive[0].Value === 'True') {
                            socialHtml = `<div class="so-options" data-url="${fbPostURL[0].Value}"  data-token="${fbToken[0].Value}"><label class="middle"><input class="ace" type="checkbox" checked /><span class="lbl">Facebook</span></label>&nbsp;<i class="fa fa-arrow-right"></i> <a title="Open your page" href="http://facebook.com/${fbURL[0].Value}" target="_blank"><i class="fa fa-2x fa-facebook"></i></a></div>`;
                        }
                        if (instActive[0].Value === 'True') {
                            socialHtml += `<div class="so-options" data-url="${instID[0].Value}"  data-token="${instPass[0].Value}"><label class="middle"><input class="ace" type="checkbox" checked /><span class="lbl">Instagram</span></label>&nbsp;<i class="fa fa-arrow-right"></i> <a title="Open your page" href="http://instagram.com/${instID[0].Value}" target="_blank"><i class="fa fa-2x fa-instagram"></i></a></div>`;
                        }
                        //if (twActive[0].Value === 'True') {
                        //    socialHtml += `<div data-url="${twURL[0].Value}"  data-token="${twToken[0].Value}"><label class="middle"><input class="ace" type="checkbox" checked /><span class="lbl">Facebook</span></label>&nbsp;<i class="fa fa-arrow-right"></i><a href="http://twitter.com/DarAlQimahFashion" target="_blank"><i class="fa fa-2x fa-twitter"></i></a></div>`;
                        //}


                        $('.socialActivePages').html(socialHtml);

                    };

                dataService.callAjax('GET', data, uRL, settingCallBack,
                    commonManger.errorException);
            },

            getImageName = function () {
                var nme = $('input[type=file]').eq(0).val().replace(/.*(\/|\\)/, '');
                return nme.split(".")[0];
            },

            uploadImage = function (imgStr) {
                var uRL = "/api/Upload/Save",
                    uploadCallBack = function (data) {
                        console.log(data);
                    },
                    data = { Name: imgStr };


                dataService.callAjax('POST', JSON.stringify(data), uRL,
                    uploadCallBack, commonManger.errorException);
            },

            potingToSocial = function () {
                var
                    post = {
                        uRL: '/api/social/PostFeed',
                        img: $('#post-image').attr('src'),
                        fbCtrl: $('.so-options:eq(0)'),
                        insCtrl: $('.so-options:eq(1)'),

                        // avialable social pages checked
                        fbActive: function () { var _this = this; return _this.fbCtrl.find('input[type="checkbox"]').is(':checked') ? true : false; },
                        insActive: function () { var _this = this; return _this.insCtrl.find('input[type="checkbox"]').is(':checked') ? true : false; },

                        fbPostUrl: function () { var _this = this; return _this.fbCtrl.data('url'); },
                        fbToken: function () { var _this = this; return _this.fbCtrl.data('token'); },

                        insID: function () { var _this = this; return _this.insCtrl.data('url'); },
                        insToken: function () { var _this = this; return _this.insCtrl.data('token'); },

                        msg: $('#message').val(),
                        imageBase64: function () {
                            var _this = this, // cut base64 image string.
                                _imgStr = _this.img && _this.img.length ? _this.img.split(',')[1] : '';
                            return _imgStr;
                        },
                        showMessage: function (typeID, message) {
                            var _msg = '<div class="alert alert-' + (typeID > 1 ? 'danger' : 'success') + '">' + message + '</div>';
                            $('.message').html(_msg);
                        },
                        postedSocialCallBack: function (d) {
                            post.showMessage(1, 'This post has been added to your social page.');
                            window.location.href = 'Social/Posts';
                        }
                    },
                    socialPost = {
                        Message: post.msg,
                        ImageBase64: post.imageBase64(),
                        FacebookActive: post.fbActive(),
                        InstagramActive: post.insActive(),
                        FacebookPostURL: post.fbPostUrl(),
                        FacebookToken: post.fbToken(),
                        InstagramID: post.insID(),
                        InstagramToken: post.insToken(),
                    };

                //validation
                if (post.imageBase64().length < 5) {
                    commonManger.showMessage('Image is required', 'Please select an image.');
                    $('#image2').closest('div.form-group').addClass('text-danger');
                    return;
                }
                if (socialPost.Message === '') {
                    commonManger.showMessage('Message is required', 'Please enter post message.');
                    $('#message').closest('div.form-group').addClass('text-danger');
                    return;
                }
                if (!socialPost.FacebookActive && !socialPost.InstagramActive) {
                    commonManger.showMessage('Post to is required', 'Please select at least one from Post to.');
                    $('.so-options').closest('div.form-group').addClass('text-danger');
                    return;
                }
                
                // get data
                dataService.callAjax('POST', JSON.stringify(socialPost), post.uRL,
                    post.postedSocialCallBack, commonManger.errorException);
            },

            pageEvents = function () {
                // start post to all pages
                $('#SendAll').click(function (e) {
                    e.preventDefault();
                    potingToSocial();

                });

                // image selection
                $('#image').ace_file_input({
                    style: 'well',
                    btn_choose: 'Drop image here or click to choose',
                    btn_change: null,
                    no_icon: 'ace-icon fa fa-picture-o',
                    droppable: true,
                    thumbnail: 'large', //| true | 
                    whitelist: 'gif|png|jpg|jpeg',
                    blacklist: 'exe|php|asp|aspx|txt|doc',
                    allowExt: ["jpeg", "jpg", "png", "gif", "bmp"],
                    allowMime: ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"],
                    before_change: function (files, dropped) {
                        var validImg = true;
                        for (var i = 0; i < files.length; i++) {
                            var
                                _file = files[i],
                                _img = new Image();

                            _img.onload = function () {
                                if (!_img || (_img.height < 200 && _img.width < 200)) {
                                    commonManger.showMessage('Too small !!!', `The image (${_file.name}) is too small, please select a large image.`);
                                    $('.ace-file-input a.remove').trigger('click'); // remove the selected image
                                    validImg = false;
                                }
                            }
                            _img.src = URL.createObjectURL(_file);
                        }


                        return validImg;
                    },
                    before_remove: function () {
                        return true;
                    },
                    preview_error: function (filename, error_code) {
                        //name of the file that failed
                        //error_code values
                        //1 = 'FILE_LOAD_FAILED',
                        //2 = 'IMAGE_LOAD_FAILED',
                        //3 = 'THUMBNAIL_FAILED'
                        //alert(error_code);
                    }
                }).on('change', function () {
                    var _this = $(this)[0],
                        images = _this.files,
                        image = images ? images[0] : null;

                    if (image) {
                        var reader = new FileReader();
                        reader.onloadend = function () {
                            var $imgg = $('span.ace-file-name');
                            if ($imgg)
                                $imgg.data('src', reader.result);

                        }
                        reader.readAsDataURL(image);
                    }


                    //var _this = $(this)[0],
                    //    images = _this.files,
                    //    //imgsCount = images ? images.length : 0,
                    //    imgPath = _this.value,
                    //    imgSize = images.length ? images[0].size : 0,
                    //    imgExtn = imgPath.substring(imgPath.lastIndexOf('.') + 1).toLowerCase();

                    //if (this.width < 200) {
                    //    commonManger.showMessage('This photo is too small:', 'Please select a large image mini width 200 px.');
                    //    return;
                    //}
                });
            };

        return {
            Init: init
        };

    }();

newPostManager.Init();