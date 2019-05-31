
function eidssDropDownShowModalWindow(url, popupwindowid) {
    $.ajax({
        url: url, success: function (result) {
            var id = "#" + popupwindowid + "_innerdiv"
            $(id).html(result);
        }
    });
    return false;
}

function eidssDropdownSelectItem(idOfList, text, dialogId) {
    var list = document.getElementById(idOfList);
    eidssDropdownSetSelectedValue(list, text);
}

function eidssDropdownSetSelectedValue(selectObj, valueToSet) {
    for (var i = 0; i < selectObj.options.length; i++) {
        if (selectObj.options[i].text == valueToSet) {
            selectObj.options[i].selected = true;
            return false;
        }
    }
}

function wireSidePanelEvents() {
    //  wire the click event to expand/collapse menu
    $("#btnSideMenuToggle").click(function () {
        $(".menuContainer").toggleClass("collapsed");
        $(".sectionContainer").toggleClass("expanded")
    });

    //  wire the tooltips
    //$("#panelList li").each(function (index) {
    $("#panelList .glyphicon:first-of-type").each(function (index) {
        $(this).mouseover(function () {
            //var rt = ($(window).width() - ($(this).offset().left + $(this).outerWidth()));
            $(".sideMenuToolTip").text($(this).attr("tooltip"));
            var rt = $(this).offset().left - $(".sideMenuToolTip").outerWidth();
            $(".sideMenuToolTip").offset({ top: $(this).offset().top + 10, left: rt })
            $(".sideMenuToolTip").css("visibility", "visible");
        });//end of mouseover
        $(this).mouseout(function () {
            $(".sideMenuToolTip").css("visibility", "hidden");
        });// end of mouseleave
    });
    // make it a  sticky panel
    try {
        var elements = document.querySelectorAll('.menuContainer');
        Stickyfill.add(elements)
    }
    catch (e) {

    };
};

function spinnerUpClicked(objId, max) {
    var id = "#" + objId;
    if (isNaN(parseInt($(id).val(), 10))) {
        $(id).val(0)
    }
    else {
        var curVal = $(id).val();

        if (parseFloat(curVal) >= parseFloat(max)) {
            $(id).val(parseInt(max, 10));
        }
        else {
            $(id).val(parseInt(curVal, 10) + 1);
        }
    }
}

function spinnerDownClicked(objId, min) {
    var id = "#" + objId;
    if (isNaN(parseInt($(id).val(), 10))) {
        $(id).val(0)
    }
    else {
        var curVal = $(id).val();
        
        if (parseFloat(curVal) <= parseFloat(min)) {
            $(id).val(parseInt(min, 10));
        }
        else {
            $(id).val(parseInt(curVal, 10) - 1);
        }
    }
}

function spinnerUpClicked_ri(objId, max) {
    var ri = $(objId).parent().parent().find("input")

    if (isNaN(parseInt($(ri).val(), 10))) {
        $(ri).val(0)
    }
    else {
        var curVal = $(ri).val();

        if (parseFloat(curVal) >= parseFloat(max)) {
            $(ri).val(parseInt(max, 10));
        }
        else {
            $(ri).val(parseInt(curVal, 10) + 1);
        }
    }
}

function spinnerDownClicked_ri(objId, min) {
    var ri = $(objId).parent().parent().find("input")
    
    if (isNaN(parseInt($(ri).val(), 10))) {
        $(ri).val(0)
    }
    else {
        var curVal = $(ri).val();

        if (parseFloat(curVal) <= parseFloat(min)) {
            $(ri).val(parseInt(min, 10));
        }
        else {
            $(ri).val(parseInt(curVal, 10) - 1);
        }
    }
}

function spinnerBlur(objId, min, max) {
    var id = "#" + objId;
    if (isNaN(parseInt($(id).val(), 10))) {
        $(id).val(0)
    }
    else {
        var curVal = $(id).val();

        if (parseFloat(curVal) <= parseFloat(min)) {
            $(id).val(parseInt(min, 10));
        }
        if (parseFloat(curVal) >= parseFloat(max)) {
            $(id).val(parseInt(max, 10));
        }
    }
}

function isNumberKey(e) {
    // Allow: backspace, tab, enter, escape, delete, Period, Comma and Decimal Point)
    if ($.inArray(e.keyCode, [8, 9, 13, 27, 46, 95, 110, 188, 190]) !== -1 ||
        // Allow: Ctrl+A, Command+A
        (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
        // Allow: home, end, left, right, down, up
        (e.keyCode >= 35 && e.keyCode <= 40)) {
        // let it happen, don't do anything
        return;
    }
    // Ensure that it is a number and stop the keypress
    if (e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) {
        e.preventDefault();
    }
};

function isIntegerKey(e) {
    // Allow: backspace, tab, enter, escape)
    if ($.inArray(e.keyCode, [8, 9, 13, 27]) !== -1 ||
        // Allow: Ctrl+A, Command+A
        (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
        // Allow: home, end, left, right, down, up
        (e.keyCode >= 35 && e.keyCode <= 40)) {
        // let it happen, don't do anything
        return;
    }

    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey) || // if it a shift key combo OR
            ((e.keyCode < 48) || (e.keyCode > 57))) { // if it is a number 
        e.preventDefault();
    }
};




