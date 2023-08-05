let uploadInput = $("#uploadInput");
function openAttachMenu(event) {
    event.preventDefault();
    uploadInput.click();
}
let upload_preview_wrapper = $(".uploadPreviewContainer");
let upload_preview = $("#uploadPreview");
let upload_template = $("#uploadPreviewTemplate");

let fileArray = [];
function excludeFile(insertedTick) {
    // Filter out the file with the given lastModified value
    fileArray = fileArray.filter(file => file.insertedTick != insertedTick);
    reload();
}


let reload = function () {
    upload_preview.empty();
    if (fileArray.length == 0) { upload_preview_wrapper.css("border-bottom", "none"); return; }
    upload_preview_wrapper.css("border-bottom", "");
    console.log(fileArray);

    for (const [index, file] of Object.entries(fileArray)) {
        console.log(index);
        console.log(file);
        let upload_ele = upload_template.clone();
        upload_ele.attr("id", "");
        upload_ele.appendTo(upload_preview);
        upload_ele.find("span").text(file.name);

        let insertedTick = new Date().getTime().toString() + file.lastModified.toString();
        insertedTick = btoa(insertedTick);
        console.log(insertedTick);
        file.insertedTick = insertedTick;
        upload_ele.find(".delete_button").attr("onclick", `excludeFile('${insertedTick}')`);
    }
}   

uploadInput.on('change', function (x) {
    console.log("BRAH");
    console.log(uploadInput[0].value);
    fileArray = fileArray.concat(Array.from(uploadInput[0].files));
    reload();
    uploadInput[0].value = null;
});