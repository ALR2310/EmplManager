//Hiển thị div chứa btnSave, btnCancel và ẩn btnEdit
function handleShowEditUser(element) {
    element.classList.add('hide');

    var divBtnEditUser = document.querySelector('.userInfor-body-title-action');
    divBtnEditUser.classList.remove('hide');

    handleToggleInputEdit('show');
    bindingdatafromlbltoedit();
}

//Hiển thị btnEdit và ẩn div chứa btnSave, btnCancel 
function handleHideEditUser() {
    var divBtnEditUser = document.querySelector('.userInfor-body-title-action');
    divBtnEditUser.classList.add('hide');

    var btnEdit = document.getElementById('btnEdit');
    btnEdit.classList.remove('hide');

    handleToggleInputEdit('hide')
}

//Hiển thị các InputEdit
function handleToggleInputEdit(action) {
    var inputEdit = document.querySelectorAll(".userInfor-body-desc input");
    var selectEdit = document.querySelectorAll(".userInfor-body-desc select");
    var divInforStatus = document.querySelector("#divInforStatus");
    var divUploadImg = document.querySelector("#divUploadImg");


    if (action == 'show') {
        inputEdit.forEach((input) => {
            input.classList.remove('hide');
        });

        selectEdit.forEach((select) => {
            select.classList.remove('hide');
        })

        $('#lblDisplayName').addClass('hide');
        $('#lblPhoneNumber').addClass('hide');
        $('#lblEmail').addClass('hide');
        $('#lblDateJoin').addClass('hide');
        $('#lblJob').addClass('hide');
        $('#lblDepartment').addClass('hide');
        $('#lblGender').addClass('hide');
        $('#lblDateOfBirth').addClass('hide');
        $('#lblAddress').addClass('hide');

        divInforStatus.classList.add('hide');
        divUploadImg.classList.remove('hide');

    } else if (action == 'hide') {
        inputEdit.forEach((input) => {
            input.classList.add('hide');
        });

        selectEdit.forEach((select) => {
            select.classList.add('hide');
        })

        $('#lblDisplayName').removeClass('hide');
        $('#lblPhoneNumber').removeClass('hide');
        $('#lblEmail').removeClass('hide');
        $('#lblDateJoin').removeClass('hide');
        $('#lblJob').removeClass('hide');
        $('#lblDepartment').removeClass('hide');
        $('#lblGender').removeClass('hide');
        $('#lblDateOfBirth').removeClass('hide');
        $('#lblAddress').removeClass('hide');

        divInforStatus.classList.remove('hide');
        divUploadImg.classList.add('hide');
    }
}


//đưa dữ liệu từ lable lên input
function bindingdatafromlbltoedit() {
    $('#tblDisplayName').val($('#lblDisplayName').text());
    $('#tblPhoneNumber').val($('#lblPhoneNumber').text());
    $('#tblEmail').val($('#lblEmail').text());
    $('#tblDateJoin').val($('#lblDateJoin').text().split("/").reverse().join("-"));
    $('#tblJob').val($('#lblJob').text());
    $('#tblDepartment').val($('#lblDepartment').text());
    $('#tblDateOfBirth').val($('#lblDateOfBirth').text().split("/").reverse().join("-"));
    $('#tblAddress').val($('#lblAddress').text());

    if ($('#lblGender').text() == 'Nam') {
        $('#sltGender').val('male');
    } else {
        $('#sltGender').val('female');
    }
}




function formatDate(dateStr) {
    const date = new Date(dateStr);
    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}