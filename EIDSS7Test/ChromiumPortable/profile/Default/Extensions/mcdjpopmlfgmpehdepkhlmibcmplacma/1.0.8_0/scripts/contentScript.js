chrome.runtime.sendMessage({ eventType: 'loaded' }, function (response) {
    if (response && response.firstSearchPop) {
        injectFirstSearchPopup();
    }
});
function fadeOutDiv(element) {
    var opacity = 1.0;
    var timer = setInterval(function () {
        if (opacity <= 0.1) {
            clearInterval(timer);
            element.style.display = 'none';
        }
        opacity -= 0.1;
        element.style.opacity = opacity;
    }, 50);
}
function injectFirstSearchPopup() {
    var popupImg = document.createElement('img');
    popupImg.id = 'popupImg';
    popupImg.src = chrome.extension.getURL('images/SS-distract.png');
    popupImg.style.position = 'relative';
    popupImg.setAttribute('show', '');
    var popupDiv = document.createElement('div');
    popupDiv.id = 'popupDiv';
    popupDiv.style.position = 'absolute';
    popupDiv.style.top = '20%';
    popupDiv.style.right = '1%';
    popupDiv.appendChild(popupImg);
    document.body.appendChild(popupDiv);
    setTimeout(function () { fadeOutDiv(popupDiv); }, 5000);
    document.addEventListener('click', function () {
        var icon = document.getElementById('popupImg');
        if (icon && icon.hasAttribute('show')) {
            icon.removeAttribute('show');
            var div = document.getElementById('popupDiv');
            div.remove();
            chrome.runtime.sendMessage({ type: 'analytics', name: 'activate', body: {} });
        }
    });
}
