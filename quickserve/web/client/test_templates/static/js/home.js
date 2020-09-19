//console.log("hello world")
function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
  
      reader.onload = function (e) {
              $uploadedImg[0].style.backgroundImage='url('+e.target.result+')';
      };
  
      reader.readAsDataURL(input.files[0]);
    }
  }
  
  var $form = $("#imageUploadForm"), 
      $file = $("#file"), 
      $uploadedImg = $("#uploadedImg"), 
      $helpText = $("#helpText")
  ;
  $file.on('change', function(){
    readURL(this);
    $form.addClass('loading');
  });
  $uploadedImg.on('webkitAnimationEnd MSAnimationEnd oAnimationEnd animationend', function(){
    $form.addClass('loaded');
  });
  $helpText.on('webkitAnimationEnd MSAnimationEnd oAnimationEnd animationend', function(){
    setTimeout(function() {
      $file.val('');  $form.removeClass('loading').removeClass('loaded');
    }, 5000);
  });