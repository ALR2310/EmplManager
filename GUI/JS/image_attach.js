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
var icons = {
    code: icon_url + 'code_file.svg',
    default: icon_url + 'blank_file.svg',
    archive: icon_url + 'archive.svg',
    text: icon_url + 'text_file.svg',

}
let file_format_image = {
    [icons.code]: ['svg', 'cpp', 'js', 'py', 'lua', 'java'],
    [icons.archive]: ['7z', 'zip', 'rar'],
    [icons.text]: ['txt', 'log'],
    ["local_image"]: ['jpg','png','gif','apng','jfif','jpeg'],
    ["local_video"]: ['mp4', 'mov', 'wmv', 'webm', 'avi', 'flv', 'mkv']

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

            if (url == "local_image" || url == "local_video") {
                let loading_circle = $(`<div class="upload_loader_show"></div>`);
                var reader = new FileReader();
                let preview_image = upload_ele.find(".preview_image");
                if (url == "local_video") {

                    preview_image.replaceWith("<video class='preview_image'/>");
           
                    preview_image = upload_ele.find(".preview_image");
   
                }

            
                reader.onload = function (e) {
               
                    let src_url = e.target.result;
                    preview_image.attr("src", src_url)
               
                    preview_image.css("display", "unset");

                    preview_image.css("background", "#e4f3fc");
                    preview_image.on("load resize", function () {
                        if (url == "local_video") {
                            upload_ele.find(".preview_play_button").css("visibility", "unset");
                        }
                        loading_circle.remove();
                    });
                     
                };




            
                preview_image.css("display", "none");

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
    console.log(uploadInput[0].files);
    fileArray = fileArray.concat(Array.from(uploadInput[0].files));
    reload_attached_files();
    uploadInput[0].value = null;
});

let DragDropMenu = $("#DragDropMenu").appendTo("body");




let hide_timeout;

$(document).on('dragover', (event) => {

    event.preventDefault();

    DragDropMenu.addClass('drag_drop_menu_visible');
    DragDropMenu.removeClass('drag_drop_menu_invisible');
    if (!!hide_timeout) {
        clearTimeout(hide_timeout);
    }
    hide_timeout = setTimeout(function () {
        if (!hasClass("drag_drop_menu_visible")) return;
        DragDropMenu.removeClass('drag_drop_menu_visible');
        DragDropMenu.addClass('drag_drop_menu_invisible');


    }, 150);
   
});


$(document).on('drop', (e) => {
    DragDropMenu.removeClass('drag_drop_menu_visible');
    DragDropMenu.removeClass('drag_drop_menu_invisible');
    fileArray = fileArray.concat(Array.from(e.originalEvent.dataTransfer.files));
    reload_attached_files();
    e.preventDefault();
});


let EditFileMenu = $("#EditFileMenu").appendTo("body");
