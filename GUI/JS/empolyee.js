



//-----------------Ẩn hiện modal delete

var modalDelete = document.querySelector('.UIdetail-modal-delete-overlay');
var modalContent = document.querySelector('.UIdetail-modal-delete');

handlehideModalDelete();

function handlehideModalDelete() {
    var btndelapply = document.getElementById('btndelapply');
    btndelapply.removeEventListener('click', handlecheckboxsDelete);
    btndelapply.addEventListener('click', handleDeleteUser);
}


function showModalDeleteUser() {
    modalDelete.classList.remove('hide');
    modalDelete.classList.remove('hidden');
}

function hideModalDeleteUser() {
    modalDelete.classList.add('hidden');
    // Sau khi kết thúc animation fadeOutModal, ẩn hoàn toàn modal
    setTimeout(function () {
        modalDelete.classList.add('hide');
    }, 500); // 500ms là thời gian của animation fadeOutModal
}

modalDelete.addEventListener('click', function (event) {
    // Kiểm tra xem sự kiện click có xuất phát từ phần tử cha hay không
    if (event.target === this) {
        hideModalDeleteUser();
    }
});

modalContent.addEventListener('click', function (event) {
    event.stopPropagation(); // Ngăn sự kiện click từ phần tử con lan rộng lên phần tử cha
});









//------------Ẩn hiện modal thông tin chính

modalOverlay = document.querySelector('.modal-vertical__overlay');

modalOverlay.addEventListener('click', function () {
    hidenModal();
    closemodalEmail();
});

function hidenModal(event) {
    var modalVertical = document.querySelector('.modal-vertical');

    handleShowEditorButton(2);    //Reset lại Editor Infor

    setTimeout(function () {
        modalVertical.classList.add('hide');
    }, 0);

    modalVertical.querySelector('.modal-vertical__overlay').style.transform = 'translateX(-100%)';
    modalVertical.querySelector('.modal-vertical__container').style.transform = 'translateX(100%)';
}

function showModal() {
    var modalVertical = document.querySelector('.modal-vertical');

    modalVertical.classList.remove('hide');

    modalVertical.querySelector('.modal-vertical__overlay').style.transform = 'translateX(0%)';
    modalVertical.querySelector('.modal-vertical__container').style.transform = 'translateX(0%)';

}





function employeeShowEllipsis(event, str) {
    var ellipsis_card = event.target.parentNode.querySelector('.employee-card__ellipsis')

    if (!ellipsis_card) {
        return;
    }

    ellipsis_card.style.display = str;
}










//-------------Bỏ chọn các Checkbox

// Lấy danh sách tất cả các checkbox
var checkboxes = document.querySelectorAll('.employee-card__header-checkbox');

// Lặp qua từng checkbox
checkboxes.forEach(function (checkbox) {
    // Thêm sự kiện change vào mỗi checkbox
    checkbox.addEventListener('change', function () {
        // Lấy phần tử cha employee-body-card
        var employeeBodyCard = this.closest('.employee-body-card');

        // Kiểm tra trạng thái checkbox
        if (this.checked) {
            // Nếu checkbox được chọn, thêm lớp CSS 'checked' vào employee-body-card
            employeeBodyCard.classList.add('checked');
        } else {
            // Nếu checkbox không được chọn, xóa lớp CSS 'checked' khỏi employee-body-card
            employeeBodyCard.classList.remove('checked');
        }
    });
});


function clearCheckboxes() {
    /*event.preventDefault();*/
    var checkboxes = document.querySelectorAll('.employee-card__header-checkbox');
    checkboxes.forEach(function (checkbox) {
        checkbox.checked = false;

        var employeeBodyCard = checkbox.closest('.employee-body-card');
        employeeBodyCard.classList.remove('checked');

        $("#lblcountselected").text(0);

    });
}






//-------------Hàm định dạng lại ngày thành chuỗi "dd/MM/yyyy"
function formatDate(dateStr) {
    const date = new Date(dateStr);
    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}






//----------Hàm thực hiện chức năng ẩn usercard khi đã xoá
function handleHideUserCard() {
    var userCard = document.querySelectorAll(".employee-body-card")
    var id = $("#lblUserId").text();

    userCard.forEach((UserCardId) => {
        const getId = UserCardId.getAttribute("commandargument");

        if (getId == id) {
            UserCardId.classList.add("hide");
            UserCardId.setAttribute("commandargument", "-9999")
        }
    });
}



//------------Hàm thực hiện chức năng xoá tài khoản.
function handleDeleteUser() {
    var id = $("#lblUserId").text();
    var data = {
        "UserId": id
    };

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/DeleteUser",
        "data": JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == true) {
                hideModalDeleteUser();
                hidenModal();
                handleHideUserCard();
                showSuccessToast("Bạn đã xoá tài khoản này thành công");
                //Đặt lại số lượng tài khoản sau khi xoá
                $.ajax({
                    type: "POST",
                    "url": "empolyee.aspx/GetCountEmpolyee",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var countEmpolyee = document.getElementById('ContentPlaceHolder1_lblCountEmpolyee');
                        countEmpolyee.textContent = response.d;
                    },
                    error: function (err) {
                        console.log(err);
                    }
                });
            } else {
                showWarningToast("Xoá tài khoản thất bại");
            }
        },
        error: function (err) {
            console.log(err)
        }
    })
}






//------------thay đổi status với statusid truyền vào
function changestatusbystsid(statusid) {
    var id = $("#lblUserId").text();
    const CardId = document.querySelectorAll("#btnStatus");
    var UserCard = document.querySelectorAll(".employee-body-card");

    if (statusid == 0) {
        $("#lblStatus").text("Chưa Kích Hoạt");
        CardId.forEach((usersIdCard) => {
            const getId = usersIdCard.getAttribute("empolyeecardid");
            if (getId == id) {
                usersIdCard.setAttribute("commandargument", 0);
                const statusgetid = usersIdCard.getAttribute("commandargument");
                handleStatus(statusgetid, usersIdCard);
            }
        });
        UserCard.forEach((UserCardId) => {
            const idCard = UserCardId.getAttribute("commandargument");
            if (id == idCard) {
                UserCardId.setAttribute("isdrop", 0);
            }
        });
    } else if (statusid == 1) {
        $("#lblStatus").text("Đã Kích Hoạt");
        CardId.forEach((usersIdCard) => {
            const getId = usersIdCard.getAttribute("empolyeecardid");
            if (getId == id) {
                usersIdCard.setAttribute("commandargument", 1);
                const statusgetid = usersIdCard.getAttribute("commandargument");
                handleStatus(statusgetid, usersIdCard);
            }
        });
        UserCard.forEach((UserCardId) => {
            const idCard = UserCardId.getAttribute("commandargument");
            if (id == idCard) {
                UserCardId.setAttribute("isdrop", 1);
            }
        });
    } else if (statusid == 2) {
        $("#lblStatus").text("Vô Hiệu Hoá");
        CardId.forEach((usersIdCard) => {
            const getId = usersIdCard.getAttribute("empolyeecardid");
            if (getId == id) {
                usersIdCard.setAttribute("commandargument", 2);
                const statusgetid = usersIdCard.getAttribute("commandargument");
                handleStatus(statusgetid, usersIdCard);
            }
        });
        UserCard.forEach((UserCardId) => {
            const idCard = UserCardId.getAttribute("commandargument");
            if (id == idCard) {
                UserCardId.setAttribute("isdrop", 2);
            }
        });
    }
}






//------------Hàm thực hiện chức năng thay đổi Status 
function handleToggleStatusClick(StatusId) {
    var id = $("#lblUserId").text();
    var data = {
        "UserId": id,
        "StatusId": StatusId
    };

    var checkstatus = $("#lblStatus").text();
    var convertstatustoid;
    if (checkstatus == "Đã Kích Hoạt") {
        convertstatustoid = 1;
    } else if (checkstatus == "Chưa Kích Hoạt") {
        convertstatustoid = 0;
    }
    else if (checkstatus == "Vô Hiệu Hoá") {
        convertstatustoid = 2;
    }

    if (convertstatustoid != StatusId) {
        $.ajax({
            type: "POST",
            "url": "empolyee.aspx/ChangeStatusUser",
            "data": JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                const CardId = document.querySelectorAll("#btnStatus");
                var isStatus = document.querySelector("#userIdinfor");
                var isAvatarImage = document.querySelector("#AvatarImg");
                var UserCard = document.querySelectorAll(".employee-body-card");
                var NoActiveClass = "noActive";
                var ActiveClass = "Active";


                if (response.d == 0) {
                    $("#lblStatus").text("Chưa Kích Hoạt");
                    /*$("#lblStatus").style.color = "green";*/
                    isStatus.textContent = "Chưa Kích Hoạt";
                    isStatus.classList.remove(ActiveClass);
                    isStatus.classList.remove(NoActiveClass);

                    isAvatarImage.classList.remove(ActiveClass);
                    isAvatarImage.classList.remove(NoActiveClass);
                    showSuccessToast("Đã Huỷ kích hoạt tài khoản thành công!");

                    CardId.forEach((usersIdCard) => {
                        const getId = usersIdCard.getAttribute("empolyeecardid");
                        if (getId == id) {
                            usersIdCard.setAttribute("commandargument", 0);
                            const statusgetid = usersIdCard.getAttribute("commandargument");
                            handleStatus(statusgetid, usersIdCard);
                        }
                    });

                    UserCard.forEach((UserCardId) => {
                        const idCard = UserCardId.getAttribute("commandargument");

                        if (id == idCard) {
                            UserCardId.setAttribute("isdrop", StatusId);
                        }
                    });

                } else if (response.d == 1) {
                    $("#lblStatus").text("Đã Kích Hoạt");
                    /*$("#lblStatus").style.color = "green";*/
                    isStatus.textContent = "Đã Kích Hoạt";
                    isStatus.classList.add(ActiveClass);
                    isStatus.classList.remove(NoActiveClass);

                    isAvatarImage.classList.add(ActiveClass);
                    isAvatarImage.classList.remove(NoActiveClass);
                    showSuccessToast("Đã kích hoạt tài khoản thành công!");

                    CardId.forEach((usersIdCard) => {
                        const getId = usersIdCard.getAttribute("empolyeecardid");
                        if (getId == id) {
                            usersIdCard.setAttribute("commandargument", 1);
                            const statusgetid = usersIdCard.getAttribute("commandargument");
                            handleStatus(statusgetid, usersIdCard);
                        }
                    });

                    UserCard.forEach((UserCardId) => {
                        const idCard = UserCardId.getAttribute("commandargument");

                        if (id == idCard) {
                            UserCardId.setAttribute("isdrop", StatusId);
                        }
                    });
                } else if (response.d == 2) {
                    $("#lblStatus").text("Vô Hiệu Hoá");
                    /*$("#lblStatus").style.color = "red";*/

                    isStatus.textContent = "Vô Hiệu Hoá";
                    isStatus.classList.add(NoActiveClass);
                    isStatus.classList.remove(ActiveClass);

                    isAvatarImage.classList.add(NoActiveClass);
                    isAvatarImage.classList.remove(ActiveClass);
                    showSuccessToast("Đã vô hiệu hoá tài khoản thành công");

                    CardId.forEach((usersIdCard) => {
                        const getId = usersIdCard.getAttribute("empolyeecardid");

                        if (getId == id) {
                            usersIdCard.setAttribute("commandargument", 2);
                            const statusgetid = usersIdCard.getAttribute("commandargument");
                            handleStatus(statusgetid, usersIdCard);
                        }
                    });

                    UserCard.forEach((UserCardId) => {
                        const idCard = UserCardId.getAttribute("commandargument");

                        if (id == idCard) {
                            UserCardId.setAttribute("isdrop", StatusId);
                        }
                    });
                }
            },
            error: function (error) {
                console.log(error);
            }
        })
    }
    else {
        if (StatusId == 0) {
            showInfoToast("Tài khoản hiện chưa kích hoạt");
        } else if (StatusId == 1) {
            showInfoToast("Tài khoản hiện đã được kích hoạt");
        } else if (StatusId == 2) {
            showInfoToast("Tài khoản hiện đã được vô hiệu hoá");
        }
    }
}




//---------function đếm số lượng chekbox được chọn
function countCheckboxSelection() {
    const checkboxes = document.querySelectorAll('.employee-card__header-checkbox');
    const countSelectedSpan = document.getElementById('lblcountselected');

    let countSelected = 0;

    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            countSelected++;
        }
    });

    countSelectedSpan.textContent = countSelected.toString();

    handleGetEmailForCheckboxes();
}




//------clear click xoá 1 thêm click xoá nhiều
function handleDelMoreUsr() {
    var btndelapply = document.getElementById('btndelapply');
    btndelapply.removeEventListener('click', handleDeleteUser);
    btndelapply.addEventListener('click', handlecheckboxsDelete)
}





//--------------function xoá tài khoản đã selected
function handlecheckboxsDelete() {
    const usridArray = [];
    const checkboxes = document.querySelectorAll(".employee-card__header-checkbox");

    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) { usridArray.push(checkbox.getAttribute('usrid')); }
    });

    if (usridArray.length != 0) {
        handleDeleteUserSeleted(usridArray);
        hideModalDeleteUser();
        $("#lblcountselected").text(0);
        clearCheckboxes();

        var userCards = document.querySelectorAll(".employee-body-card")
        userCards.forEach((usercard) => {
            const getId = usercard.getAttribute("commandargument");

            if (usridArray.includes(getId)) {
                usercard.classList.add("hide");
                usercard.setAttribute("commandargument", "-9999");
            }
        });
    } else {
        showWarningToast("Chưa Có Người Dùng Nào Được Chọn, Vui Lòng Thử Lại")
    }
}





//------------Xoá các users được chọn
function handleDeleteUserSeleted(usridArray) {
    var data = { "userIdarr": usridArray }

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/DeleteAllUserSelect",
        "data": JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == true) {
                showSuccessToast("Đã Xoá Tài Khoản Này Thành Công");
            } else {
                showErrorToast("Có Lỗi Xảy Ra, Vui Lòng Thử Lại");
            }
        },
        error: function (err) {
            console.log("Đã có lỗi xảy ra: " + err);
        }
    })
}





//----------function thay đổi status bằng checkbox
function handleChangeStatusForCheckboxes(statusId) {
    const usridArray = [];
    const checkboxes = document.querySelectorAll('.employee-card__header-checkbox');

    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            usridArray.push(checkbox.getAttribute('usrid'));
        }
    });

    if (usridArray.length != 0) {
        handleChangeStatusSelected(statusId, usridArray);

        var btnStatus = document.querySelectorAll("#btnStatus");

        btnStatus.forEach((btnStatusCard) => {
            const id = btnStatusCard.getAttribute("empolyeecardid");

            if (usridArray.includes(id)) {
                if (statusId == 1) {
                    btnStatusCard.textContent = "Đã Kích Hoạt";
                    btnStatusCard.classList.add("Active");
                    btnStatusCard.classList.remove("noActive");
                    btnStatusCard.setAttribute("commandargument", 1);
                } else if (statusId == 2) {
                    btnStatusCard.textContent = "Vô Hiệu Hoá";
                    btnStatusCard.classList.add("noActive");
                    btnStatusCard.classList.remove("Active");
                    btnStatusCard.setAttribute("commandargument", 2);
                }
            }
        });
    } else {
        showWarningToast("Chưa Có Người Dùng Nào Được Chọn, Vui Lòng Thử Lại");
    }
}





//----------Thay đổi Status tất cả user được selected
function handleChangeStatusSelected(statusid, usridArray) {
    var data = {
        "status": statusid,
        "userIdarr": usridArray
    }
    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/ChangeStatusAllSelectUser",
        "data": JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            if (response.d == 1) {
                showSuccessToast("Đã Kích Hoạt Tài Khoản Thành Công");
            } else if (response.d == 2) {
                showSuccessToast("Đã Vô Hiệu Tài Khoản Thành Công");
            }

        },
        error: function (err) {
            console.log(err);
        }
    })
}








//---------------function xử lý trạng thái
const btnStatus = document.querySelectorAll(".employee-card__header-status");
function handleStatus(status, button) {
    // Xóa tất cả các class hiện có trên button
    button.classList.remove("Active", "noActive");
    button.textContent = "Chưa Kích Hoạt";

    // Thêm class tùy thuộc vào giá trị của trường "Status".
    if (status === "1") {
        button.textContent = "Đã Kích Hoạt";
        button.classList.add("Active");
        button.classList.remove("noActive");
    } else if (status === "2") {
        button.textContent = "Vô Hiệu Hoá";
        button.classList.add("noActive");
        button.classList.remove("Active");
    }
}
btnStatus.forEach((button) => {
    const status = button.getAttribute("commandargument");
    handleStatus(status, button);
});



//-----------Hàm lấy status và thay đổi
function getStatusAndChanges(element) {
    var id = element.getAttribute("commandargument");
    var UserId = { "UserId": id };

    var curentId = $("#lblUserId").text();

    if (curentId != id) {

        $.ajax({
            type: "POST",
            "url": "empolyee.aspx/GetDataForEmpolyee",
            "data": JSON.stringify(UserId),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var empolyeeInfo = JSON.parse(response.d);

                if (empolyeeInfo != null) {
                    var isStatus = document.querySelector("#userIdinfor");
                    var NoActiveClass = "noActive";
                    var ActiveClass = "Active";
                    var status = empolyeeInfo.Status;

                    $("#lblUserId").text(empolyeeInfo.Id);

                    switch (status) {
                        case 0:
                            $("#lblStatus").text("Chưa Kích Hoạt");
                            isStatus.textContent = "Chưa Kích Hoạt";
                            isStatus.classList.remove(ActiveClass);
                            isStatus.classList.remove(NoActiveClass);
                            break;
                        case 1:
                            $("#lblStatus").text("Đã Kích Hoạt");
                            isStatus.textContent = "Đã Kích Hoạt";
                            isStatus.classList.add(ActiveClass);
                            isStatus.classList.remove(NoActiveClass);
                            break;
                        case 2:
                            $("#lblStatus").text("Vô Hiệu Hoá");
                            isStatus.textContent = "Vô Hiệu Hoá";
                            isStatus.classList.add(NoActiveClass);
                            isStatus.classList.remove(ActiveClass);
                            break;
                    }
                }
            },
            error: function (error) {
                console.log(error)
            }
        })
    }


}


//-------------Hàm thực hiện chức năng binding dữ liệu
function getDataforClickShow(element) {
    var id = element.getAttribute("commandargument");
    var UserId = { "UserId": id };

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/GetDataForEmpolyee",
        "data": JSON.stringify(UserId),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var empolyeeInfo = JSON.parse(response.d);

            if (empolyeeInfo != null) {
                showModal();
                $("#lblUserId").text(empolyeeInfo.Id);
                $("#lblGoogleId").text(empolyeeInfo.GoogleId);
                $("#AvatarImg").attr("src", empolyeeInfo.Avatar);
                $("#lblDisplayName").text(empolyeeInfo.DisplayName);
                $("#lblDisplayName1").text(empolyeeInfo.DisplayName);
                $("#lblJob").text(empolyeeInfo.Job);
                $("#lblJob1").text(empolyeeInfo.Job);
                $("#lblPhoneNumber").text(empolyeeInfo.PhoneNumber);
                $("#lblDepartment").text(empolyeeInfo.Department);
                $("#lblEmail").text(empolyeeInfo.Email);
                $("#lblDateOfBirth").text(formatDate(empolyeeInfo.DateOfBirth));
                $("#lblDateJoin").text(formatDate(empolyeeInfo.AtCreate));
                $("#lblGender").text(empolyeeInfo.Gender);
                $("#lblAddress").text(empolyeeInfo.Address);

                console.log(empolyeeInfo)

                //if (empolyeeInfo.PhoneNumber == null || "") { $("#lblPhoneNumber").text("Không có thông tin"); $("#lblPhoneNumber").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblPhoneNumber").css("color", "black") };
                //if (empolyeeInfo.Job == null || "") { $("#lblJob1").text("Không có thông tin"); $("#lblJob1").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblJob1").css("color", "black") };
                //if (empolyeeInfo.Department == null || "") { $("#lblDepartment").text("Không có thông tin"); $("#lblDepartment").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblDepartment").css("color", "black") };
                //if (empolyeeInfo.Gender == null || "") { $("#lblGender").text("Không có thông tin"); $("#lblGender").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblGender").css("color", "black") };
                //if (empolyeeInfo.DateOfBirth == "0001-01-01T00:00:00") { $("#lblDateOfBirth").text("Không có thông tin"); $("#lblDateOfBirth").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblDateOfBirth").css("color", "black") };
                //if (empolyeeInfo.Address == null || "") { $("#lblAddress").text("Không có thông tin"); $("#lblAddress").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblAddress").css("color", "black") };
                //if (empolyeeInfo.GoogleId == null || "") { $("#lblGoogleId").text("Không có thông tin"); $("#lblGoogleId").css("color", "rgb(118, 118, 118)") }
                //else { $("#lblGoogleId").css("color", "black") };

                const propertiesToCheck = [
                    { property: empolyeeInfo.PhoneNumber, label: "#lblPhoneNumber" },
                    { property: empolyeeInfo.Job, label: "#lblJob1" },
                    { property: empolyeeInfo.Department, label: "#lblDepartment" },
                    { property: empolyeeInfo.Gender, label: "#lblGender" },
                    { property: empolyeeInfo.DateOfBirth, label: "#lblDateOfBirth" },
                    { property: empolyeeInfo.Address, label: "#lblAddress" },
                    { property: empolyeeInfo.GoogleId, label: "#lblGoogleId" }
                ];

                propertiesToCheck.forEach(item => {
                    if (item.property == null || item.property === "") {
                        $(item.label).text("Không có thông tin").css("color", "rgb(118, 118, 118)");
                    } else {
                        $(item.label).css("color", "black");
                    }
                });


                var isStatus = document.querySelector("#userIdinfor");
                var isAvatarImage = document.querySelector("#AvatarImg");
                var NoActiveClass = "noActive";
                var ActiveClass = "Active";

                var status = empolyeeInfo.Status;
                switch (status) {
                    case 0:
                        $("#lblStatus").text("Chưa Kích Hoạt");
                        isStatus.textContent = "Chưa Kích Hoạt";
                        isStatus.classList.remove(ActiveClass);
                        isStatus.classList.remove(NoActiveClass);

                        isAvatarImage.classList.remove(ActiveClass);
                        isAvatarImage.classList.remove(NoActiveClass);
                        break;
                    case 1:
                        $("#lblStatus").text("Đã Kích Hoạt");
                        isStatus.textContent = "Đã Kích Hoạt";
                        isStatus.classList.add(ActiveClass);
                        isStatus.classList.remove(NoActiveClass);

                        isAvatarImage.classList.add(ActiveClass);
                        isAvatarImage.classList.remove(NoActiveClass);
                        break;
                    case 2:
                        $("#lblStatus").text("Vô Hiệu Hoá");
                        isStatus.textContent = "Vô Hiệu Hoá";
                        isStatus.classList.add(NoActiveClass);
                        isStatus.classList.remove(ActiveClass);

                        isAvatarImage.classList.add(NoActiveClass);
                        isAvatarImage.classList.remove(ActiveClass);
                        break;
                }

                var userType = empolyeeInfo.UserType;
                switch (userType) {
                    case 0:
                        $("#lblUserType").text("Quản Trị Viên")
                        break;
                    case 1:
                        $("#lblUserType").text("Nhân Viên")
                        break;
                }
            }
        },
        error: function (error) {
            console.log(error)
        }
    })
}







//----------Function xử lý chức năng lọc nhân viên
function handleFilterEmpolyee() {
    const drpElement = document.getElementById('drplist_filterEmpolyee');

    if (drpElement.value == 0) {
        clearfilterEmpolyee();
    } else if (drpElement.value == 1) {
        filterEmpolyee(1);
    } else if (drpElement.value == 2) {
        filterEmpolyee(0);
    } else if (drpElement.value == 3) {
        filterEmpolyee(2);
    } else if (drpElement.value == 4) {
        filterEmpolyeeForUserType(0)
    }
}
function filterEmpolyeeForUserType(usertype) {
    var UserCard = document.querySelectorAll(".employee-body-card");
    UserCard.forEach((UserCardId) => {
        const id = UserCardId.getAttribute("commandargument");
        const userTypeId = UserCardId.getAttribute("usrtype");
        if (userTypeId != usertype) {
            UserCardId.classList.add('hide');
        } else {
            if (id <= 9999) { UserCardId.classList.remove('hide'); };
        }
    });
}

function filterEmpolyee(status) {
    var UserCard = document.querySelectorAll(".employee-body-card");
    UserCard.forEach((UserCardId) => {
        const id = UserCardId.getAttribute("commandargument");
        const statusId = UserCardId.getAttribute("isdrop");
        if (statusId != status) {
            UserCardId.classList.add('hide');
        } else {
            if (id <= 9999) { UserCardId.classList.remove('hide'); };
        }
    });
}

function clearfilterEmpolyee() {
    var UserCard = document.querySelectorAll(".employee-body-card");
    UserCard.forEach((UserCardId) => {
        const id = UserCardId.getAttribute("commandargument");
        var statusId = UserCardId.getAttribute("isdrop");
        if (id <= 9999) { UserCardId.classList.remove('hide'); };
    });
}






//-------------Lấy và đưa dữ liệu lên userinfor 
function handleBindingDataInfor() {
    var id = $("#lblUserId").text();
    var UserId = { "UserId": id };

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/GetDataForEmpolyee",
        "data": JSON.stringify(UserId),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var empolyeeInfo = JSON.parse(response.d);

            if (empolyeeInfo != null) {
                $("#AvatarImg").attr("src", empolyeeInfo.Avatar);
                $("#lblDisplayName").text(empolyeeInfo.DisplayName);
                $("#lblDisplayName1").text(empolyeeInfo.DisplayName);
                $("#lblJob").text(empolyeeInfo.Job);
                $("#lblJob1").text(empolyeeInfo.Job);
                $("#lblPhoneNumber").text(empolyeeInfo.PhoneNumber);
                $("#lblDepartment").text(empolyeeInfo.Department);
                $("#lblEmail").text(empolyeeInfo.Email);
                $("#lblDateOfBirth").text(formatDate(empolyeeInfo.DateOfBirth));
                $("#lblDateJoin").text(formatDate(empolyeeInfo.AtCreate));
                $("#lblGender").text(empolyeeInfo.Gender);
                $("#lblAddress").text(empolyeeInfo.Address);
                $("#lblUserId").text(empolyeeInfo.Id);

                var googleId = empolyeeInfo.GoogleId;
                if (googleId == 0) {
                    $("#lblGoogleId").text("Không Có Thông Tin");
                }

                var isStatus = document.querySelector("#userIdinfor");
                var isAvatarImage = document.querySelector("#AvatarImg");
                var NoActiveClass = "noActive";
                var ActiveClass = "Active";

                var status = empolyeeInfo.Status;
                switch (status) {
                    case 0:
                        $("#lblStatus").text("Chưa Kích Hoạt");
                        isStatus.textContent = "Chưa Kích Hoạt";
                        isStatus.classList.remove(ActiveClass);
                        isStatus.classList.remove(NoActiveClass);

                        isAvatarImage.classList.remove(ActiveClass);
                        isAvatarImage.classList.remove(NoActiveClass);
                        changestatusbystsid(0)
                        break;
                    case 1:
                        $("#lblStatus").text("Đã Kích Hoạt");
                        isStatus.textContent = "Đã Kích Hoạt";
                        isStatus.classList.add(ActiveClass);
                        isStatus.classList.remove(NoActiveClass);

                        isAvatarImage.classList.add(ActiveClass);
                        isAvatarImage.classList.remove(NoActiveClass);
                        changestatusbystsid(1)
                        break;
                    case 2:
                        $("#lblStatus").text("Vô Hiệu Hoá");
                        isStatus.textContent = "Vô Hiệu Hoá";
                        isStatus.classList.add(NoActiveClass);
                        isStatus.classList.remove(ActiveClass);

                        isAvatarImage.classList.add(NoActiveClass);
                        isAvatarImage.classList.remove(ActiveClass);
                        changestatusbystsid(2)
                        break;
                }

                var userType = empolyeeInfo.UserType;
                switch (userType) {
                    case 0:
                        $("#lblUserType").text("Quản Trị Viên")
                        break;
                    case 1:
                        $("#lblUserType").text("Nhân Viên")
                        break;
                }


                var displayName = document.querySelectorAll(".employee-card__body-name h4");
                var job = document.querySelectorAll(".employee-card__body-name p");
                var department = document.querySelectorAll("#department p");
                var datejoin = document.querySelectorAll("#datejoin p");
                var email = document.querySelectorAll("#email");
                var phoneNumber = document.querySelectorAll("#phonenumber");

                displayName.forEach((displayNameCard) => {
                    var idCard = displayNameCard.getAttribute("usrid");
                    if (idCard == id) {
                        displayNameCard.textContent = $("#lblDisplayName1").text();
                    }
                });

                job.forEach((jobCard) => {
                    var idCard = jobCard.getAttribute("usrid");
                    if (idCard == id) {
                        jobCard.textContent = $("#lblJob").text();
                    }
                });

                department.forEach((departmentCard) => {
                    var idCard = departmentCard.getAttribute("usrid");
                    if (idCard == id) {
                        departmentCard.textContent = $("#lblDepartment").text();
                    }
                });

                datejoin.forEach((datejoinCard) => {
                    var idCard = datejoinCard.getAttribute("usrid");
                    if (idCard == id) {
                        datejoinCard.textContent = $("#lblDateJoin").text();
                    }
                });

                email.forEach((emailCard) => {
                    var idCard = emailCard.getAttribute("usrid");
                    if (idCard == id) {
                        emailCard.innerHTML = '<i class="fa-solid fa-envelope"></i> ' + $("#lblEmail").text();
                    }
                });

                phoneNumber.forEach((phoneNumberCard) => {
                    var idCard = phoneNumberCard.getAttribute("usrid");
                    if (idCard == id) {
                        phoneNumberCard.innerHTML = '<i class="fa-solid fa-phone"></i> ' + $("#lblPhoneNumber").text();
                    }
                });
            }
        },
        error: function (error) {
            console.log(error)
        }
    })
}





//----------Cập nhật dữ liệu người dùng
function UpdateInforEmpolyee() {
    var UserId = $("#lblUserId").text();

    var data = {
        userid: UserId,
        displayName: $("#tblDisplayName").val(),
        phoneNumber: $("#tblPhoneNumber").val(),
        email: $("#tblEmail").val(),
        dateJoin: $("#tblDateJoin").val(),
        job: $("#tblJob").val(),
        department: $("#tblDepartment").val(),
        gender: $("#sltGender").val(),
        dateOfBirth: $("#tblDateOfBirth").val(),
        address: $("#tblAddress").val(),
        userType: $("#sltUserType").val(),
        status: $("#sltStatus").val()
    };

    console.log(data)

    $.ajax({
        type: "POST",
        url: "empolyee.aspx/UpdateDataEmpolyee",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify(data),
        success: function (response) {
            if (response.d == true) {
                showSuccessToast("Đã cập nhật dữ liệu cho người dùng này thành công") //Thông báo
                handleShowEditorButton(2) //Đóng trang edit
                handleBindingDataInfor() // binding dữ liệu sau khi cập nhật
            }
        },
        error: function (error) {
            console.log("Có lỗi xảy ra khi cập nhật dữ liệu: " + error);
            showErrorToast("Có lỗi xảy ra khi cập nhật dữ liệu, vui lòng kiểm tra lại");
        }
    });
}







//------------Đưa dữ liệu từ các lable vào textbox
function bindingDataUpDivEditor() {
    $("#lblPhoneNumber").text() != "Không có thông tin" ? $("#tblPhoneNumber").val($("#lblPhoneNumber").text()) : null;
    $("#lblDisplayName1").text() != "Không có thông tin" ? $("#tblDisplayName").val($("#lblDisplayName1").text()) : null;
    $("#lblEmail").text() != "Không Có thông tin" ? $("#tblEmail").val($("#lblEmail").text()) : null;
    $("#lblDateJoin").text() != "Không có thông tin" ? $("#tblDateJoin").val($("#lblDateJoin").text().split("/").reverse().join("-")) : null;
    $("#lblJob1").text() != "Không có thông tin" ? $("#tblJob").val($("#lblJob1").text()) : null;
    $("#lblDepartment").text() != "Không có thông tin" ? $("#tblDepartment").val($("#lblDepartment").text()) : null;
    $("#lblDateOfBirth").text() != "Không có thông tin" ? $("#tblDateOfBirth").val($("#lblDateOfBirth").text().split("/").reverse().join("-")) : null;
    $("#lblAddress").text() != "Không có thông tin" ? $("#tblAddress").val($("#lblAddress").text()) : null;

    //Gender
    $("#lblGender").text() == "Nam" ? $("#sltGender").val("Nam") : $("#lblGender").text() == "Nữ" ? $("#sltGender").val("Nữ") : null;

    //Status
    $("#lblStatus").text() == "Đã Kích Hoạt" ? $("#sltStatus").val(1) : $("#lblStatus").text() == "Chưa Kích Hoạt" ? $("#sltStatus").val(0) : $("#lblStatus").text() == "Vô Hiệu Hoá" ? $("#sltStatus").val(2) : null;

    //UserType
    $("#lblUserType").text() == "Quản Trị Viên" ? $("#sltUserType").val(0) : $("#lblUserType").text() == "Nhân Viên" ? $("#sltUserType").val(1) : null;
}





//--------Clear input fields usriforedit
function handleClearInputFileds() {
    $("#tblPhoneNumber").val('');
    $("#tblDisplayName").val('');
    $("#tblEmail").val('');
    $("#tblDateJoin").val('');
    $("#tblJob").val('');
    $("#tblDepartment").val('');
    $("#tblDateOfBirth").val('');
    $("#tblAddress").val('');
}





//---------ẩn hiện hiển thị các nút chỉnh sửa và cập nhật
function handleShowEditorButton(action) {
    const btndivEdit = document.getElementById("divEdit");
    const btndivSave = document.getElementById("divSave");

    if (action == 1) {
        btndivSave.classList.remove("hide");
        btndivEdit.classList.add("hide");

        handleShowDivEditor("show")
        bindingDataUpDivEditor() //binding dữ liệu
    } else {
        btndivSave.classList.add("hide");
        btndivEdit.classList.remove("hide");

        handleShowDivEditor("hidden")
        handleClearInputFileds()
    }
}







//---------ẩn hiện các khối chứa thẻ lablel và hiển thị các textbox edit
function handleShowDivEditor(action) {
    const divEditor = document.querySelectorAll(".userInfor-Detail__editor")
    const divInfor = document.querySelectorAll(".userInfor-Detail__infor")

    if (action == "show") {
        divEditor.forEach((diveditor) => {
            diveditor.classList.remove("hide");
        });

        divInfor.forEach((divInforEdit) => {
            const enbedit = divInforEdit.getAttribute("enbedit");
            if (enbedit == 1) {
                divInforEdit.classList.add("hide");
            }
        });
    } else if (action == "hidden") {
        divEditor.forEach((diveditor) => {
            diveditor.classList.add("hide");
        });

        divInfor.forEach((divInforEdit) => {
            const enbedit = divInforEdit.getAttribute("enbedit");
            if (enbedit == 1) {
                divInforEdit.classList.remove("hide");
            }
        });
    }
}





//---------CKEditor--------
BalloonEditor
    .create(document.querySelector('#tblEmail_content'))
    .catch(error => {
        console.error(error);
    })








//----------Function kích hoạt đóng mở email modal
function activeEmailModal() {
    const emailModal = document.querySelector(".usrdetail-modal-email");
    emailModal.classList.remove("hide");
    setTimeout(() => {
        emailModal.style.transform = "translateX(0%)";

        const btnShwEmail = document.querySelector("#btnMdEmailshw");
        btnShwEmail.classList.add("hide");

        const btnClsEmail = document.querySelector("#btnMdEmailcls");
        btnClsEmail.classList.remove("hide");
    }, 0);
}
function disableEmailModal() {
    const emailModal = document.querySelector(".usrdetail-modal-email");
    emailModal.style.transform = "translateX(-100%)";
    setTimeout(() => {
        emailModal.classList.add("hide");
    }, 450);
    $("#tblEmail_recipients").val("");
    $("#tblEmail_subject").val("");
    $("#tblEmail_content p").text("");
}
function showEmailModal(event) {
    const emailModal = document.querySelector(".usrdetail-modal-email");
    emailModal.style.transform = "translateX(0%)";
    event.classList.add("hide");

    const btnClsEmail = document.querySelector("#btnMdEmailcls");
    btnClsEmail.classList.remove("hide");
}
function closeEmailModal(event) {
    const emailModal = document.querySelector(".usrdetail-modal-email");
    emailModal.style.transform = "translateX(-100%)";
    event.classList.add("hide");

    const btnShwEmail = document.querySelector("#btnMdEmailshw");
    btnShwEmail.classList.remove("hide");
}

function closemodalEmail() {
    const emailModal = document.querySelector(".usrdetail-modal-email");
    emailModal.style.transform = "translateX(-100%)";

    const btnShwEmail = document.querySelector("#btnMdEmailshw");
    btnShwEmail.classList.remove("hide");

    const btnClsEmail = document.querySelector("#btnMdEmailcls");
    btnClsEmail.classList.add("hide");
}






//---------function gửi Email
function SendEmail() {
    const drpdwnEmailAction = document.getElementById("email_action");

    var recipients;
    var ccRecipients;
    var bccRecipients;

    if (drpdwnEmailAction.value == "To") {
        recipients = $("#tblEmail_recipients").val().split(",");
        ccRecipients = null
        bccRecipients = null
    } else if (drpdwnEmailAction.value == "CC") {
        ccRecipients = $("#tblEmail_recipients").val().split(",");
        bccRecipients = null
        recipients = null
    } else if (drpdwnEmailAction.value == "BCC") {
        bccRecipients = $("#tblEmail_recipients").val().split(",");
        ccRecipients = null
        recipients = null
    }

    var data = {
        "recipients": recipients,
        "subject": $("#tblEmail_subject").val(),
        "content": $("#tblEmail_content").html(),
        "ccRecipients": ccRecipients,
        "bccRecipients": bccRecipients,
    }

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/SendEmail",
        "data": JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            showSuccessToast("Đã Gửi Email Thành Công");
        },
        error: function (err) {
            console.log("Đã có lỗi xảy ra: " + err);
        }
    });
}






//-----------chọn các checkbox và gửi Email
// Tạo một mảng để lưu trữ thông tin các mục được chọn
var selectedEmails = [];

// Hàm xử lý sự kiện thay đổi của checkbox
function handleGetEmailForCheckboxes() {

    selectedEmails = []; // Xóa mảng khi có sự thay đổi
    var checkboxes = document.querySelectorAll('.employee-card__header-checkbox');

    checkboxes.forEach(function (checkbox) {
        if (checkbox.checked) {
            var usrid = checkbox.getAttribute('usrid');
            var emailElement = document.querySelector('p[id="email"][usrid="' + usrid + '"]');
            var email = emailElement.textContent.trim(); // Xóa khoảng trắng thừa
            selectedEmails.push(email);
        }
    });

    // Cập nhật giá trị của thẻ input
    $("#tblEmail_recipients").val(selectedEmails.join(', '));
}





//------Lấy email hiện tại của modalinfor
function getEmailCurrentUserInfor() {
    var emailSpan = $("#lblEmail").text();
    var emailInput = $("#tblEmail_recipients").val();
    if (emailSpan != emailInput) {
        $("#tblEmail_recipients").val(emailSpan);
    }
}





//--------kiểm tra job trên usercard
function checkJobInUserCard() {
    var lblJobs = document.querySelectorAll(".employee-card__body-name p");

    lblJobs.forEach((job) => {
        if (job.textContent == null || job.textContent == "") {
            job.textContent = "Chưa Phân Công";
            console.log("đã thay thế")
        }
    });
}

checkJobInUserCard();




//---------Quay lại trang trước đó
function goBack() {
    window.history.back();
}




//--------Function kiểm tra quyền của người dùng
function checkCurrentUserType() {
    var data = {
        Id: $("#ContentPlaceHolder1_lblCurrentId").text(),
    }

    $.ajax({
        type: "POST",
        "url": "empolyee.aspx/CheckCurrentUserType",
        "data": JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var ModalCheckUser = document.querySelector(".ModalCheckUser");
            if (response.d == true) {
                console.log("Tài khoản này có quyền");
                ModalCheckUser.classList.add("hide");
            } else {
                console.log("Tài khoản này không có quyền")
                ModalCheckUser.classList.remove("hide");
            }
        },
        error: function (err) {
            console.log(err)
        }
    })
}
checkCurrentUserType()