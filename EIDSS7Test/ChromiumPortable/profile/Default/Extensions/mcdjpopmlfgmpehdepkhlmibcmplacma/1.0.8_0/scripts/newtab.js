var options;
(function (options) {
    options[options["backgroundColor"] = 0] = "backgroundColor";
    options[options["backgroundImage"] = 1] = "backgroundImage";
})(options || (options = {}));
var userOptions = _.assign({}, DEFAULT_OPTIONS);
var searchConfig = _.assign({}, DEFAULT_SEARCH);
function loadUserSettings(doneCallback) {
    chrome.storage.local.get('userOptions', function (items) {
        var savedOptions = items.userOptions;
        if (savedOptions) {
            _.assign(userOptions, savedOptions);
        }
        (doneCallback || $.noop)();
    });
}
function userOption(optionId, newValue) {
    if (typeof newValue !== 'undefined') {
        userOptions[options[optionId]] = newValue;
        chrome.storage.local.set({ userOptions: userOptions });
    }
    return userOptions[options[optionId]] || '';
}
;
function startClock() {
    var time = $('.time');
    var meridiem = $('.meridiem');
    function zeroPad(value) {
        return (value < 10 ? "0" + value : "" + value);
    }
    function updateClock() {
        var now = new Date();
        var ampm = now.getHours() >= 12 ? 'pm' : 'am';
        var hour = zeroPad((now.getHours() % 12) || 12);
        var minutes = zeroPad(now.getMinutes());
        time.text(hour + ":" + minutes);
        meridiem.text(ampm);
    }
    setInterval(updateClock, 1000);
    updateClock();
}
function getFallbackImageUrl(imageId) {
    imageId = imageId || Math.floor(Math.random() * FALLBACK_IMAGES_COUNT) + 1;
    return "../images/fallback/" + imageId + ".jpg";
}
function toggleFlickrCredit(isVisible) {
    $('.flickr-credit').toggle(isVisible);
    $('.info-links').toggleClass('col-xs-5', isVisible).toggleClass('col-xs-12', !isVisible);
}
function changeBackgroundToFlickr() {
    if ($('.flickr-background').length > 0) {
        return;
    }
    var daysSince1970 = Math.floor(new Date().getTime() / (1000 * 60 * 60 * 24));
    var imageToUse = FLICKR_IMAGES[daysSince1970 % FLICKR_IMAGES.length];
    function useFallBackImage() {
        $('body').css('background-image', "url(\"" + getFallbackImageUrl() + "\")");
    }
    var imageResource = FLICKR_API + "/" + imageToUse.type + "/" + imageToUse.id;
    $.ajax(imageResource + ".json")
        .done(function (apiData) {
        try {
            var metaData = JSON.parse(apiData);
            $('body').append("\n                    <div class=\"flickr-background\" style=\"background-image: url('" + imageResource + ".jpg')\"></div>\n                ");
            $('.flickr-credit').append("\n                    <a href=\"" + metaData.pretty_url + "\"  target=\"_blank\">&ldquo;" + metaData.title + "&rdquo;</a> by\n                    <a href=\"" + metaData.profile_url + "\" target=\"_blank\">" + metaData.profile_name + "</a>\n                    <a href=\"" + metaData.license_url + "\" target=\"_blank\">(" + metaData.license_name + ")</a>\n                ");
            toggleFlickrCredit(true);
            $('.flickr-message').html('Subscribed to daily images. <span class="glyphicon glyphicon-ok"></span>');
            $('.flickr-button').prop('disabled', true);
        }
        catch (e) {
            useFallBackImage();
        }
    })
        .fail(useFallBackImage);
}
function disableFlickrBackground() {
    $('.flickr-message').html('Get a new image everyday!');
    $('.flickr-button').prop('disabled', false);
    $('.flickr-credit').empty();
    toggleFlickrCredit(false);
    $('.flickr-background').remove();
}
function changeBackgroundFromSettings() {
    var body = $('body');
    var bgColor = userOption(options.backgroundColor);
    var bgImage = userOption(options.backgroundImage);
    body.css('background-color', "#" + bgColor);
    body.toggleClass('white-bg', bgColor === 'FFFFFF' && bgImage === 'none');
    if (bgImage === 'flickr') {
        changeBackgroundToFlickr();
    }
    else {
        disableFlickrBackground();
    }
    if (bgImage === 'none') {
        body.css('background-image', 'none');
    }
    else if (bgImage !== 'flickr') {
        body.css('background-image', "url(\"" + getFallbackImageUrl(bgImage) + "\")");
    }
}
function makeEngineImageElement(engine) {
    return $("<img class=\"search-engine-icon\"\n                   src=\"../images/brands/" + engine + ".png\"\n              />");
}
function formatSelectOption(data) {
    if (!data.id) {
        return data.text;
    }
    var text = (data.text === 'Bing') ? '' : data.text;
    return $('<span></span>').append([makeEngineImageElement(data.element.value), text]);
}
function createOptionsPane() {
    var pane = $('.options-pane');
    var images = [];
    for (var imageId = 1; imageId <= Math.max(FALLBACK_IMAGES_COUNT, 4); imageId++) {
        images.push("<a href=\"#\" data-id=\"" + imageId + "\"><img src=\"" + getFallbackImageUrl(imageId) + "\" /></a>");
    }
    $('.options-images').prepend(images);
    $('.options-colors').append(OPTION_COLORS.map(function (color) { return "<a href=\"#\" data-color=\"" + color + "\" class=\"option-color " + color + "\" style=\"background: #" + color + "\"></a>"; }));
    $('.options-images a').click(function () {
        userOption(options.backgroundImage, $(this).data('id'));
        changeBackgroundFromSettings();
    });
    $('.options-colors a').click(function () {
        userOption(options.backgroundImage, 'none');
        userOption(options.backgroundColor, "" + $(this).data('color'));
        changeBackgroundFromSettings();
    });
    $('.flickr-button').click(function () {
        userOption(options.backgroundImage, 'flickr');
        changeBackgroundFromSettings();
    });
    $('.options-open, .options-close').click(function () { return pane.toggle(); });
}
function createFooterLinks() {
    $('.info-links').append(FOOTER_LINKS.map(function (link) {
        return "<a href=\"" + THEME.lpBasePath + link.path + "\">" + link.name + "</a>";
    }));
}
function bindSearchTypeButtons() {
    var buttons = $('.search-types a');
    buttons.click(function (event) {
        var clickedButton = $(this);
        event.preventDefault();
        buttons.not(clickedButton).removeClass('active');
        clickedButton.addClass('active');
        searchConfig.type = clickedButton.data('type');
    });
}
function sortSearchEngines() {
    var searchEngineSelect = $('.search-engine select');
    var searchOpt = searchEngineSelect.children("option[value=\"" + THEME.defaultSearch + "\"]");
    searchOpt.detach();
    searchEngineSelect.prepend(searchOpt);
}
function bindSearchEngineSelect() {
    $('.search-engine select')
        .change(function () {
        searchConfig.engine = $(this).val();
    })
        .select2({
        minimumResultsForSearch: Infinity,
        templateResult: formatSelectOption,
        templateSelection: formatSelectOption
    });
}
function redirectSearch(query) {
    var searchUrl;
    try {
        searchUrl = SEARCH_ENGINES[searchConfig.engine][searchConfig.type];
    }
    catch (e) {
        searchUrl = SEARCH_ENGINES.fallback;
    }
    chrome.runtime.sendMessage({ body: {
            search_engine: searchConfig.engine,
            search_type: searchConfig.type,
            source: 'new_tab'
        }, name: 'search', type: 'analytics' });
    window.location.href = searchUrl.replace('{{%q}}', encodeURIComponent(query));
}
function performSearch(event) {
    event.preventDefault();
    var query = $('.search-query input').val();
    if (query.length > 0) {
        redirectSearch(query);
    }
}
function bindAutocomplete() {
    var AUTOCOMPLETE_MAX_COUNT = 4;
    var AUTOCOMPLETE_HEIGHT = 40;
    $('.search-query input').autocomplete({
        maxHeight: AUTOCOMPLETE_MAX_COUNT * AUTOCOMPLETE_HEIGHT,
        onSelect: function (suggestion) {
            redirectSearch(suggestion.value);
        },
        serviceUrl: 'http://api.bing.net/osjson.aspx',
        transformResult: function (response) {
            try {
                response = JSON.parse(response);
                return {
                    query: response[0],
                    suggestions: response[1]
                };
            }
            catch (e) {
                return {
                    suggestions: []
                };
            }
        },
        width: '465'
    });
}
function initializeUIStateFromSettings() {
    $('.search-engine select').val([searchConfig.engine]).trigger('change');
    $(".search-types a[data-type=\"" + searchConfig.type + "\"]").click();
}
function displaySummaryModal() {
    var summaryModal = $('#summaryModal');
    var dialog = summaryModal.find('.modal-dialog');
    summaryModal.css({
        'display': 'block'
    });
    dialog.css({
        'margin-top': Math.max(0, ($(window).height() - dialog.height()) / 2)
    });
    $("#summaryModalTitle").text(THEME.brand);
    $("#summaryModal").find('.modal-footer > a').attr('href', THEME.lpBasePath);
    summaryModal.modal();
}
$(function initializeExtension() {
    startClock();
    createOptionsPane();
    createFooterLinks();
    bindSearchTypeButtons();
    sortSearchEngines();
    bindSearchEngineSelect();
    bindAutocomplete();
    $('.search-query input').focus();
    $('form').submit(performSearch);
    $('.search-go').click(performSearch);
    loadUserSettings(function () {
        initializeUIStateFromSettings();
        changeBackgroundFromSettings();
    });
    $('.modal-footer .btn-primary').click(function (evt) {
        $('.options-open').trigger('click');
    });
    chrome.storage.sync.get('firstInstallPop', function (val) {
        if (val.firstInstallPop) {
            displaySummaryModal();
            chrome.storage.sync.set({ 'firstInstallPop': false });
        }
    });
});
