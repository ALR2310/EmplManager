"use strict";
const date_select = $("#date_select");
let rendered_last_date;
let active_date;
function getFirstDayOfMonth(input_date) {
    let d = input_date || new Date();
    d.setDate(1)
   
    return [d.getDate(), d.getDay() + 1, d];
}

const navigateDate = function(input_date) {
    let today_str = (new Date()).toDateString();
    let month = input_date.getMonth();
    let year = input_date.getFullYear();
    $("#month_year").text(`Tháng ${month + 1} Năm ${year}`);
 
    if (rendered_last_date != null && rendered_last_date.getMonth() == month && rendered_last_date.getYear() == year) {

        return;
    }
    else {
        rendered_last_date = new Date(input_date.getTime());
    }

    const [day, date, fulldate] = getFirstDayOfMonth(input_date);




    let day_offset = 6 - (7 - fulldate.getDay());
    console.log(day_offset);
    day_offset = day_offset >= 0 ? day_offset : 6;
    fulldate.setDate(fulldate.getDate() - day_offset);

    var darken = day_offset > 0;
    let last_indexed_date = null;
    date_select.empty();
    for (let i = 1; i <= 6 * 7; i++) {

    

        let day = fulldate.getDate();

        const copied_Date = new Date(fulldate.getTime());



        if (last_indexed_date) {
      
            darken = day - last_indexed_date > 0 ? darken : !darken;
         
        }
        let today_hr = today_str == copied_Date.toDateString() ? "<hr>" : "";
        
        let day_str_value = copied_Date.toJSON().split("T")[0];
      
        let display_val = day_str_value.split("-").reverse().join("-");

        let active_class = !!active_date && copied_Date.toDateString() == active_date.toDateString() && "date_select_active" || "";
        console.log(`<span display_value='${display_val}' value='${day_str_value}' class="${active_class} ${darken ? "hidden_a_bit" : ""}" > ${ day }${ today_hr }</span >`);
        let span = $(`<span display_value='${display_val}' value='${day_str_value}' class="${active_class} ${darken ? "hidden_a_bit" : ""}">${day}${today_hr}</span>`);

        span.on("click", function () {
            $("#datepick_table").css('visibility', "hidden");
            appendSearchValue(span, editingSpan.getAttribute("option_name"))
        })

        date_select.append(span);
        last_indexed_date = day;
        fulldate.setDate(fulldate.getDate() + 1);
    }
    
}



function navigateDateWOffset(offset) {
    let d = new Date(rendered_last_date.getTime());
    const new_month = rendered_last_date.getMonth() + offset;
  

    d.setMonth(new_month);
    navigateDate(d);
}


        

let datepick_observer = new MutationObserver(function (mutations) {
    console.log("changed date!!");

    console.log(editingSpan);
    let sov = editingSpan != null && editingSpan.getAttribute("sov");
    sov = sov != null && sov.length > 0 && sov.split("|||").length && sov.split("|||")[1];
    console.log(sov);
    active_date = null;
    if (!!sov) {
        active_date = new Date(sov);
    }
    navigateDate(sov && new Date(sov) || new Date());
  
});

var target = $("#datepick_table")[0];
datepick_observer.observe(target, { attributes: true, attributeFilter: ['style'] });