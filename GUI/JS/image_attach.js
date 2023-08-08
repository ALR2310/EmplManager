let uploadInput = $("#uploadInput");
function openAttachMenu(event) {
    event.preventDefault();
    uploadInput.click();
}
let upload_preview_wrapper = $(".uploadPreviewContainer");
let upload_preview = $("#uploadPreview");
let upload_template = $("#uploadPreviewTemplate");

var fileArray = [];
function excludeFile(insertedTick) {
    // Filter out the file with the given lastModified value
    fileArray = fileArray.filter(file => file.insertedTick != insertedTick);
 
    upload_preview.find(`.filePreview[insertedTick='${insertedTick}']`).remove();
    reload_attached_files();
}
let icon_url = "Images/Icons/";
let icons = {
    code: icon_url + 'code_file.svg',
    default: icon_url + 'blank_file.svg',
    archive: icon_url + 'archive.svg',
    text: icon_url + 'text_file.svg',

}
let file_format_image = {
    [icons.code]: ['svg', 'cpp', 'js', 'py', 'lua', 'java'],
    [icons.archive]: ['7z', 'zip', 'rar'],
    [icons.text]: ['txt', 'log'],
    ["local_image"]: ['jpg','png','gif','apng']


};
console.log(file_format_image);
for (const [url,array] of Object.entries(file_format_image)) {
    for (format of array) {
        file_format_image[format] = url;
    }
    delete file_format_image[url];
}


var reload_attached_files = function () {

    if (fileArray.length == 0) { upload_preview_wrapper.css("border-bottom", "none"); return; }
    upload_preview_wrapper.css("border-bottom", "");
    console.log(fileArray);
    setTimeout(condictionalScrollBottom, 0);
    for (const [index, file] of Object.entries(fileArray)) {

        if (!!file.insertedTick) { continue ; }

    
        let upload_ele = upload_template.clone();
        upload_ele.attr("id", "");
        upload_ele.appendTo(upload_preview);
        upload_ele.find("span").text(file.name);

        let insertedTick = new Date().getTime().toString() + file.lastModified.toString();
        insertedTick = btoa(insertedTick);
     
        file.insertedTick = insertedTick;
        upload_ele.find(".delete_button").attr("onclick", `excludeFile('${insertedTick}')`);
        upload_ele.attr("insertedTick", insertedTick);
        let extension = file.name.split('.');
        if (extension.length != 0) {

            extension = extension[extension.length - 1];
     

            let url = !!file_format_image[extension] ? file_format_image[extension] : icons.default;

            if (url == "local_image") {
                let loading_circle = $(`<div class="upload_loader_show"></div>`);
                var reader = new FileReader();
                reader.onload = function (e) {
                    url = e.target.result;
                    upload_ele.find(".preview_image").css("display", "unset");
                    upload_ele.find(".preview_image").attr("src", url)
                    upload_ele.find(".preview_image_wrapper").css("background", "#e4f3fc");
                    loading_circle.remove();
                };




            
                upload_ele.find(".preview_image").css("display", "none");
                console.log(loading_circle);
                loading_circle.appendTo(upload_ele);
                reader.readAsDataURL(file);
                continue;
            }
            upload_ele.find(".preview_image").attr("src", url)
        }
   

    }

}   

uploadInput.on('change', function (x) {
    console.log("BRAH");
    console.log(uploadInput[0].value);
    fileArray = fileArray.concat(Array.from(uploadInput[0].files));
    reload_attached_files();
    uploadInput[0].value = null;
});