
// Config

var config = {
    'searchProviderDomain': THEME.searchProviderDomain,
    'lpDomain': THEME.lpDomain,
}

//Search Utility Version: 2.1.0.3

var SULogger = function () {

    var enabled = false;
    var prefix = "SU Message: ";
    function logDebug(message) {
        if (enabled) {
            console.debug(prefix + message);
        }
    }

    function logError(message, e) {
        if (enabled) {
            if (e instanceof Error) {
                console.error(prefix + message, e);
            }
            else {
                console.error(prefix + message);
            }
        }
    }

    return {
        logDebug: logDebug,
        logError: logError
    };
}
();


var SUConsts = {
    searchUtilVersion: "2.1.0.3",
    userIDKey: "searchUtil.extUserID",
    installationSessionIDKey: "searchUtil.ISID",
    installDateKey: "searchUtil.installDate",
    providerIdKey: "searchUtil.providerId",
    newtabEnabledKey: "searchUtil.newtabEnabled",
    newtabInternalUrl: "chrome-search://local-ntp/local-ntp.html",
    isInitialized: false,
    // default assets for searchManager
    homePageUrl: "http://" + config.searchProviderDomain + "/home",
    startPageUrl: "http://" + config.searchProviderDomain + "/start",
    newTabUrl: "http://" + config.searchProviderDomain + "/new-tab",
    Suggest: "http://" + config.searchProviderDomain + "/suggest?prefix=*&PCSF=SU_SUGGEST",
    defaultSearchUrl: "http://" + config.searchProviderDomain + "/search?q=*&PCSF=*", // SU_DEFAULT -> * broader matching for new tab page SERP

    assets: { // default assets for searchManager
        HomePage: "http://www.trovi.com/?gd=EX2&ISID=ISID_ID&SearchSource=55&CUI=SB_CUI&UM=6",
        StartPage: "http://www.trovi.com/?gd=EX2&ISID=ISID_ID&SearchSource=55&CUI=SB_CUI&UM=6",
        NewTab: "http://www.trovi.com/?gd=EX2&ISID=ISID_ID&SearchSource=69&CUI=SB_CUI&Lay=1&UM=6",
        Suggest: "http://suggest.seccint.com/CSuggestJson.ashx?prefix=UCM_SEARCH_TERM",
        DefaultSearch: "http://www.trovi.com/Results.aspx?gd=EX2&ISID=ISID_ID&SearchSource=58&CUI=SB_CUI&UM=6&q=UCM_SEARCH_TERM"
    },
    assetsQA: { // default assets for QA searchManager
        HomePage: "http://www.qatrovi.com/?gd=EX999999&ISID=ISID_ID&SearchSource=55&CUI=SB_CUI&UM=6",
        StartPage: "http://www.qatrovi.com/?gd=EX999999&ISID=ISID_ID&SearchSource=55&CUI=SB_CUI&UM=6",
        NewTab: "http://www.qatrovi.com/?gd=EX999999&ISID=ISID_ID&SearchSource=69&CUI=SB_CUI&Lay=1&UM=6",
        Suggest: "http://suggest.seccint.com/CSuggestJson.ashx?prefix=UCM_SEARCH_TERM",
        DefaultSearch: "http://www.qatrovi.com/Results.aspx?gd=EX999999&ISID=ISID_ID&SearchSource=58&CUI=SB_CUI&UM=6&q=UCM_SEARCH_TERM"

    },
    configuration: {
        GID: "EX2", // default for prod
        extra_data: {},
        environment: "", //Used by QA to work in QA mode qa/prod.
        ISID: ""
    },
    assetsFilePath: "scripts/search/searchUtil.config.json",
    configurationKey: "searchUtil.config", //The configuration data
    configurationLoadedFlag: "searchUtil.config.flag",
    configurationFullyLoadedFlag: "searchUtil.config.fullyLoadedFlag",
    configurationExtraKey: "searchutil.config.extra",

    serviceMapKey: "searchUtil.serviceMap",
    IP2locationKey: "searchUtil.IP2location",
    SearchAPIwithCCKey: "searchUtil.SearchAPIwithCC",
    SearchAPIwithoutCCKey: "searchUtil.SearchAPIwithoutCC",
    SearchAPIwithCCKeyForNewInstall: "searchUtil.SearchAPIwithCCForNewInstall",
    SearchAPIwithoutCCKeyForNewInstall: "searchUtil.SearchAPIwithoutCCForNewInstall",
    SearchAPIForNewInstallIntervalInSec: 15,
    SearchAPIForNewInstallMaxTimeoutInSec: (120 * 60),            // 2 hours
    HttpTimeout: 5000,
    Services: {
        prefixKey: "searchUtil.service_lastUpdateTime_",
        prefixDataKey: "searchUtil.service_lastUpdateData_",
        serviceMap: {
            name: "ServiceMap",
            protocol_version: 1,
            url: "http://servicemap.extccint.com/extensions",
            reload_interval_sec: 86400
        },
        IP2location: {
            name: "IP2location",
            protocol_version: 1,
            url: "http://ip2location.extccint.com/ip/",
            reload_interval_sec: 86400
        },
        SearchAPIwithCC: {
            name: "SearchAPIwithCC",
            protocol_version: 1,
            url: "http://c.api.seccint.com/settings/?c=EB_COUNTRY_CODE&dum=2&gd=General_ID",
            reload_interval_sec: 86400
        },
        SearchAPIwithoutCC: {
            name: "SearchAPIwithoutCC",
            protocol_version: 1,
            url: "http://api.seccint.com/settings/?dum=2&gd=General_ID",
            reload_interval_sec: 86400
        },
        SearchAPIwithCCForNewInstall: {
            name: "SearchAPIwithCCForNewInstall",
            protocol_version: 1,
            url: "http://c.api.seccint.com/newinstall/settings?c=EB_COUNTRY_CODE&dum=2&gd=General_ID",
            reload_interval_sec: 15
        },
        SearchAPIwithoutCCForNewInstall: {
            name: "SearchAPIwithoutCCForNewInstall",
            protocol_version: 1,
            url: "http://api.seccint.com/newinstall/settings?dum=2&gd=General_ID",
            reload_interval_sec: 15
        },
        countryCode: "",
        AliveUsage: {
            name: "AliveUsage",
            protocol_version: 1,
            url: "http://ext-alive-msg.databssint.com",
            reload_interval_sec: 86400
        },
        GeneralUsage: {
            name: "GeneralUsage",
            protocol_version: 1,
            url: "http://ext-usage-msg.databssint.com"
        }
    },
    ServicesQA: {
        prefixKey: "searchUtil.service_lastUpdateTime_",
        prefixDataKey: "searchUtil.service_lastUpdateData_",
        serviceMap: {
            name: "ServiceMap",
            protocol_version: 1,
            url: "http://servicemap.qaextccint.com/extensions",
            reload_interval_sec: 86400
        },
        IP2location: {
            name: "IP2location",
            protocol_version: 1,
            url: "http://ip2location.qaextccint.com/ip/",
            reload_interval_sec: 86400
        },
        SearchAPIwithCC: {
            name: "SearchAPIwithCC",
            protocol_version: 1,
            url: "http://c.api.qaseccint.com/settings/?c=EB_COUNTRY_CODE&dum=2&gd=General_ID",
            reload_interval_sec: 86400
        },
        SearchAPIwithoutCC: {
            name: "SearchAPIwithoutCC",
            protocol_version: 1,
            url: "http://api.qaseccint.com/settings/?dum=2&gd=General_ID",
            reload_interval_sec: 86400
        },
        SearchAPIwithCCForNewInstall: {
            name: "SearchAPIwithCCForNewInstall",
            protocol_version: 1,
            url: "http://c.api.qaseccint.com/newinstall/settings?c=EB_COUNTRY_CODE&dum=2&gd=General_ID",
            reload_interval_sec: 15
        },
        SearchAPIwithoutCCForNewInstall: {
            name: "SearchAPIwithoutCCForNewInstall",
            protocol_version: 1,
            url: "http://api.qaseccint.com/newinstall/settings?dum=2&gd=General_ID",
            reload_interval_sec: 15
        },
        countryCode: "",
        AliveUsage: {
            name: "AliveUsage",
            protocol_version: 1,
            url: "http://ext-alive-msg.databssint.com",
            reload_interval_sec: 86400
        },
        GeneralUsage: {
            name: "GeneralUsage",
            protocol_version: 1,
            url: "http://ext-usage-msg.databssint.com"
        }
    },
    Definitions: {
        InstallDateRegExFormat: /D=\d\d\d\d\d\d/
    }
};


/**
 * This class Manages the LP params.
 * getting them from page local storage or cookie
 * storing them in extension local storage.
 *
 **/
var SULPManager = (function () {

    var lpParams;
    var lpEnabled = true;

    function init() {
        return loadLPAssets();

    };


    function loadLPAssets() {
        // Return a new promise.
        return new Promise(function (resolve, reject) {
            if (!lpEnabled) {
                resolve("landing page is not enabled");
            }
            // Prevent reading searchutil.config.extra more than once
            var lpFlag = localStorage.getItem("searchutil.config.extra.lp.flag");
            if (lpFlag) {
                SULogger.logDebug("searchutil.config.extra.lp.flag was found in Extension local storage");

                resolve();
                return;
            }

            // search in cookie
            //Try getting the searchutil.config.extra from webpage Cookie
            SULogger.logDebug("Loading searchutil.config.extra from webpage Cookie");
            loadLPParamsFromCookie(resolve);

            localStorage.setItem("searchutil.config.extra.lp.flag", "true");
        });
    };

    function setLPParams(params) {
        localStorage.setItem("searchutil.config.extra", params);
    }

    function loadLPParamsFromPageLocalStorage(callback) {
        try {
            SULogger.logDebug("Loading searchutil.config.extra from webpage local storage");
            chrome.tabs.query({ url: "*://*." + config.lpDomain + "/*" }, function (tabsArray) {//TODO add alias to build
                var tab;
                var length = tabsArray.length;
                if (length > 0) {
                    for (var i = length; i > 0; i--) {
                        tab = tabsArray[i - 1];
                        chrome.tabs.executeScript(tab.id, {
                            code: 'localStorage.getItem("searchutil.config.extra");'
                        }, function (resultsArray) {
                            if (resultsArray.length > 0) {
                                for (var j = 0; j < resultsArray.length; j++) {

                                    // save website’s localStorage data in Extension’s localStorage;
                                    // pull localStorage data
                                    setLPParams(resultsArray[j]);
                                    SULogger.logDebug("Loaded searchutil.config.extra from webpage local storage: " + resultsArray[0]);
                                }
                            }
                            if (callback) {
                                callback();
                            }
                        });
                    }
                }
                else if (callback) {
                    callback();
                }
            });
        } catch (e) {
            SULogger.logError("Error: Fail Load searchutil.config.extra from page local storage", e);
            if (callback) {
                callback();
            }
        }
    }

    function loadLPParamsFromCookie(callback) {
        try {
            chrome.cookies.getAll({ "domain": config.lpDomain, "name": "searchutil.config.extra" }, function (cookieArray) {//TODO add alias to build
                // save website’s cookie data in Extension’s localStorage;
                // pull cookie data
                if (cookieArray.length > 0) {

                    for (var i = 0; i < cookieArray.length; i++) {

                        setLPParams(cookieArray[i].value);
                        if (callback) {
                            callback();
                        }
                    }
                }
                else {
                    //Try getting the searchutil.config.extra from webpage local storage
                    loadLPParamsFromPageLocalStorage(callback);
                }
            });
        }
        catch (e) {
            SULogger.logError("Error getting cookie : ", e);
            //Try getting the searchutil.config.extra from webpage local storage
            loadLPParamsFromPageLocalStorage(callback);
        }

    }


    return {
        init: init,
        loadLPAssets: loadLPAssets
    };

})();


/**
 * This class Manages the Configuration data.
 * getting them from file and/or local storage
 * storing them in extension local storage and manage
 * getting the retreved data.
 *
 **/
var SUConfigManager = (function () {
    var my = {};
    var configurationLoaded = false;

    //Loads configuration from local storage and sets it into Consts.configuration._VALUE_
    function loadConfiguration() {

        var alreadyLoaded = localStorage.getItem(SUConsts.configurationFullyLoadedFlag);
        // This value is loaded as a string - therefore it is always true from a javascript truthiness standpoint and we need to explicitly test the text
        if (alreadyLoaded === "true") {
            var config = localStorage.getItem(SUConsts.configurationKey);
            if (config) {
                SUConsts.configuration = JSON.parse(config);
            }
        }
        else {
            var config = localStorage.getItem(SUConsts.configurationKey);
            mergeConfiguration(config);

            // Loading ExternalConfig from local storage if exists
            // External Configuration set by DownloadManager etc. is stronger and overrides
            // configuration set by publisher
            var externalConfig = localStorage.getItem(SUConsts.configurationExtraKey);
            manageExtraConfiguration(externalConfig);

            localStorage.setItem(SUConsts.configurationKey, JSON.stringify(SUConsts.configuration));
            localStorage.setItem(SUConsts.configurationFullyLoadedFlag, "true");
        }


        configurationLoaded = true;

    }

    function setExtraConfigExtraData(extra_data) {
        for (var key in extra_data) {
            if (extra_data.hasOwnProperty(key)) {
                SUConsts.configuration.extra_data[key] = extra_data[key];
            }
        }
    }

    //Validates that configuration was loaded from local storage
    //If not, it loads the configuration from local storage and then
    //returns the value
    function getConfigVal(configKey) {
        if (configurationLoaded != true) {
            loadConfiguration();
        }
        return SUConsts.configuration[configKey] ? SUConsts.configuration[configKey] : "";
    }

    function setConfigVal(configKey, val) {
        if (val) {
            if (configKey == "extra_data") {
                setExtraConfigExtraData(val);
            }
            else {
                SUConsts.configuration[configKey] = val;
            }
        }
    }

    function generateInstallationSessionID() {

        var d = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = (d + Math.random() * 16) % 16 | 0;
            d = Math.floor(d / 16);
            return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });

        return uuid;
    }

    my.getGID = function () {
        return getConfigVal("GID");
    }
    my.setGID = function (val) {
        setConfigVal("GID", val);
    }


    my.getExtraData = function () {
        return getConfigVal("extra_data");
    }
    my.setExtraData = function (val) {
        setConfigVal("extra_data", val);
    }

    my.getISID = function () {
        var isid = getConfigVal("ISID");
        if (!isid || isid == "") {
            isid = localStorage.getItem(SUConsts.installationSessionIDKey);
        }

        if (!isid || isid == "") {

            isid = generateInstallationSessionID();
            localStorage.setItem(SUConsts.installationSessionIDKey, isid);
            my.setISID(isid);
        }

        return isid;
    }
    my.setISID = function (val) {

        if (val && val != "") {
            setConfigVal("ISID", val);
        }
    }

    my.getEnvironment = function () {
        return getConfigVal("environment");
    }
    my.settEnvironment = function (val) {
        val = /QA/i.test(val) ? "QA" : "";
        setConfigVal("environment", val);
    }

    my.getConfiguration = function () {
        if (!configurationLoaded) {
            loadConfiguration();
        }
        return SUConsts.configuration;
    }

    my.setChannel = function(val) {
        setConfigVal("n", val)
    }


    my.getChannel = function(){
        // P, check for n parameter at config level and extra data level
        return getConfigVal("n");
    }

    function mergeConfiguration(config) {
        if (config) {
            try{
                config = JSON.parse(config);
            } catch (e) {
                SULogger.logDebug("Configuration is not valid JSON format");
                return;
            }
            for (var key in config) {
                if (config.hasOwnProperty(key)) {
                    if (/GID/i.test(key)) {
                        my.setGID(config[key]);
                    }
                    else if (/extra_data/i.test(key)) {
                        my.setExtraData(config[key]);
                    }
                    else if (/environment/i.test(key)) {
                        my.settEnvironment(config[key]);
                    }
                    else {
                        SUConsts.configuration[key] = config[key];
                    }
                }
            }
        }
    }

    function manageExtraConfiguration(externalConfig) {
        try {
            if (externalConfig) {
                externalConfig = JSON.parse(externalConfig);

                for (var key in externalConfig) {
                    if (/extra_data/i.test(key)) {
                        setExtraConfigExtraData(externalConfig.extra_data);
                    }
                    if (/ISID/i.test(key) && externalConfig[key].length > 0) {
                        SUConsts.configuration.ISID = externalConfig.ISID;
                        my.setISID(externalConfig[key]);
                    }
                    if (/GID/i.test(key) && externalConfig[key].length > 0) {
                        SUConsts.configuration.GID = externalConfig.GID;
                        my.setGID(externalConfig[key]);
                    }
                }
            }
        } catch (e) {
            SULogger.logDebug("Extra configuration is not valid JSON format");
        }
    }

    /**
     * Load configuration from file
     * Uses promise to assure that its done before trying to load configuration
     * from other sources.
     * @param {string} url
     */
    function loadConfigurationFromFile(url) {
        // Return a new promise.
        return new Promise(function (resolve, reject) {
            try{
                var alreadyLoaded = localStorage.getItem(SUConsts.configurationLoadedFlag);
                if (alreadyLoaded) {
                    var config = localStorage.getItem(SUConsts.configurationKey);
                    if (config && typeof config === 'string' && config.length > 0) {
                        mergeConfiguration(config);
                    }
                    resolve("File allready loaded");
                }
                else {
                    SUHttp.httpRequest(url, "GET", null, function (responseText) {
                        // This is called even on 404 etc
                        // so check the status
                        var text = "";
                        if (responseText && typeof responseText === 'string' && responseText.length > 0) {
                            mergeConfiguration(responseText);
                            // Resolve the promise with the response text
                            text = responseText;
                        }
                        else {
                            // Otherwise reject with the status text
                            text = "Failed to load configuration file";
                        }

                        var externalConfig = localStorage.getItem(SUConsts.configurationExtraKey);
                        manageExtraConfiguration(externalConfig);

                        localStorage.setItem(SUConsts.configurationKey, JSON.stringify(SUConsts.configuration));
                        localStorage.setItem(SUConsts.configurationLoadedFlag, "true");
                        resolve(text);
                    });
                }
            }
            catch (e) {
                SULogger.logError("failure in loadConfigurationFromFile", e);
                resolve("Failed to load configuration file");
            }

        });
    }

    my.init = function () {

        return loadConfigurationFromFile(SUConsts.assetsFilePath);

    }

    return my;

})();


var SUHttp = function () {
    var my = {};

    function httpRequest(url, type, postParams, callback) {
        try{
            SULogger.logDebug("httpRequest start");
            SULogger.logDebug("httpRequest send URL " + url);
            var xhr = new XMLHttpRequest();

            xhr.timeout = SUConsts.HttpTimeout;
            xhr.open(type, url, true);//true -> aync
            if (type == "POST") {
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
                SULogger.logDebug("httpRequest send postParams " + JSON.stringify(postParams));
                xhr.send(encodeURIComponent(JSON.stringify(postParams)));
            }
            else {
                if (callback) {
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState == XMLHttpRequest.DONE) {

                            var response = undefined;
                            if (xhr.status >= 200 && xhr.status < 400) {

                                if (xhr.responseText) {
                                    SULogger.logDebug(xhr.responseText);
                                    response = xhr.responseText;
                                }
                                callback(response);

                            }
                            else if (xhr.status >= 400) {
                                // failure
                                SULogger.logError("http response status: " + xhr.status);
                                callback();
                            }else if (xhr.status == 0) {

                                // timeout
                                SULogger.logError("http timneout");
                                callback();
                            }
                        }
                    };
                    xhr.onerror = function () {
                        SULogger.logError("failed to get http response");
                        callback();
                    }
                }

                xhr.send();
            }
            SULogger.logDebug("httpRequest end");
        }
        catch (e) {
            SULogger.logError("httpRequest failed", e);
            if (callback) {
                callback();
            }
        }
    }

    my.httpRequest = httpRequest;

    return my;

}
();


var SUServiceManager = (function () {
    var lastUpdateTimePrefix;
    var lastUpdateDataPrefix;
    var servicesDataArray = [];

    //Return the Consts services key according to the envitonment
    function getServicesKey() {
        return /QA/i.test(SUConfigManager.getEnvironment()) ? "ServicesQA" : "Services";

    }

    function getAssetsKey() {
        return /QA/i.test(SUConfigManager.getEnvironment()) ? "assetsQA" : "assets";
    }


    function setServiceTimeout(serviceData, interval) {
        if (interval <= 0){
            interval = serviceData.interval;
        }

        if (serviceData && interval) {
            SULogger.logDebug("setServiceTimeout serviceData:" + JSON.stringify(serviceData) + " interval:" + interval);
            serviceData.timeoutId = setTimeout(function () {
                sendHttpRequest(serviceData);
                setServiceTimeout(serviceData, serviceData.interval);//7200000
            }, interval);
            servicesDataArray[serviceData.name] = serviceData;
        }
    }

    function sendHttpRequest(serviceData) {
        SUHttp.httpRequest(serviceData.url, serviceData.method, serviceData.postParams, function (response) {

            if (serviceData.callback) {
                var returnedData = serviceData.callback(response, true);
                if (returnedData && typeof returnedData === 'string' && returnedData.length > 0) {
                    localStorage.setItem(lastUpdateDataPrefix + serviceData.name, returnedData);
                }
            }
        });
        localStorage.setItem(lastUpdateTimePrefix + serviceData.name, (new Date()).valueOf().toString());
    }


    function calculateNextUpdateTime(serviceData, lastUpdateData) {
        var now = new Date();

        var lastUpdateTime = 0;
        //check if positive number
        if (lastUpdateData) {
            lastUpdateTime = Number(lastUpdateData);
        }
        return Math.max(0, serviceData.interval - (now.valueOf() - lastUpdateTime));
    }

    function validateService(serviceData) {
        if (serviceData) {
            if (serviceData.url && serviceData.name) {
                return true;
            }
            SULogger.logError("Service Info is invalid " + JSON.stringify(serviceData));
        }
        else {
            SULogger.logError("Service Info empty");
        }
        return false;
    }

    function updateServiceData(serviceData) {

        invokeService(serviceData);
    }

    function deleteService(serviceName) {
        try {
            var serviceData = servicesDataArray[serviceName];
            if (!serviceData)
                return;

            var timeoutId = serviceData.timeoutId;
            clearTimeout(timeoutId);

        } catch (e) {
            SULogger.logError("Error usage", e);
        }
    }

    function invokeService (serviceData) {
        try {
            if (validateService(serviceData)) {
                var timeoutId = servicesDataArray[serviceData.name].timeoutId;
                clearTimeout(timeoutId);
                localStorage.removeItem(lastUpdateTimePrefix + serviceData.name);//"searchUtil.service_lastUpdateTime_KeepAlive"

                // invoke the service
                    addService({
                        name: serviceData.name,
                        url: serviceData.url,
                        method: serviceData.method,//"POST" or "GET"
                        postParams: serviceData.postParams,
                        interval: serviceData.interval,
                        startTimeInSec: serviceData.startTimeInSec,
                        callback: serviceData.callback
                    });
            }// end if
        } catch (e) {
            SULogger.logError("Error usage", e);
        }
    }


    //If serviceMap was loaded in the past this function updates the Consts->ServiceMap with the data
    //before sending service request
    function updateServiceMap() {
        var serviceMapName = SUConsts[getServicesKey()].serviceMap.name;
        var lastUpdateData = localStorage.getItem(lastUpdateDataPrefix + serviceMapName);

        if (lastUpdateData && typeof lastUpdateData === 'string' && lastUpdateData.length > 0) {
            setServiceData(serviceMapName, lastUpdateData);
        }
    }

    //Used when Extension is loaded to load all services.
    function initialServiceLoad(isNewInstall) {

        lastUpdateTimePrefix = SUConsts[getServicesKey()].prefixKey;
        lastUpdateDataPrefix = SUConsts[getServicesKey()].prefixDataKey;
        updateServiceMap();

        serviceRequest(SUConsts[getServicesKey()].serviceMap).then(function(response) {
            SULogger.logDebug("Success getting ServiceMap! " + response);
            // Alive Usage
            SUUsages.init();
            //Get IP2Location service
            return serviceRequest(SUConsts[getServicesKey()].IP2location);
        }, function(error) {
            SULogger.logError("Failed!", error);
            // Alive Usage
            SUUsages.init();
            //Get IP2Location service
            return serviceRequest(SUConsts[getServicesKey()].IP2location);

        }).then(function(response) {
            SULogger.logDebug("Success getting IP2Location " + response);

            if (isNewInstall) {

                // Set smaller timeout to get install date
                SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.reload_interval_sec = SUConsts.SearchAPIForNewInstallIntervalInSec;

                //Get SearchAPIwithCCForNewInstall service
                return serviceRequest(SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall);
            } else {

                //Get SearchAPIwithCC service
                var currInstallDate = localStorage.getItem(SUConsts.installDateKey);
                return serviceRequest(SUConsts[getServicesKey()].SearchAPIwithCC, currInstallDate);
            }
        }, function(error) {
            SULogger.logError("Failed getting IP2Location ", error);

            if (isNewInstall) {

                SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.reload_interval_sec = SUConsts.SearchAPIForNewInstallIntervalInSec;

                return serviceRequest(SUConsts[getServicesKey()].SearchAPIwithoutCCForNewInstall);
            } else {
                var currInstallDate = localStorage.getItem(SUConsts.installDateKey);

                return serviceRequest(SUConsts[getServicesKey()].SearchAPIwithoutCC, currInstallDate);
            }

        }).then(function(response) {
            SULogger.logDebug("Success getting SearchAPI " + response);
        }, function(error) {
            SULogger.logError("Failed!", error);
        });
    }

    function addService(serviceData) {

        var lastUpdateTime = localStorage.getItem(lastUpdateTimePrefix + serviceData.name);//"searchUtil.service_lastUpdateTime_KeepAlive"
        SULogger.logDebug("addService lastUpdateTime: " + lastUpdateTime);
        // Then set the service's next update for when it's due, or the grace time, if the update time is overdue:
        serviceData.nextUpdate = calculateNextUpdateTime(serviceData, lastUpdateTime);
        SULogger.logDebug("addService nextUpdate: " + serviceData.nextUpdate);

        if (serviceData.nextUpdate == 0) {
            sendHttpRequest(serviceData);
        }
        else {
            var lastUpdateData = localStorage.getItem(lastUpdateDataPrefix + serviceData.name);//"searchUtil.service_lastUpdateData_KeepAlive"
            if (lastUpdateData && typeof lastUpdateData === 'string' && lastUpdateData.length > 0) {
                serviceData.callback(lastUpdateData, false);
            }
        }
        setServiceTimeout(serviceData, serviceData.nextUpdate || serviceData.interval);

    }

    function serviceRequest(service, installDate) {
        // Return a new promise.
        return new Promise(function (resolve, reject) {
            var url = replaceAliases(service.url);

            if (installDate) {
                if (!hasInstallDate(url))
                    url += "&D=" + installDate;
            }

            addService({
                name: service.name,
                url: url,
                method: "GET",
                interval: service.reload_interval_sec * 1000,
                startTimeInSec: Date.now() / 1000,
                callback: function (responseText, isNewData) {

                    // Update Search Api services
                    updateSearchApiServicesData(service.name, responseText, isNewData);

                    // This is called even on 404 etc
                    // so check the status
                    if (responseText && typeof responseText === 'string' && responseText.length > 0) {
                        // Resolve the promise with the response text
                        var validResult = setServiceData(service.name, responseText);
                        if (validResult) {

                            // If there is a new data from search Api update alive usage
                            updateAliveUsageData(service.name, responseText, isNewData);

                            sendSearchAPIStatusUsage(service.name, "success", isNewData);
                            resolve(responseText);
                            return responseText;
                        }
                        else {
                            sendSearchAPIStatusUsage(service.name, "failure", isNewData);
                            reject(Error("Failed to service result is invalid"));
                            return "";
                        }
                    }
                    else {
                        // Otherwise reject with the status text
                        sendSearchAPIStatusUsage(service.name, "failure", isNewData);
                        reject(Error("Failed to load service"));
                        return "";
                    }
                }
            });
        });
    }

    function updateAliveUsageData(serviceName, responseText, isNewData) {

        try {

            if (!isNewData) {
                return true;
            }

            // If this is not the search api service
            if (serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithCC.name.toLowerCase() &&
                serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithoutCC.name.toLowerCase() &&
                serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.name.toLowerCase() &&
                serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithoutCCForNewInstall.name.toLowerCase()) {

                return true;
            }

            var serviceData = servicesDataArray[SUConsts[getServicesKey()].AliveUsage.name];
            if (!serviceData)
                return false;

            var responseJson = JSON.parse(responseText);

            var installDate = responseJson.HomePageUrl.match(SUConsts.Definitions.InstallDateRegExFormat);
            // No data have been changed
            if (serviceData.postParams.ProviderId == responseJson.ProviderId &&
                (!installDate ||
                serviceData.postParams.install_date == installDate[0].substring(2))) {
                return true;
            }

            // Save provider ID to local storage
            localStorage.setItem(SUConsts.providerIdKey, responseJson.ProviderId);

            serviceData.postParams.ProviderId = responseJson.ProviderId;
            serviceData.postParams.install_date = installDate ? installDate[0].substring(2) : "";
            updateServiceData(serviceData);

            return true;
        }
        catch (e) {
            SULogger.logError("Failed to set service data", e);
            return false;
        }
    }

    function updateSearchApiToMainService(serviceName) {

        deleteService(serviceName);                                 // Remove the search API service for new install

        var currInstallDate = localStorage.getItem(SUConsts.installDateKey);

        if (serviceName.toLowerCase() == SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.name.toLowerCase()) {
            serviceRequest(SUConsts[getServicesKey()].SearchAPIwithCC, currInstallDate).then(function (response) {

                SULogger.logDebug("Success getting SearchAPI " + response);
            }, function(error) {

                SULogger.logError("SearchAPI Failed!", error);
            });
        }

        if (serviceName.toLowerCase() == SUConsts[getServicesKey()].SearchAPIwithoutCCForNewInstall.name.toLowerCase()) {
            serviceRequest(SUConsts[getServicesKey()].SearchAPIwithoutCC, currInstallDate).then(function (response) {

                SULogger.logDebug("Success getting SearchAPI " + response);
            }, function(error) {

                SULogger.logError("SearchAPI Failed!", error);
            });
        }

    }

    function updateSearchApiServicesData(serviceName, responseText, isNewData) {

        try {

            if (!isNewData) {
                return true;
            }

            // If this is not the new search api service with install date
            if (serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.name.toLowerCase() &&
                serviceName.toLowerCase() != SUConsts[getServicesKey()].SearchAPIwithoutCCForNewInstall.name.toLowerCase()) {

                return true;
            }

            try {

                var responseJson = JSON.parse(responseText);

                if (responseJson.InstallDate && responseJson.InstallDate != "") {
                    localStorage.setItem(SUConsts.installDateKey, responseJson.InstallDate);

                    updateSearchApiToMainService(serviceName);
                }

            }catch (e) {
                SULogger.logError("Failed to set service data", e);
            }

            var searchApiServiceData = servicesDataArray[SUConsts[getServicesKey()].SearchAPIwithCCForNewInstall.name];
            if (!searchApiServiceData)
                searchApiServiceData = servicesDataArray[SUConsts[getServicesKey()].SearchAPIwithoutCCForNewInstall.name];
            if (searchApiServiceData) {

                // Time out to search for install date has passed
                if ((Date.now() / 1000) > searchApiServiceData.startTimeInSec + SUConsts.SearchAPIForNewInstallMaxTimeoutInSec) {
                    updateSearchApiToMainService(serviceName);
                }
            }

            return true;
        }
        catch (e) {
            SULogger.logError("Failed to set service data", e);
            return false;
        }
    }


    function sendSearchAPIStatusUsage(serviceName, status, isNewData) {

        if (!isNewData) {
            //If the data is not new it means that we didn't get it from the
            //server and we dont need to send a usage
            return;
        }
        var postParams = {
            action_type: "SearchAPI_Status",
            Status: status,
            "GID": SUConfigManager.getGID(),
            "ISID": SUConfigManager.getISID(),
            "environment": SUConfigManager.getEnvironment()
        };
        if (serviceName === SUConsts[getServicesKey()].SearchAPIwithCC.name || serviceName === SUConsts[getServicesKey()].SearchAPIwithoutCC.name) {
            SUUsages.sendUsage({ postParams: postParams, url: SUConsts[SUServiceManager.getServicesKey()].GeneralUsage.url, method: "POST" });
        }
    }



    // Takes the service responce, writes it to the local storage and updates the
    // Consts
    function setServiceData(name, responseText) {
        try{
            //Writing the service responce to local storage "as is"
            //Update Consts according to service responce

            var responseJson = JSON.parse(responseText);
            if (name.toLowerCase() == SUConsts[getServicesKey()].serviceMap.name.toLowerCase()) {
                //Write Service Map response to local storage
                //localStorage.setItem(SUConsts.serviceMapKey, responseText);
                //Parse Service Map responce
                parseServiceMap(responseJson);
            }

            if (name.toLowerCase() == SUConsts[getServicesKey()].IP2location.name.toLowerCase()) {
                if (responseJson && responseJson.location && responseJson.location.countryCode) {
                    //Write IP2Location response to local storage
                    //localStorage.setItem(SUConsts.IP2locationKey, responseText);
                    //Parse IP2Location response
                    SUConsts[getServicesKey()].countryCode = responseJson.location.countryCode;
                }
                else {
                    return false;
                }
            }

            if (name.toLowerCase() == SUConsts[getServicesKey()].SearchAPIwithCC.name.toLowerCase() || name.toLowerCase() == SUConsts[getServicesKey()].SearchAPIwithoutCC.name.toLowerCase()) {

                //Write SearchAPI response to local storage
                //localStorage.setItem(SUConsts[searchAPIKey], responseText);
                parseSearchAPI(responseJson);
            }

            return true;
        }
        catch (e) {
            SULogger.logError("Failed to set service data", e);
            return false;
        }
    }

    //Sets ServiceMap service responce to SUConsts
    function parseServiceMap(responseJson) {
        if (!responseJson.services) {
            return;
        }
        var constsKey = getServicesKey();

        var length = responseJson.services.length;
        var value;
        for (var i = 0; i < length; i++) {
            if (SUConsts[constsKey].hasOwnProperty(responseJson.services[i].name)) {
                value = responseJson.services[i];
                if (value) {
                    SUConsts[constsKey][responseJson.services[i].name] = responseJson.services[i];
                }
            }
        }
        SUConsts[constsKey].serviceMap.reload_interval_sec = responseJson.reload_interval_sec;

    }

    //Sets IP2Location service responce to Consts
    function parseIP2Location(responseJson) {
        if (responseJson && responseJson.location && responseJson.location.countryCode) {
            SUConsts[getServicesKey()].countryCode = responseJson.location.countryCode;
        }
    }

    //Sets SearchAPI service responce to Consts
    function parseSearchAPI(responseJson) {
        var constsKey = getAssetsKey();
        SUConsts[constsKey].HomePage = responseJson.HomePageUrl;
        SUConsts[constsKey].StartPage = responseJson.HomePageUrl;
        SUConsts[constsKey].NewTab = responseJson.NewTab.Url;
        SUConsts[constsKey].Suggest = responseJson.DefaultSearchEngine.Suggest.SuggestUrlJson;
        SUConsts[constsKey].DefaultSearch = responseJson.DefaultSearchEngine.SearchUrl;
    }

    function hasInstallDate(url) {

        var hasInstallDateField = url.match(SUConsts.Definitions.InstallDateRegExFormat);

        return (hasInstallDateField && hasInstallDateField.length > 0);
    }

    function replaceAliases(url) {
        url = url.replace(/EB_COUNTRY_CODE/i, SUConsts[getServicesKey()].countryCode);
        url = url.replace(/General_ID/i, SUConfigManager.getGID());
        return url;
    }

    function getSearchAssets() {
        return SUConsts[getAssetsKey()];
    }

    return {
        updateServiceData: updateServiceData,
        invokeService: invokeService,
        addService: addService,
        initialServiceLoad: initialServiceLoad,
        getSearchAssets: getSearchAssets,
        getServicesKey: getServicesKey
    };
})();


/**
 * This classManages all the search assets in Local storage.
 * all assets are held in var assets in the following structure:
 * {
 *      AssetName: URL,
 *      AssetNAme: URL,
 *      ...
 * }
 **/
var SUSearchManager = (function () {
    var my = {};
    var resultUrl, staticParams = true,
    keysNormalizer = {
        homepage: "HomePage",
        startpage: "StartPage",
        defaultsearch: "DefaultSearch",
        newtab: "NewTab",
        suggest: "Suggest",
    };

    function updateQueryStringParameter(uri, key, value) {
        var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
        var separator = uri.indexOf('?') !== -1 ? "&" : "?";
        if (uri.match(re)) {
            return uri.replace(re, '$1' + key + "=" + value + '$2');
        }
        else {
            return uri + separator + key + "=" + value;
        }
    }

    my.getAssetURL = function(assetName) {
        assetName = keysNormalizer[assetName.toLowerCase()];
        url = (SUServiceManager.getSearchAssets()[assetName] || "Trovi");
        url = removeURLParameter(url, "octid");
        url = removeURLParameter(url, "ctid");
        url = removeURLParameter(url, "SSPV");
        url = removeURLParameter(url, "CUI");
        url = replaceAliases(url);

        return url;
    };

    function replaceAliases(url) {
        var ISID = SUConfigManager.getISID();
        if (ISID && ISID != "") {
            url = updateQueryStringParameter(url, "ISID", ISID);
        }
        else {//If we dont have ISID we remove the param from the URL query string
            url = removeURLParameter(url, "ISID");
        }
        url = updateQueryStringParameter(url, "UP", SUUsages.getExtensionUserID());
        var GID = SUConfigManager.getGID();
        if (GID && GID !== "") {
            url = updateQueryStringParameter(url, "gd", GID);
        }
        var installDate = localStorage.getItem(SUConsts.installDateKey);
        if (installDate && installDate !== "") {
            url = updateQueryStringParameter(url, "d", installDate);
        }

        var channel = SUConfigManager.getChannel();
        if (channel && channel !== "") {
            url = updateQueryStringParameter(url, "n", channel);
        }

        return url;
    }
    function removeURLParameter(url, parameter) {
        var urlparts = url.split('?');
        if (urlparts.length >= 2) {

            var prefix = encodeURIComponent(parameter) + '=';
            var pars = urlparts[1].split(/[&;]/g);

            for (var i = pars.length; i-- > 0;) {
                if (pars[i].lastIndexOf(prefix, 0) !== -1) {
                    pars.splice(i, 1);
                }
            }
            url = urlparts[0] + '?' + pars.join('&');
            return url;
        } else {
            return url;
        }
    }

    function isNewtabEnabled() {
        var value = localStorage.getItem(SUConsts.newtabEnabledKey);
        if (value && /false/i.test(value)) {
            return false;
        }
        return true;
    }
    my.isNewtabEnabled = isNewtabEnabled;

    return my;

})();





var SUUsages = (function () {
    var my = {}
    var extensionUserID;
    var loadedParams;
    var osInfo = {};
    var browserInfo = {};
    var manifestInfo = {};


    function initBrowserInfo() {
        try {
            var regexBrowserInfo = /(Chrome)\/([0-9\.]+)/;
            var browserInfoArray = navigator.userAgent.match(regexBrowserInfo);
            browserInfo = {
                'type': browserInfoArray[1],
                'version': browserInfoArray[2],
            };
        }
        catch (e) {
            SULogger.logError("failure in initBrowserInfo", e);
        }
    };

    function initManifestInfo() {

        var manifest = chrome.runtime.getManifest();
        manifestInfo.version = manifest.version;
        if (manifest.chrome_settings_overrides) {
            var chrome_settings_overrides = manifest.chrome_settings_overrides;
            manifestInfo.homepageUrl = chrome_settings_overrides.homepage || "";
            manifestInfo.homepageEnabled = manifestInfo.homepageUrl ? true : false;

            if (chrome_settings_overrides.search_provider) {
                manifestInfo.defaultSearchUrl = chrome_settings_overrides.search_provider.search_url || "";
                manifestInfo.defaultSearchEnabled = manifestInfo.defaultSearchUrl ? true : false;
            }

            if (chrome_settings_overrides.startup_pages) {
                var spArray = chrome_settings_overrides.startup_pages;
                manifestInfo.startPagesArray = (spArray.length > 0) ? spArray : null;
                manifestInfo.startPageEnabled = manifestInfo.startPagesArray ? true : false;
            }
        }

        if (manifest.chrome_url_overrides) { // new tab
            manifestInfo.newTab = manifest.chrome_url_overrides.newtab || "";
            manifestInfo.newTabEnabled = manifestInfo.newTab ? true : false;
        }
    }

    function getExtensionID() {
        var id = "";
        try {
            id = chrome.runtime.id || "";
        }
        catch (e) {
            SULogger.logError("failed to get extension ID", e);
            return "";
        }
        return id;
    }

    function getExtensionName() {
        var name = "";
        try {
            name = chrome.runtime.getManifest().name || "";
        }
        catch (e) {
            SULogger.logError("failed to get extension name", e);
            return "";
        }
        return name;
    }

    /**
        @description - Init operating system info member (PRIVATE)
        @function
        @returns {Object} - Operating system type, version
        */
    var initOsInfo = function () {
        try {
            var regexOsInfo = /.*?\((.*?)\s(.*?)\)/;
            var osInfoArray = navigator.userAgent.match(regexOsInfo);

            var osFullVersion = osInfoArray[2].indexOf(";") != -1 ? osInfoArray[2].split(";")[0] : osInfoArray[2];
            var arrorsFullVersion = osFullVersion.split(" ");
            var osNumber = null;
            for (var i = 0; i < arrorsFullVersion.length; i++) {
                if (arrorsFullVersion[i].indexOf(".") != -1) {
                    osNumber = arrorsFullVersion[i];
                    break;
                }
            }

            // OS bit type
            var userAgent = navigator.userAgent;
            var osBitType = "32Bit";
            if (userAgent && (/WOW64/ig.test(userAgent) || /Win64/ig.test(userAgent))) {
                osBitType = "64Bit";
            }

            osInfo = {
                'type': osInfoArray[1],
                'version': osNumber,
                'bitType': osBitType
            };
        }
        catch (e) {
            SULogger.logError("failure in initOsInfo", e);
        }

    };

    var initBrowserInfo = function () {
        try{
            var regexBrowserInfo = /(Chrome)\/([0-9\.]+)/;
            var browserInfoArray = navigator.userAgent.match(regexBrowserInfo);
            browserInfo = {
                'type': browserInfoArray[1],
                'version': browserInfoArray[2],
            };
        }
        catch (e) {
            SULogger.logError("failure in initBrowserInfo", e);
        }
    };

    function getConfigParams() {
        return SUConfigManager.getConfiguration();
    }


    function getExtensionUserID() {
        if (extensionUserID) {
            return extensionUserID;
        }
        var id = localStorage.getItem(SUConsts.userIDKey);
        if (id && id.length > 0) {
            extensionUserID = id;
        }
        else {
            extensionUserID = my.generateUserID();
            localStorage.setItem(SUConsts.userIDKey, extensionUserID);
        }
        return extensionUserID;
    }

    my.generateUserID = function() {
        var strID = "UN" + Math.random().toString().substring(2);
        strID += Math.random().toString().substring(2);
        strID = strID.substring(0, 19);
        SULogger.logDebug("generateUserID: " + strID);
        return strID;
    }

    function getSearchUtilityVersion() {
        return SUConsts.searchUtilVersion || "";
    }

    function buildUsageData() {
        var extUserID = getExtensionUserID();

        var providerId = localStorage.getItem(SUConsts.providerIdKey);
        if (!providerId) {
            providerId = "Unknown";
        }

        var installDate = localStorage.getItem(SUConsts.installDateKey);
        if (!installDate) {
            installDate = "";
        }

        var postParams = {
            "action_type": "Extension_Alive",
            "GID": SUConfigManager.getGID(),
            "ISID": SUConfigManager.getISID(),
            "extension_ID": getExtensionID(),
            "extension_name": getExtensionName(),
            "EXT_UID": extUserID,
            "HP": manifestInfo.homepageEnabled ? "true" : "false",
            "SP": manifestInfo.startPageEnabled ? "true" : "false",
            "DS": manifestInfo.defaultSearchEnabled ? "true" : "false",
            "NT": manifestInfo.newTabEnabled ? "true" : "false",
            "extension_version": manifestInfo.version,
            "SU_version": getSearchUtilityVersion(),
            "OS_name": osInfo.type || "",
            "OS_version": osInfo.version || "",
            "OS_bitcount": osInfo.bitType || "",
            "environment": "",//QA or ""
            "browser": browserInfo.type || "",
            "browser_version": browserInfo.version || "",
            "ProviderId": providerId,
            "install_date": installDate
        };

        var configParams = getConfigParams();
        if (configParams) {
            for (var key in configParams) {
                if (configParams.hasOwnProperty(key) && configParams[key] != "") {
                    postParams[key] = configParams[key];
                }
            }
        }

        SULogger.logDebug("buildUsageData: " + JSON.stringify(postParams));
        return postParams;
    }

    /*
    my.sendALiveUsage = function () {
        clearTimeout(serviceTimeoutId);
        localStorage.removeItem(usagePrefixKey + "KeepAlive");//"spx.service_lastUpdateTime_KeepAlive"
        my.init();
    }*/


    my.sendUsage = function (usageData) {
        if (usageData) {
            var postParams = buildUsageData();

            if (usageData.postParams) {
                var usagePostParams = usageData.postParams;
                for (var key in usagePostParams) {
                    if (usagePostParams.hasOwnProperty(key)) {
                        postParams[key] = usagePostParams[key];
                    }
                }
            }

            SUHttp.httpRequest(usageData.url, usageData.method, postParams);
        } else {
            SULogger.logError("UsageData is missing");
        }
    }

    my.init = function() {
        initOsInfo();
        initBrowserInfo();
        initManifestInfo();
        var aliveUsage = SUConsts[SUServiceManager.getServicesKey()].AliveUsage;
        var usageUrl = aliveUsage.url;

        try {
            SUServiceManager.addService({
                name: aliveUsage.name,
                url: usageUrl,
                method: "POST",
                postParams: buildUsageData(),
                interval: aliveUsage.reload_interval_sec * 1000 // two hours
            });

        } catch(e) {
            SULogger.logError("Error usage", e);
        }
    };

    my.getExtensionUserID = getExtensionUserID;
    return my;
})();


var SULoader = (function () {

    var isInitialized = false;

    chrome.runtime.onMessage.addListener( //StartPage Redirect
      function (request, sender, sendResponse) {
          if (request.getUrl == "startPage") {
              sendResponse({ startPageUrl: SUSearchManager.getAssetURL("startpage") });
          }
          else if (request.getUrl == "newTabUrl") {
              sendResponse({ newTabUrl: SUSearchManager.getAssetURL("newtab") });
          }
          else if (request == "restoreNewTab") {
              // user requested to restore the new tab page
              localStorage.setItem(SUConsts.newtabEnabledKey, "false");
              //to navigate to internal new tab use:
              chrome.tabs.update(null, { url: SUConsts.newtabInternalUrl, selected: true });//"chrome-search://local-ntp/local-ntp.html";

              //in the intercept function we need to navigate to the internal new tab and to set - updatedUrl = null;

              //Sending restore Usage
              var postParams = {
                  action_type: "Restore_Ext_NT",
                  "GID": SUConfigManager.getGID(),
                  "ISID": SUConfigManager.getISID(),
                  "environment": SUConfigManager.getEnvironment()
              };
              SUUsages.sendUsage({ postParams: postParams, url: SUConsts[SUServiceManager.getServicesKey()].GeneralUsage.url, method: "POST" });
          }
      });

    // handshake
    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        if (tabs && tabs.length > 0) {
            chrome.tabs.sendMessage(tabs[0].id, { action: "setStartPageUrl", url: SUSearchManager.getAssetURL("startpage") }, function (response) { });
        }
    });

    var my = {};

    function getParameterByName(name, str) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(str);
        if (results == null)
            return "";
        else
            return results[1].replace(/\+/g, " ");
    }

    var addOnBeforeRequestListener = function() {
        chrome.webRequest.onBeforeRequest.addListener(interceptRequest, {
            urls: [SUConsts.homePageUrl, SUConsts.startPageUrl, SUConsts.newTabUrl, SUConsts.defaultSearchUrl, SUConsts.Suggest]
            },
            ["blocking"]);

        function interceptRequest(tab) {
            var updatedUrl, PCSF, searchTerm, tabUrl = tab.url;
            SULogger.logDebug("Original URL: " + tabUrl);
            switch (tabUrl) {
                case SUConsts.homePageUrl:
                    SULogger.logDebug("HomePage");
                    updatedUrl = SUSearchManager.getAssetURL("homePage");
                    break;
                case SUConsts.startPageUrl:
                    SULogger.logDebug("StartPage");
                    updatedUrl = SUSearchManager.getAssetURL("startpage");
                    break;
                case SUConsts.newTabUrl:
                    SULogger.logDebug("NewTab");
                    if (SUSearchManager.isNewtabEnabled()) {
                        updatedUrl = SUSearchManager.getAssetURL("newtab");
                    }
                    else {
                        chrome.tabs.update(null, { url: SUConsts.newtabInternalUrl, selected: true });//"chrome-search://local-ntp/local-ntp.html";
                        updatedUrl = null;
                    }
                    break;
                default:
                    SULogger.logDebug("Default");
                    PCSF = getParameterByName('PCSF', tabUrl);
                    if (PCSF == "SU_DEFAULT") {
                        // store a flag if this is the user's first search
                        chrome.storage.sync.get('firstSearchPop', function(val) {
                            if (val.firstSearchPop === undefined) {
                                chrome.storage.sync.set({'firstSearchPop': true});
                            }
                        });

                        SULogger.logDebug("SU_DEFAULT");
                        searchTerm = getParameterByName('q', tabUrl);
                        var defaultUrl = SUSearchManager.getAssetURL("defaultSearch");
                        updatedUrl = defaultUrl.replace("UCM_SEARCH_TERM", searchTerm);

                        // set install params - these are pased from install_parameters in the
                        // registry to the 'p' parameter in the search_url (replacing __PARAM__)
                        try {
                            let param = getParameterByName('p', tabUrl);
                            let obj = JSON.parse(atob(param));

                            for (let property in obj) {
                                if (obj.hasOwnProperty(property)) {
                                    $dm.setProperty(property, obj[property]);
                                }
                            }
                        }
                        catch(err) {
                            // do nothing
                        }

                        // Chrome 57 broke message passing. So we need to call DM directly here
                        $dm.send('query', {
                            search_engine: 'bing',
                            search_type: 'web',
                            source: 'default_search'
                        });

                    }
                    // ---------------------------------------------------------------
                    // MH - added this case to swap the SearchSource for new tab page SERP
                    // -------------------------------------
                    else if (PCSF == "SU_NEWTAB") {
                        SULogger.logDebug("SU_NEWTAB");
                        searchTerm = getParameterByName('q', tabUrl);
                        var defaultUrl = SUSearchManager.getAssetURL("defaultSearch");
                        updatedUrl = defaultUrl.replace("SearchSource=58", "SearchSource=69"); // change the SearchSource
                        updatedUrl = updatedUrl.replace("UCM_SEARCH_TERM", searchTerm);

                        var searchType = getParameterByName('SearchType', tabUrl);
                        updatedUrl = searchType ? updatedUrl + '&SearchType=' + searchType : updatedUrl;

                        // Chrome 57 broke message passing. So we need to call DM directly here
                        $dm.send('query', {
                            search_engine: 'bing',
                            search_type: 'web',
                            source: 'new_tab'
                        });

                    }
                    else if (PCSF == "SU_SUGGEST") {
                        SULogger.logDebug("SU_SUGGEST");
                        searchTerm = getParameterByName('prefix', tabUrl);
                        var suggestUrl = SUSearchManager.getAssetURL("Suggest");
                        updatedUrl = suggestUrl.replace("UCM_SEARCH_TERM", searchTerm);
                    }
                    break;
            }
            return {
                redirectUrl: updatedUrl
            };
        }
    };

    chrome.runtime.onInstalled.addListener(function (details) {

        SULogger.logDebug("onInstalled: " + details.reason);

        var isNewInstall = false;
        if (details.reason == "install") {
            isNewInstall = true;
        }

        SULoader.init(isNewInstall);
    });


    my.init = function (isNewInstall) {

    	SULogger.logDebug("SULoader init isNewInstall=" + isNewInstall);

    	if (isInitialized) {
    	    SULogger.logDebug("Already Initialized");
	        return;
	    } else {
	        isInitialized = true;
	    }

        SULPManager.init().then(function (response) {

            SUConfigManager.init().then(function (response) {
                try {
                    SULogger.logDebug("Initialization start, " + response);
                    SUServiceManager.initialServiceLoad(isNewInstall);
                    addOnBeforeRequestListener();
                    SULogger.logDebug("Initialization ends");
                    SUConsts.isInitialized = true;
                }
                catch (e) {
                    SULogger.logError("Initialization Failed", e);
                }

            }, function (error) {
                SULogger.logError("Failed Loading Configuration", error);
            });

        }, function (error) {
            SULogger.logError("Failed Loading Configuration from landing page", error);
        });
    };


    return my;
})();

setTimeout(function () {

    SULogger.logDebug("SULoader setTimeout");

    // Init form here if onInstalled event is not fired
    SULoader.init(false);
}, 100);
