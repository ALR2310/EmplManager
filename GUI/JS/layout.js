//js gọi phương thức searchclick
function handleSearchClick(event) {
    var searchClick = document.getElementById('<%= btnSearch.ClientID %>') //Id của nút btnSearch
    searchClick.click();
}

//js mở đóng sidebar
var sidebar = document.querySelector(".sidebar");
var btnMenuLeft = document.querySelector(".btn-menuleft");
var spanSidebarList = document.querySelectorAll(".sidebar-item__link span");
var clickCount = 0;
btnMenuLeft.addEventListener("click", function () {
    sidebar.classList.toggle("sidebar-close");
    clickCount++;
    if (clickCount % 2 === 1) {
        setTimeout(function () {
            for (var i = 0; i < spanSidebarList.length; i++) {
                spanSidebarList[i].classList.remove("hide");
            }
        }, 500);
    } else {
        for (var i = 0; i < spanSidebarList.length; i++) {
            spanSidebarList[i].classList.add("hide");
        }
    }
});

$(".speech").parent().addClass("contains_speech");


const parts = window.location.href.split('/');
var page = parts[parts.length - 1];
var elem = $(`.sidebar-item__link[href='${page}']`);
elem.addClass("active");
