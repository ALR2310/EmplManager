


//-----------------Ẩn hiện modal delete

var modalDelete = document.querySelector('.UIdetail-modal-delete-overlay');
var modalContent = document.querySelector('.UIdetail-modal-delete');

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


var clearSelect = document.querySelector('#clearCheckbox');

// Thêm sự kiện click vào thẻ <a>
clearSelect.addEventListener('click', function (event) {
    // Ngăn chặn hành vi mặc định của thẻ <a>
    event.preventDefault();

    // Lấy danh sách tất cả các checkbox
    var checkboxes = document.querySelectorAll('.employee-card__header-checkbox');

    // Lặp qua từng checkbox
    checkboxes.forEach(function (checkbox) {
        // Đặt thuộc tính checked của checkbox thành false
        checkbox.checked = false;

        // Lấy phần tử cha employee-body-card
        var employeeBodyCard = checkbox.closest('.employee-body-card');

        // Đặt lại border-color thành mặc định
        employeeBodyCard.classList.remove('checked');
    });
});







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



//------------Hàm thực hiện chức năng xoá tài khoản
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
    }
    else {
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

                if (response.d == true) {
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
                } else {
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
        if (StatusId == 1) {
            showInfoToast("Tài khoản hiện đã được kích hoạt");
        }
        else {
            showInfoToast("Tài khoản hiện đã được vô hiệu hoá");
        }
    }
}





//---------------function xử lý trạng thái
const btnStatus = document.querySelectorAll(".employee-card__header-status");
function handleStatus(status, button) {
    // Xóa tất cả các class hiện có trên button
    button.classList.remove("Active", "noActive");
    button.textContent = "Chưa Kích Hoạt";

    // Thêm class tùy thuộc vào giá trị của trường "Status"
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
            "url": "empolyee.aspx/GetUserIdByJS",
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
        "url": "empolyee.aspx/GetUserIdByJS",
        "data": JSON.stringify(UserId),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            var empolyeeInfo = JSON.parse(response.d);

            if (empolyeeInfo != null) {
                showModal();

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

