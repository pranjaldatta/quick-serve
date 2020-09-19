function handleFileChange(e) {
    console.log(e.target.files[0])
}

function handleUpload(e) {
    
    console.log("handler triggered!")
}

//document.querySelector('.file-select').addEventListener('change', handleFileChange);
//document.querySelector('.file-submit').addEventListener('click', handleUpload);


function handleChange(input) {
    console.log("handleChange fired")
    imgbox = $('#input-image')
    console.log(input)
    if(input.files && input.files[0]) {
        let reader = new FileReader()
        reader.onload = function(e) {
            imgbox.attr('src', e.target.result)
            imgbox.height(256)
            imgbox.width(256)
        }
        reader.readAsDataURL(input.files[0])
    }
}
/*
url = "http://localhost:5000/convert"
$('.file-submit').click(function() { 
    console.log("clicked")
    $.ajax({
        url: url,
        type: "POST",
        data: formdata,
        success: function(data) {
            console.log('resp success')
        },
        error: function(error) {
            console.log("Error: ", error)
        } 

    })
  
})*/

const url = "http://127.0.0.1:5001/infer"
$('.file-submit').click(function() {
    console.log("clicked!")
    imgbox = $('#input-image')
    outputbox = $('#output-image')
    input = $('.file-select')[0]
    if(input.files && input.files[0]) {
        let formData = new FormData()
        formData.append('image', input.files[0])
        $.ajax({
            url: url,
            type: 'POST',
            data: formData,
            cache: false,
            processData: false,
            contentType: false,
            error: function(error) {
                console.log("ERROR", error)
                console.log(error.getAllResponseHeaders())
            },
            success: function(data){
                console.log(data)          
                fake_img = data.split('\'')[1]
                
                outputbox.attr('src' , 'data:image/jpeg;base64,'+fake_img)
            }

        })
    }
})