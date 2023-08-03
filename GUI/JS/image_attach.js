let uploadInput = $("#uploadInput");
function openAttachMenu(event) {
    event.preventDefault();
    uploadInput.click();
}

uploadInput.on('change', function (e) {
    console.log(uploadInput);
    console.log(uploadInput[0].files);
});