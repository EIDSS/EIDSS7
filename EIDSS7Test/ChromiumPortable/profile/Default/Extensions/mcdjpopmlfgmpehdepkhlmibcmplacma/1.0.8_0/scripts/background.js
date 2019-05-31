var PERION_FEED = 'perion';
function perionCheckSuLoad(gid, n) {
    var suCheckAttempts = 0;
    var checkSUinit = function () {
        if (SUConsts.isInitialized && suCheckAttempts < 10) {
            SUConfigManager.setGID(gid);
            SUConfigManager.setChannel(n);
        }
        else {
            suCheckAttempts++;
            setTimeout(function () {
                checkSUinit();
            }, 50);
        }
    };
    checkSUinit();
}
function generateTrackingId(themeTrackingId, gid, affid) {
    if (themeTrackingId) {
        return themeTrackingId;
    }
    if (gid && affid) {
        return affid + "-" + gid;
    }
}
function setDeskmetricsIDs(config) {
    var c = console;
    var gid = $dm.getProperty('gid');
    if (!gid || !/^[a-zA-Z]{2}[0-9]{7}$/.test(gid)) {
        c.log('Correcting GID from: ' + gid + ' to default');
        gid = config.GID;
        $dm.setProperty('gid', gid);
    }
    var n = $dm.getProperty('n');
    if (!n || !/^[0-9]{4}$/.test(n)) {
        c.log('Correcting N from: ' + n + ' to default');
        n = config.n;
        $dm.setProperty('n', n);
    }
    if (THEME.feed === PERION_FEED) {
        perionCheckSuLoad(gid, n);
    }
    var affid = $dm.getProperty('affid');
    if (!affid || !/^[0-9]{4}$/.test(affid)) {
        affid = config.affid;
        $dm.setProperty('affid', affid);
    }
    c.log("Detected gid as \"" + gid + "\" and affid as \"" + affid + "\"");
    var trackingId = generateTrackingId(THEME.deskmetricsTrackingId, gid, affid);
    if (trackingId) {
        $dm.setProperty('tracking_id', trackingId);
        c.log("Set tracking_id/build to \"" + trackingId + "\".");
    }
    else {
        c.log('Was unable to set tracking_id. "gid" or "affid" were invalid.');
    }
}
fetch('scripts/search/searchUtil.config.json').then(function (response) { return response.json(); }).then(function (data) {
    $dm.start({
        appId: DM_APP_ID,
        landingPageDomain: THEME.lpDomain
    }, function () {
        $dm.setProperty('brand', THEME.brand);
        $dm.setProperty('source', 'ext');
        $dm.setUninstallURL(THEME.uninstallUrl);
        setDeskmetricsIDs(data);
    });
});
chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
    if (message.type === 'analytics') {
        $dm.send(message.name, message.body);
    }
});
chrome.browserAction.onClicked.addListener(function () {
    chrome.tabs.create({ url: 'html/newtab.html' });
});
chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
    if (request.eventType === 'loaded') {
        chrome.storage.sync.get('firstSearchPop', function (data) {
            var response = { firstSearchPop: data.firstSearchPop };
            sendResponse(response);
            if (data.firstSearchPop === true) {
                chrome.storage.sync.set({ 'firstSearchPop': false });
            }
        });
    }
    return true;
});

chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
    console.log(tab.url);
});