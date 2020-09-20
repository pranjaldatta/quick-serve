var base64 = "xxx"

function ShowAndHide() {
    var x = document.getElementById('dragsection');
    if (x.style.display == 'none') {
        x.style.display = 'block';

    } else {
        x.style.display = 'none';
    }
}


document.querySelectorAll(".drop-zone__input").forEach((inputElement) => {
    const dropZoneElement = inputElement.closest(".drop-zone");

    dropZoneElement.addEventListener("click", (e) => {
        inputElement.click();
    });

    inputElement.addEventListener("change", (e) => {
        if (inputElement.files.length) {
            updateThumbnail(dropZoneElement, inputElement.files[0]);
        }
    });

    dropZoneElement.addEventListener("dragover", (e) => {
        e.preventDefault();
        dropZoneElement.classList.add("drop-zone--over");
    });

    ["dragleave", "dragend"].forEach((type) => {
        dropZoneElement.addEventListener(type, (e) => {
            dropZoneElement.classList.remove("drop-zone--over");
        });
    });

    dropZoneElement.addEventListener("drop", (e) => {
        e.preventDefault();

        if (e.dataTransfer.files.length) {
            inputElement.files = e.dataTransfer.files;
            updateThumbnail(dropZoneElement, e.dataTransfer.files[0]);
            g
        }

        dropZoneElement.classList.remove("drop-zone--over");
    });
});

/**
 * 
 *
 * @param {HTMLElement} dropZoneElement
 * @param {File} file
 */
function updateThumbnail(dropZoneElement, file) {
    let thumbnailElement = dropZoneElement.querySelector(".drop-zone__thumb");

 
    if (dropZoneElement.querySelector(".drop-zone__prompt")) {
        dropZoneElement.querySelector(".drop-zone__prompt").remove();
    }

  
    if (!thumbnailElement) {
        thumbnailElement = document.createElement("div");
        thumbnailElement.classList.add("drop-zone__thumb");
        dropZoneElement.appendChild(thumbnailElement);
    }

    thumbnailElement.dataset.label = file.name;

    if (file.type.startsWith("image/")) {
        const reader = new FileReader();

        reader.readAsDataURL(file);
        reader.onload = () => {
            //console.log(reader.result)
            thumbnailElement.style.backgroundImage = `url('${reader.result}')`;
        };
    } else {
        thumbnailElement.style.backgroundImage = null;
    }
}

//base64
var handleFileSelect = function(evt) {
    var files = evt.target.files;
    var file = files[0];

    if (files && file) {
        var reader = new FileReader();

        reader.onload = function(readerEvt) {
            var binaryString = readerEvt.target.result;
            base64 = btoa(binaryString)
          
        };

        reader.readAsBinaryString(file);
    }
};

if (window.File && window.FileReader && window.FileList && window.Blob) {
    document.getElementById('inputFileToLoad').addEventListener('change', handleFileSelect, false);
} else {
    alert('The File APIs are not fully supported in this browser.');
}

const url = "http://127.0.0.1:5001/infer"
$("#yellow-btn").click(function(){
    outelem = $("#output-img")
    let formData = new FormData()
    
    formData.append('image', base64)
    for (var key of formData.entries()) {
        console.log(key[0] + ', ' + key[1]);
    }

    $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        cache: false,
        processData: false,
        contentType: false,
        error: function(err) {
            console.log("oops!: ", err)
        },
        success: function(data) {
            console.log("b64 successfully received!")
            data = data.split('\'')[1]
            outelem.attr("class", "")
            outelem.attr("src", 'data:image/jpeg;base64,'+data)
        }
    })
})