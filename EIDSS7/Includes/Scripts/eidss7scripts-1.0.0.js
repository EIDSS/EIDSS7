var currentTab;
var sections;
var sectionCount;
var panelController;
var list;
var items;
var enableControlsOvrride = false;

/// Use this to override enableControl
/// enableControl scans for all controls with class "glyphicon-edit"
/// this does not work for all forms and causes undesirable behavior
/// To override, call this method with val = true and name all section edit controls id starting with "sidebar_edit_menu_" 
/// and gridview row edit button id starting with "gvRowEdit_"
function setEnableControlsOvrride(val) {
    enableControlsOvrride = val;
}

/// This javascript function will make the currentTab visible.
/// Note:  the currentTab must be set prior to callng this function
function setActivePanel() {
    if (sections[currentTab] !== null) {
        sections[currentTab].className = "col-md-12";
    }
}

///  This javascript function will make a given side item "active"
function setActiveSideItem() {
    if (items[currentTab] !== null) {
        items[currentTab].className = "active";
    }
}

///  This javascript function will make assign the hidden class to all panels
function resetPanels() {
    for (var i = 0; i < sectionCount; i++) {
        sections[i].className = "";
        sections[i].className = "hidden";
    }
}

//  This JavaScript function will reset the side items by removing the "active" css class
function resetSideItems() {
    for (var x = 0; x < items.length; x++) {
        items[x].className = "";
    }
}

//  This javascript function will flag items as completed
function setCompletedSideItems() {
    for (var x = 0; x <= currentTab; x++) {
        if (currentTab === sectionCount) {
            return;
        }
    }
}

//  when the document loads, we want to set the current active panel to the correct value 
//  each "tab" is a <section> element on the page
//  we control the visibility by manipulating the correct <section> based on
//  the index in an array
function setViewOnPageLoad(hiddenControlId) {
    //  get the hidden control to get the current tab value
    panelController = document.getElementById(hiddenControlId);
    currentTab = panelController.value;

    //  get the sections of the page into an array of elements
    sections = document.getElementsByTagName("section");
    sectionCount = sections.length;

    //  get the side list on the page using the id of the side panel
    list = document.getElementById("panelList");
    items = list.getElementsByTagName("li");

    //  hide the back button
    var back = $('[id*=btnPreviousSection]');
    back.hide();

    //  make sure our current Tab has a valid integer value
    if (currentTab >= 0 && currentTab <= sectionCount - 1) {
        displayPageAsEdit(currentTab);
    }

    // if we want to display form in review mode.
    if (currentTab == sectionCount) {
        displayPageAsPreview();
    }
}

//  when the document loads, we want to set the current active panel to the correct value 
//  each "tab" is a <section> element on the page
//  we control the visibility by manipulating the correct <section> based on
//  the index in an array
function setSingleTab(hiddenControlId, panel) {
    //  get the hidden control to get the current tab value
    panelController = document.getElementById(hiddenControlId);
    currentTab = panelController.value;

    //  get the sections of the page into an array of elements
    var portion = document.getElementById(panel);
    sections = document.getElementsByTagName("section");
    sectionCount = sections.length;

    setActivePanel();
}

//  this JavaScript function changes the form's visibility and style to make it look like a preview page
function displayPageAsPreview() {
    //  reset panels and side items
    resetPanels();
    resetSideItems();

    //  1) show all panels
    for (var x = 0; x < sectionCount; x++) {
        currentTab = x;
        panelController.value = currentTab;
        setActivePanel();
    }
    //  set the current tab to the "Preview"
    panelController.value = currentTab = sectionCount;
    // Set active panel
    setActiveSideItem();

    //  2) disable all controls
    disableControls();
    showSubmit();
    showSelectableLists();
}

//  this JavaScript function changes the form's visibility back to an edit mode
function displayPageAsEdit(tab) {
    var newTab = -1;

    if (canContinue(tab)) {
        resetPanels();
        resetSideItems();

        if (tab === "next") {
            currentTab++;
        }
        else if (tab === "back") {
            currentTab--;
        }
        else {
            currentTab = tab;
        }

        panelController.value = currentTab;

        setActivePanel();
        setActiveSideItem();

        enableControls();       //this might be causing problems when we need to disable radio buttons
        //Doug Albanese - Found this to be true. Adding a detection method within this function to address this issue.
        hideSubmit();
        hideSelectableLists();
        showSaveCollection();
    }
}

function showSubmit() {
    var submitButton = $('[id*="btnSubmit"]');

    if (submitButton.hasClass("hidden")) {
        submitButton.removeClass("hidden");
    }

    //  show the Add New Person button
    $('[id*="btnAddNew"]').show();
    $('[id*="btnSave"]').show();
}

function showSelectableLists() {
    $("[id*='SelectablePreview']").show();
}

function hideSelectableLists() {
    $("[id*='SelectablePreview']").hide();
}

function hideSubmit() {
    //  hide the submit button
    var submitButton = $('[id*="btnSubmit"]');
    if (submitButton.hasClass("hidden") === false) {
        submitButton.addClass("hidden");
    }

    //  show the Add New Person button
    $('[id*="btnAddNew"]').hide();
    $('[id*="btnSave"]').hide();
}

function showSaveCollection() {
    $('[id*="btnSaveSummaryCollection"]').show();
    $('[id*="btnSaveDetailedCollection"]').show();
}

//  this JavaScript function enables all the controls
function enableControls() {
    //  Enable all inputs
    //var inputs = $("input:text, textarea, input:text");
    //inputs.attr("readOnly", false);

    //var selects = $('select, .input-group-addon select');
    //selects.attr('disabled', false);

    var inputs = $("input:text,select, .input-group-addon select, input:text");
    $(inputs).each(function (i, j) {
        if ($(j).parent().attr("eidssJsIgnore") !== "true") {
            inputs.attr("readOnly", false);
        }
    });

    //  enable number inputs
    var numbers = $("section input[type=number]");
    numbers.attr("readOnly", false);

    // enable date inputs
    var dates = $("input[type=date], section input[type=date]");
    dates.attr("readOnly", false);

    // disable textarea
    var textarea = $("textarea");
    textarea.removeAttr('disabled');

    // enable radio buttons and checkboxes
    // Problems disabling radio was correctly identified by previous coder
    // Adding detection for determine which controls to skip, when needing to handle special cases
    // ASP wraps an HTML control with a span, so we have to enumerate each to get the parent.
    var options = $("section input[type=radio], section input[type=checkbox]");
    $(options).each(function (i, j) {
        if ($(j).parent().attr("eidssJsIgnore") !== "true") {
            options.removeAttr("disabled");
        }
    });

    //  show all buttons except the edit
    var buttons = $("input:button").not(".glyphicon-edit").not("input:submit");
    buttons.toggle(true);

    var submit = $("section input[type=submit]");
    submit.show();

    var deleteButton = $('section input[id*=btnDelete]');
    deleteButton.show();

    $("[id*=addSample]").show();

    // enable links and buttons in grids:
    var tablelinks = $('table a');
    tablelinks.unbind('click', false);
    if (enableControlsOvrride == false) { tablelinks.removeClass('hidden'); }

    // hide the edit buttons
    var editButtons = $(".glyphicon-edit");
    if (enableControlsOvrride == true) { editButtons = $('[id^=sidebar_edit_menu_]').add($('[id^=gvRowEdit_]')).add($('[id^=gvRowDelete_]')) }
    if (editButtons.length > 0) {
        var topButton = editButtons[0];
        if (topButton !== null) {
            var className = topButton.className;
            if (className !== "btn glyphicon glyphicon-edit hidden") {
                editButtons.toggleClass("hidden");
            }
        }
    }

    if (currentTab === 0) {
        //  hide the back button
        var back = $('[id*=btnPreviousSection]');
        back.hide();
    }
}

//  this JavaScript function disables all controls
function disableControls() {
    //  disable all text inputs and drop downs
    //var inputs = $("input:text, input:text");
    //inputs.attr("readOnly", true);

    //var selects = $('select, .input-group-addon select');
    //selects.attr('disabled', 'disabled');

    var inputs = $("input:text,select, .input-group-addon select, input:text");
    inputs.attr("readOnly", true);

    //  disable number inputs
    var numbers = $("input[type=number]");
    numbers.attr("readOnly", true);

    // disable date inputs
    var dates = $("input[type=date], section input[type=date]");
    dates.attr("readOnly", true);

    // disable textarea
    var textarea = $("textarea");
    textarea.attr('disabled', 'disabled');

    // disable radio buttons and checkboxes
    var options = $("section input[type=radio], section input[type=checkbox]");
    options.attr("disabled", true);

    //  hide all buttons except the edit buttons
    var buttons = $("input:button").not(".glyphicon-edit").not("input:submit");
    buttons.toggle(false);

    var submit = $("section input[type=submit]");
    submit.hide();

    var deleteButton = $('section input[id*=btnDelete]');
    deleteButton.hide();

    $("[id*=addSample]").hide();

    // enable links and buttons in grids:
    var tablelinks = $('table a');
    tablelinks.bind('click', false);
    if (enableControlsOvrride == false) { tablelinks.addClass('hidden'); }

    // show the edit buttons
    var editButtons = $(".glyphicon-edit");
    if (enableControlsOvrride == true) { editButtons = $('[id^=sidebar_edit_menu_]').add($('[id^=gvRowEdit_]')).add($('[id^=gvRowDelete_]')) }
    if (editButtons.length > 0) {
        var topButton = editButtons[0];
        if (topButton !== null) {
            var className = topButton.className;
            if (className !== "btn glyphicon glyphicon-edit") {
                editButtons.toggleClass("hidden");
            }
        }
    }
}

//  This JavaScript function handles the Continue Client button click
function goForwardToNextPanel() {
    if (validate(currentTab)) {
        // make sure the current tab isn't less than zero  or greater than the section count 
        if (currentTab >= 0 && currentTab < sectionCount - 1) {
            displayPageAsEdit("next");
            return;
        }
        //  if the current tab equals the section count we need to display page as preview
        if (currentTab === sectionCount - 1) {
            displayPageAsPreview();
        }
    }
}

//  this JavaScript function handles the Go back Client button click
function goBackToPreviousPanel() {
    if (validate(currentTab - 1)) {
        if (currentTab >= 0 && currentTab <= sectionCount - 1) {
            displayPageAsEdit("back");
        }
    }
}

//  this JavaScript function handles the side item navigation clicks
function goToTab(tabNo) {
    if (validate(tabNo)) {
        if (tabNo === sectionCount) {
            displayPageAsPreview();
        }
        else {
            displayPageAsEdit(tabNo);
        }
    }
}

function validate(tab) {
    // get id of current tab
    if (tab === sectionCount) {
        validateAllSections();
    }
    else {
        validateSection(tab);
    }

    // we always return true because requirements dictate that we must not prevent user from continuing
    //  we are only flagging elements that were missed.
    return true;
}

function validateAllSections() {

    for (var x = 0; x < sectionCount; x++) {
        validateSection(x);
    }
}

function validateSection(tab) {
    if (sections[tab] !== null) {
        var sectionId = sections[tab].id;
        var sectionIdParts = sectionId.split("_");
        var countOfParts = sectionIdParts.length;
        var validationGroupId = sectionIdParts[countOfParts - 1];

        Page_ClientValidate(validationGroupId);

        if (Page_IsValid === false) {
            if (items[tab] !== null) {
                var failedCheckmark = $(items[tab]).find(".glyphicon-ok");
                if (failedCheckmark.length === 0) {
                    failedCheckmark = $(items[tab]).find(".glyphicon-remove");
                }

                if (failedCheckmark.length === 1) {
                    setFailedGlyph(failedCheckmark);
                }
            }
        } else {
            if (items[tab] !== null) {
                var passedCheckmark = $(items[tab]).find(".glyphicon-ok");
                if (passedCheckmark.length === 0) {
                    passedCheckmark = $(items[tab]).find(".glyphicon-remove");
                }

                if (passedCheckmark.length === 1) {
                    setPassGlyph(passedCheckmark);
                }
            }
        }
    }
}

function setFailedGlyph(obj) {
    if (obj.hasClass("glyphicon-ok")) {
        obj.removeClass("glyphicon-ok");
        obj.addClass("glyphicon-remove");
    }

    if (obj.hasClass("normalcheckmark")) {
        obj.removeClass("normalcheckmark");
    }

    if (obj.hasClass("passcheckmark")) {
        obj.removeClass("passcheckmark");
    }

    if (!obj.hasClass("failcheckmark")) {
        obj.addClass("failcheckmark");
    }
}

function setPassGlyph(obj) {
    if (obj.hasClass("glyphicon-remove")) {
        obj.removeClass("glyphicon-remove");
        obj.addClass("glyphicon-ok");
    }

    if (obj.hasClass("failcheckmark")) {
        obj.removeClass("failcheckmark");
    }

    if (obj.hasClass("normalcheckmark")) {
        obj.removeClass("normalcheckmark");
    }

    if (!obj.hasClass("passcheckmark")) {
        obj.addClass("passcheckmark");
    }
}

function canContinue(tab) {
    //  I can continue if I'm moving forward but not past the preview pane
    //  I can continue if I'm moving back but not at the beginning
    //  going to a specific tab
    if (isNaN(tab)) {
        if (tab === "next" || tab === "back") {
            if (tab === "next" && currentTab < sectionCount) {
                return true;
            }
            if (tab === "back" && currentTab > 0) {
                return true;
            }
            return false;
        }
        else {
            return false;
        }
    }
    else if (tab >= 0 && tab <= sectionCount) {
        return true;
    }
    else {
        return false;
    }
}

//  this function is used when clearing a list of options before repopulating the list with 
//  fresh data from an ajax call.
function clearDropDownList(list) {
    if (list.options.length > 0) {
        for (var x = list.options.length; x > 0; x--) {
            list.remove(x);
        }
    }

    list.selectedIndex = -1;
}

// returns the selected element in a drop down list
function getSelectedElement(list) {
    var selected = list.find(":selected");
    return selected[0].value;
}

function countryChanged(orgUrl, orgData, ddlCountryList, ddlRegionList, ddlRayonList, ddlSettlementList, ddlPostalCodeList) {
    //  clear the previous lists if they have any options in them
    if (ddlRegionList !== null) {
        ddlRegionList.empty();
    }
    if (ddlRayonList !== null) {
        ddlRayonList.empty();
    }
    if (ddlSettlementList !== null) {
        ddlSettlementList.empty();
    }
    if (ddlPostalCodeList !== null) {
        ddlPostalCodeList.empty();
    }

    getListOptions(orgUrl, orgData, ddlRegionList);
}

function regionChanged(orgUrl, orgData, ddlRegionList, ddlRayonList, ddlSettlementList, ddlPostalCodeList) {
    //  clear the previous lists if they have any options in them
    if (ddlRayonList !== null) {
        ddlRayonList.empty();
    }
    if (ddlSettlementList !== null) {
        ddlSettlementList.empty();
    }
    if (ddlPostalCodeList !== null) {
        ddlPostalCodeList.empty();
    }
    getListOptions(orgUrl, orgData, ddlRayonList);
}

function rayonChanged(orgUrl, orgData, ddlRayonList, ddlSettlementList) {
    if (ddlSettlementList !== null) {
        ddlSettlementList.empty();
    }
    if (ddlPostalCodeList !== null) {
        ddlPostalCodeList.empty();
    }
    getListOptions(orgUrl, orgData, ddlSettlementList);
}


function townChanged(orgUrl, orgData, ddlSettlementList, ddlPostalCodeList) {
    if (ddlPostalCodeList !== null) {
        ddlPostalCodeList.empty();
    }
    getListOptions(orgUrl, orgData, ddlPostalCodeList);
}

function getListOptions(orgUrl, orgData, list) {
    $.ajax({
        type: "POST",
        url: orgUrl,
        data: orgData,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {


            //  then add the new options to the drop down list
            if (data.d) {
                $.each(data.d, function (index, item) {
                    list.append('<option value="' + o.Value + '">' + o.Text + '</option>');
                });
            }// end of if
        },
        error: function (jqXHR, textStatus, errorThrown) {
            //alert(textStatus);
            //alert(errorThrown);
        }
    });
}

///////////////////////////// Multiple Side Bar Panels on Same Page ///////////////////////////////
/**************************************************************************************************
* Behaves similar to setViewOnPageLoad, but is intended for pages with more thana one sidebar 
* panel.
* 
* @param {(Object)} hiddenControlId Side Bar current section.
* @param {(Object)} panel Side Bar items (tabs).
* @param {(Object)} div Container for all of the Side Bar section HTML input elements.
* @param {(Object)} previousButton HTML element for the previous section button.
* @param {(Object)} submitButton HTML element for the submit button.
**************************************************************************************************/
function initializeSideBarPanel(hiddenControlId, panel, div, previousButton, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    //var sideBarItems = panel.getElementsByTagName("li");
    sideBarSections = div.getElementsByTagName("section");
    sideBarSectionCount = sideBarSections.length;

    if (!$(previousButton).hasClass("hidden")) {
        $(previousButton).addClass("hidden");
    }

    var panelList = panel.getElementsByTagName("ul");

    if (sideBarCurrentTab >= 0 && sideBarCurrentTab <= sideBarSectionCount - 1) {
        // If the side bar navigation does not set IsActive on each item, then the panelList ul is not rendered, so we
        // get the first ul found above to pass on to called functions.  Please check the EIDSSControlLibrary's, SideBarNavigation class, 
        // RenderControl method and look for panelList to see how this is rendered.
        if (panelList.length == 1)
            displayEditMode(sideBarCurrentTab, hiddenControlId, panelList[0], div, previousButton, submitButton);
        else
            displayEditMode(sideBarCurrentTab, hiddenControlId, panelList[1], div, previousButton, submitButton);
    }

    if (sideBarCurrentTab === sideBarSectionCount) {
        displayPreviewMode(hiddenControlId, panelList[1], div, submitButton);
    }
}

/**************************************************************************************************
* Changes the form's visibility and style to make it look like a preview page.
*
* @param {(Object)} hiddenControlId Side Bar current section.
* @param {(Object)} panel Side Bar items (tabs).
* @param {(Object)} div Container for all of the Side Bar section HTML input elements.
* @param {(Object)} submitButton HTML element for the submit button.
**************************************************************************************************/
function displayPreviewMode(hiddenControlId, panel, div, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var sideBarItems = panel.getElementsByTagName("li");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    for (var x = 0; x < sideBarSectionCount; x++) {
        sideBarSections[x].className = "";
        sideBarSections[x].className = "hidden";
    }

    for (x = 0; x < sideBarItems.length; x++) {
        sideBarItems[x].className = "";
    }

    for (x = 0; x < sideBarSectionCount; x++) {
        sideBarCurrentTab = x;
        hiddenControlId.value = sideBarCurrentTab;
        if (sideBarSections[sideBarCurrentTab] !== null) {
            sideBarSections[sideBarCurrentTab].className = "col-md-12";
        }
    }

    hiddenControlId.value = sideBarCurrentTab = sideBarSectionCount;

    if (sideBarItems[sideBarCurrentTab] !== null) {
        sideBarItems[sideBarCurrentTab].className = "active";
    }

    disableSideBarControls(div);

    if ($(submitButton).hasClass("hidden")) {
        $(submitButton).removeClass("hidden");
    }

    showSelectableLists();
}

/**************************************************************************************************
* Changes the form's visibility and style to make it look like a preview page with no edit options.
*
* @param {(Object)} hiddenControlId Side Bar current section.
* @param {(Object)} panel Side Bar items (tabs).
* @param {(Object)} div Container for all of the Side Bar section HTML input elements.
* @param {(Object)} submitButton HTML element for the submit button.
**************************************************************************************************/
function displayPreviewModeSecured(hiddenControlId, panel, div, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var sideBarItems = panel.getElementsByTagName("li");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    for (var x = 0; x < sideBarSectionCount; x++) {
        sideBarSections[x].className = "";
        sideBarSections[x].className = "hidden";
    }

    for (x = 0; x < sideBarItems.length; x++) {
        sideBarItems[x].className = "";
    }

    for (x = 0; x < sideBarSectionCount; x++) {
        sideBarCurrentTab = x;
        hiddenControlId.value = sideBarCurrentTab;
        if (sideBarSections[sideBarCurrentTab] !== null) {
            sideBarSections[sideBarCurrentTab].className = "col-md-12";
        }
    }

    hiddenControlId.value = sideBarCurrentTab = sideBarSectionCount;

    if (sideBarItems[sideBarCurrentTab] !== null) {
        sideBarItems[sideBarCurrentTab].className = "active";
    }

    disableSideBarControls(div);

    // Hide the edit buttons
    var editButtons = $(div).find(".glyphicon-edit");
    if (editButtons.length > 0) {
        var topButton = editButtons[0];
        if (topButton !== null) {
            var className = topButton.className;
            if (className !== "btn glyphicon glyphicon-edit hidden") {
                editButtons.toggleClass("hidden");
            }
        }
    }

    showSelectableLists();
}

/**************************************************************************************************
* Changes the form's visibility back to an edit mode.
*
* @param {(number|String)} tab Current section.
* @param {(Object)} hiddenControlId Side Bar current section.
* @param {(Object)} panel Side Bar items (tabs).
* @param {(Object)} div Container for all of the Side Bar section HTML input elements.
* @param {(Object)} previousButton HTML element for the previous section button.
* @param {(Object)} submitButton HTML element for the submit button.
**************************************************************************************************/
function displayEditMode(tab, hiddenControlId, panel, div, previousButton, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var sideBarItems = panel.getElementsByTagName("li");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    if (canContinueNavigating(tab, hiddenControlId, div)) {
        for (var x = 0; x < sideBarSectionCount; x++) {
            sideBarSections[x].className = "";
            sideBarSections[x].className = "hidden";
        }

        for (x = 0; x < sideBarItems.length; x++) {
            sideBarItems[x].className = "";
        }

        if (tab === "next") {
            sideBarCurrentTab++;
        }
        else if (tab === "back") {
            sideBarCurrentTab--;
        }
        else {
            sideBarCurrentTab = tab;
        }

        hiddenControlId.value = sideBarCurrentTab;

        // Set the active section.
        if (sideBarSections[sideBarCurrentTab] !== null) {
            sideBarSections[sideBarCurrentTab].className = "col-md-12";
        }

        // Set the active side bar panel item.
        if (sideBarItems[sideBarCurrentTab] !== null) {
            sideBarItems[sideBarCurrentTab].className = "active";
        }

        enableSideBarControls(hiddenControlId, previousButton, div);

        if ($(submitButton).hasClass("hidden") === false) {
            $(submitButton).addClass("hidden");
        }

        hideSelectableLists();
    }
}

function canContinueNavigating(tab, hiddenControlId, div) {
    var sideBarCurrentTab = hiddenControlId.value;
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    if (isNaN(tab)) {
        if (tab === "next" || tab === "back") {
            if (tab === "next" && sideBarCurrentTab < sideBarSectionCount) {
                return true;
            }
            if (tab === "back" && sideBarCurrentTab > 0) {
                return true;
            }
            return false;
        }
        else {
            return false;
        }
    }
    else if (tab >= 0 && tab <= sideBarSectionCount) {
        return true;
    }
    else {
        return false;
    }
}

// Handles the next button click.
function goToNextSection(hiddenControlId, panel, div, previousButton, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var panelList = panel.getElementsByTagName("ul");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    // If the side bar navigation does not set IsActive on each item, then the panelList ul is not rendered, so we
    // get the first ul found above to pass on to called functions.  Please check the EIDSSControlLibrary's, SideBarNavigation class, 
    // RenderControl method and look for panelList to see how this is rendered.
    if (panelList.length == 1) {
        if (validateSideBar(sideBarCurrentTab, panelList[0], div)) {
            // Make sure the current tab isn't less than zero or greater than the section count. 
            if (sideBarCurrentTab >= 0 && sideBarCurrentTab < sideBarSectionCount - 1) {
                displayEditMode("next", hiddenControlId, panelList[0], div, previousButton, submitButton);
                return;
            }

            // If the current tab equals the section count, then display page as preview.
            if (parseInt(sideBarCurrentTab, 10) === parseInt(sideBarSectionCount - 1, 10)) {
                displayPreviewMode(hiddenControlId, panelList[0], div, submitButton);
            }
        }
    }
    else {
        if (validateSideBar(sideBarCurrentTab, panelList[1], div)) {
            // Make sure the current tab isn't less than zero or greater than the section count. 
            if (sideBarCurrentTab >= 0 && sideBarCurrentTab < sideBarSectionCount - 1) {
                displayEditMode("next", hiddenControlId, panelList[1], div, previousButton, submitButton);
                return;
            }

            // If the current tab equals the section count, then display page as preview.
            if (parseInt(sideBarCurrentTab, 10) === parseInt(sideBarSectionCount - 1, 10)) {
                displayPreviewMode(hiddenControlId, panelList[1], div, submitButton);
            }
        }
    }
}

// Handles the go back button click.
function goToPreviousSection(hiddenControlId, panel, div, previousButton, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var panelList = panel.getElementsByTagName("ul");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    // If the side bar navigation does not set IsActive on each item, then the panelList ul is not rendered, so we
    // get the first ul found above to pass on to called functions.  Please check the EIDSSControlLibrary's, SideBarNavigation class, 
    // RenderControl method and look for panelList to see how this is rendered.
    if (panelList.length == 1) {
        if (validateSideBar(sideBarCurrentTab - 1, panelList[0], div)) {
            if (sideBarCurrentTab >= 0 && sideBarCurrentTab <= sideBarSectionCount - 1) {
                displayEditMode("back", hiddenControlId, panelList[0], div, previousButton, submitButton);
            }
        }
    }
    else {
        if (validateSideBar(sideBarCurrentTab - 1, panelList[1], div)) {
            if (sideBarCurrentTab >= 0 && sideBarCurrentTab <= sideBarSectionCount - 1) {
                displayEditMode("back", hiddenControlId, panelList[1], div, previousButton, submitButton);
            }
        }
    }
}

// Handles the side item navigation clicks.
function goToSideBarSection(tab, hiddenControlId, panel, div, previousButton, submitButton) {
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;
    var panelList = panel.getElementsByTagName("ul");

    // If the side bar navigation does not set IsActive on each item, then the panelList ul is not rendered, so we
    // get the first ul found above to pass on to called functions.  Please check the EIDSSControlLibrary's, SideBarNavigation class, 
    // RenderControl method and look for panelList to see how this is rendered.
    if (panelList.length == 1) {
        if (validateSideBar(tab, panelList[0], div)) {
            if (tab === sideBarSectionCount) {
                displayPreviewMode(tab, panelList[0], div, submitButton);
            }
            else {
                displayEditMode(tab, hiddenControlId, panelList[0], div, previousButton, submitButton);
            }
        }
    }
    else {
        if (validateSideBar(tab, panelList[1], div)) {
            if (tab === sideBarSectionCount) {
                displayPreviewMode(tab, panelList[1], div, submitButton);
            }
            else {
                displayEditMode(tab, hiddenControlId, panelList[1], div, previousButton, submitButton);
            }
        }
    }
}

function goToReviewSection(tab, hiddenControlId, panel, div, nextButton, submitButton) {
    var sideBarCurrentTab = hiddenControlId.value;
    var sideBarItems = panel.getElementsByTagName("li");
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;
    var panelList = panel.getElementsByTagName("ul");

    // If the side bar navigation does not set IsActive on each item, then the panelList ul is not rendered, so we
    // get the first ul found above to pass on to called functions.  Please check the EIDSSControlLibrary's, SideBarNavigation class, 
    // RenderControl method and look for panelList to see how this is rendered.
    if (panelList.length == 1) {
        if (validateSideBar(tab, panelList[0], div)) {
            for (var x = 0; x < sideBarSectionCount; x++) {
                sideBarSections[x].className = "";
                sideBarSections[x].className = "hidden";
            }

            for (x = 0; x < sideBarItems.length; x++) {
                sideBarItems[x].className = "";
            }

            for (x = 0; x < sideBarSectionCount; x++) {
                sideBarCurrentTab = x;
                hiddenControlId.value = sideBarCurrentTab;
                if (sideBarSections[sideBarCurrentTab] !== null) {
                    sideBarSections[sideBarCurrentTab].className = "col-md-12";
                }
            }

            hiddenControlId.value = sideBarItems.length - 1;

            disableSideBarControls(div);

            if ($(submitButton).hasClass("hidden")) {
                $(submitButton).removeClass("hidden");
            }

            $(nextButton).hide();

            showSelectableLists();

            // Set the active side bar panel item.
            if (sideBarItems[sideBarItems.length - 1] !== null) {
                sideBarItems[sideBarItems.length - 1].className = "active";
            }
        }
    }
    else {
        if (validateSideBar(tab, panelList[1], div)) {
            for (var x = 0; x < sideBarSectionCount; x++) {
                sideBarSections[x].className = "";
                sideBarSections[x].className = "hidden";
            }

            for (x = 0; x < sideBarItems.length; x++) {
                sideBarItems[x].className = "";
            }

            for (x = 0; x < sideBarSectionCount; x++) {
                sideBarCurrentTab = x;
                hiddenControlId.value = sideBarCurrentTab;
                if (sideBarSections[sideBarCurrentTab] !== null) {
                    sideBarSections[sideBarCurrentTab].className = "col-md-12";
                }
            }

            hiddenControlId.value = sideBarItems.length - 1;

            disableSideBarControls(div);

            if ($(submitButton).hasClass("hidden")) {
                $(submitButton).removeClass("hidden");
            }

            $(nextButton).hide();

            showSelectableLists();

            // Set the active side bar panel item.
            if (sideBarItems[sideBarItems.length - 1] !== null) {
                sideBarItems[sideBarItems.length - 1].className = "active";
            }
        }
    }
}

function validateSideBar(tab, panel, div) {
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    // Get id of the current tab
    if (parseInt(tab, 10) === sideBarSectionCount) {
        validateAllSideBarSections(panel, div);
    }
    else {
        validateSideBarSection(tab, panel, div);
    }

    // Always return true because requirements dictate that not preventing 
    // user from continuing, so only flagging elements that were missed/invalid.
    return true;
}

function validateAllSideBarSections(panel, div) {
    var sideBarSections = div.getElementsByTagName("section");
    var sideBarSectionCount = sideBarSections.length;

    for (var x = 0; x < sideBarSectionCount; x++) {
        validateSideBarSection(x, panel, div);
    }
}

function validateSideBarSection(tab, panel, div) {
    var sideBarItems = panel.getElementsByTagName("li");
    var sideBarSections = div.getElementsByTagName("section");

    if (sideBarSections[tab] !== null) {
        var sectionId = sideBarSections[tab].id;
        var sectionIdParts = sectionId.split("_");
        var countOfParts = sectionIdParts.length;
        var validationGroupId = sectionIdParts[countOfParts - 1];

        Page_ClientValidate(validationGroupId);

        if (Page_IsValid === false) {
            if (sideBarItems[tab] !== null) {
                var failedCheckmark = $(sideBarItems[tab]).find(".glyphicon-ok");

                if (parseInt(failedCheckmark.length, 10) === 0) {
                    failedCheckmark = $(sideBarItems[tab]).find(".glyphicon-remove");
                }

                if (parseInt(failedCheckmark.length, 10) === 1) {
                    setFailedGlyph(failedCheckmark);
                }
            }
        } else {
            if (sideBarItems[tab] !== null) {
                var passedCheckmark = $(sideBarItems[tab]).find(".glyphicon-ok");
                if (parseInt(passedCheckmark.length, 10) === 0) {
                    passedCheckmark = $(sideBarItems[tab]).find(".glyphicon-remove");
                }

                if (parseInt(passedCheckmark.length, 10) === 1) {
                    setPassGlyph(passedCheckmark);
                }
            }
        }
    }
}

// Enables all the controls for the side bar div.
function enableSideBarControls(hiddenControlId, previousButton, div) {
    var sideBarCurrentTab = hiddenControlId.value;

    var inputs = $(div).find("input[type=text], select, .input-group-addon select, input[type=text]");
    $(inputs).each(function (i, j) {
        if ($(j).parent().attr("eidssJsIgnore") !== "true") {
            inputs.attr("readOnly", false);
        }
    });

    // Enable number inputs
    var numbers = $(div).find("section input[type=number]");
    numbers.attr("readOnly", false);

    // Enable date inputs
    var dates = $(div).find("input[type=date], section input[type=date]");
    dates.attr("readOnly", false);

    // disable textarea
    var textarea = $(div).find("textarea");
    textarea.removeAttr('disabled');

    // enable radio buttons and checkboxes
    // Problems disabling radio was correctly identified by previous coder
    // Adding detection for determine which controls to skip, when needing to handle special cases
    // ASP wraps an HTML control with a span, so we have to enumerate each to get the parent.
    var options = $(div).find("section input[type=radio], section input[type=checkbox]");
    $(options).each(function (i, j) {
        if ($(j).parent().attr("eidssJsIgnore") !== "true") {
            options.removeAttr("disabled");
        }
    });

    // Show all buttons except the edit
    var buttons = $(div).find("input[type=button]").not(".glyphicon-edit").not("input[type=submit]");
    buttons.toggle(true);

    var submit = $(div).find("section input[type=submit]");
    submit.show();

    var deleteButton = $(div).find('section input[id*=btnDelete]');
    deleteButton.show();

    // Enable links and buttons in grids:
    var tablelinks = $(div).find('table a');
    tablelinks.unbind('click', false);
    tablelinks.removeClass('hidden');

    // Hide the edit buttons
    var editButtons = $(div).find(".glyphicon-edit");
    if (editButtons.length > 0) {
        var topButton = editButtons[0];
        if (topButton !== null) {
            var className = topButton.className;
            if (className !== "btn glyphicon glyphicon-edit hidden") {
                editButtons.toggleClass("hidden");
            }
        }
    }

    if (parseInt(sideBarCurrentTab, 10) === 0) {
        // Hide the previous section button
        if (!$(previousButton).hasClass("hidden")) {
            $(previousButton).addClass("hidden");
        }
    }
    else {
        // Show the previous section button.
        if ($(previousButton).hasClass("hidden")) {
            $(previousButton).removeClass("hidden");
        }
    }
}

// Disables all controls for the specific side bar
function disableSideBarControls(div) {
    var inputs = $(div).find("input[type=text], select, .input-group-addon select, input[type=text]");
    inputs.attr("readOnly", true);

    var numbers = $(div).find("input[type=number]");
    numbers.attr("readOnly", true);

    var dates = $(div).find("input[type=date], section input[type=date]");
    dates.attr("readOnly", true);

    var textarea = $(div).find("textarea");
    textarea.attr('disabled', 'disabled');

    var options = $(div).find("section input[type=radio], section input[type=checkbox]");
    options.attr("disabled", true);

    // Hide all buttons except the edit buttons and add selectable preview list.
    var buttons = $(div).find("input[type=button]").not(".glyphicon-edit").not("input[type=submit]").not("input[id^='btnAddSelectablePreview']");
    buttons.toggle(false);

    var submit = $(div).find("section input[type=submit]");
    submit.hide();

    var deleteButton = $(div).find('section input[id*=btnDelete]');
    deleteButton.hide();

    // Enable links and buttons in grids
    var tablelinks = $(div).find('table a');
    tablelinks.bind('click', false);
    tablelinks.addClass('hidden');

    // Show view link buttons in the preview lists.
    var viewSelectablePreview = $("[id*='btnViewSelectablePreview']");
    viewSelectablePreview.unbind('click', false);
    viewSelectablePreview.removeClass("hidden");
    viewSelectablePreview.removeAttr("disabled");

    // Show the edit buttons
    var editButtons = $(div).find(".glyphicon-edit");
    if (editButtons.length > 0) {
        var topButton = editButtons[0];
        if (topButton !== null) {
            var className = topButton.className;
            if (className !== "btn glyphicon glyphicon-edit") {
                editButtons.toggleClass("hidden");
            }
        }
    }
}

function showSelectablePreviewLists(div) {
    $("[id*='SelectablePreview']").show();
}

function hideSelectablePreviewLists(div) {
    $("[id*='SelectablePreview']").hide();
}

function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function setCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    }
    else {
        var expires = "";
    }

    document.cookie = name + "=" + value + expires + "; path=/";
}