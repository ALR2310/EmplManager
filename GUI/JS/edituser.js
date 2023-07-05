// Lắng nghe sự kiện khi người dùng chọn ảnh
document.getElementById('file-upload').addEventListener('change', function (event) {
    var file = event.target.files[0];

    // Kiểm tra nếu file là hình ảnh
    if (file && file.type.startsWith('image/')) {
        var reader = new FileReader();

        // Đọc file và hiển thị hình ảnh trước
        reader.onload = function () {
            var imgPreview = document.createElement('img');
            imgPreview.src = reader.result;
            imgPreview.style.maxWidth = '100%';
            imgPreview.style.maxHeight = '100%';

            // Xóa hình ảnh trước (nếu có)
            var existingImg = document.querySelector('.userInfo-header__img img');
            if (existingImg) {
                existingImg.remove();
            }

            // Thêm hình ảnh mới vào giao diện
            var imgContainer = document.querySelector('.userInfo-header__img');
            imgContainer.appendChild(imgPreview);
        }

        // Đọc nội dung của file như là một URL dữ liệu
        reader.readAsDataURL(file);
    }
});