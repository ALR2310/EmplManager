
//Js đóng mở modal thông báo delete user
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



//Js đóng mở Modal Chi tiết Users
modalOverlay = document.querySelector('.modal-vertical__overlay');

modalOverlay.addEventListener('click', function () {
    hidenModal();
});

function hidenModal(event) {
    var modalVertical = document.querySelector('.modal-vertical');
    console.log(event.target);

    setTimeout(function () {
        modalVertical.classList.add('hide');
    }, 500);

    modalVertical.querySelector('.modal-vertical__overlay').style.transform = 'translateX(-100%)';
    modalVertical.querySelector('.modal-vertical__container').style.transform = 'translateX(100%)';
}

function showModal() {
    var modalVertical = document.querySelector('.modal-vertical');

    modalVertical.classList.remove('hide');

    modalVertical.querySelector('.modal-vertical__overlay').style.transform = 'translateX(0%)';
    modalVertical.querySelector('.modal-vertical__container').style.transform = 'translateX(0%)';

}


//Js đóng mở Ellipsis
function employeeShowEllipsis(event, str) {
    var ellipsis_card = event.target.parentNode.querySelector('.employee-card__ellipsis')

    if (!ellipsis_card) {
        return;
    }

    ellipsis_card.style.display = str;
}



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




// Lấy thẻ <a> bỏ chọn tất cả
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