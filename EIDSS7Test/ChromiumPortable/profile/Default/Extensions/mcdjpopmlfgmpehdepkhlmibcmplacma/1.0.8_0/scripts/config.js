var FALLBACK_IMAGES_COUNT = 5;
var OPTION_COLORS = [
    'E05242',
    'E38209',
    'FFCF31',
    '4889F8',
    '00A15B',
    '631F6C',
    'A521D7',
    'F541CF',
    '1FA6AB',
    '555555',
    'AAAAAA',
    'FFFFFF',
    '000000'
];
var DM_APP_ID = '8Uf3952f05';
var DEFAULT_OPTIONS = {
    backgroundColor: THEME.backgroundColor,
    backgroundImage: THEME.backgroundImage
};
var DEFAULT_SEARCH = {
    engine: THEME.defaultSearch,
    type: 'web'
};
var SEARCH_ENGINES = {
    'fallback': 'https://www.bing.com/search?q={{%q}}',
    'google': {
        'web': 'https://www.google.com/search?q={{%q}}',
        'image': 'https://www.google.com/search?q={{%q}}&tbm=isch',
        'video': 'https://www.google.com/search?q={{%q}}&tbm=vid'
    },
    'bing': {
        'web': "http://" + THEME.searchProviderDomain + "/search?q={{%q}}&PCSF=SU_NEWTAB",
        'image': 'https://www.bing.com/images/search?q={{%q}}',
        'video': 'https://www.bing.com/videos/search?q={{%q}}'
    },
    'yahoo': {
        'web': 'https://search.yahoo.com/search?p={{%q}}',
        'image': 'https://images.search.yahoo.com/search/images?p={{%q}}',
        'video': 'https://video.search.yahoo.com/search/video?p={{%q}}'
    },
    'ask': {
        'web': 'http://www.ask.com/web?q={{%q}}',
        'image': 'http://www.ask.com/web?q={{%q}}',
        'video': 'http://www.ask.com/youtube?q={{%q}}'
    }
};
var FOOTER_LINKS = [
    { name: 'About', path: '/about' },
    { name: 'Contact Us', path: '/contact' },
    { name: 'EULA', path: '/eula' },
    { name: 'Uninstall', path: '/uninstall' },
    { name: 'Privacy Policy', path: '/privacy' }
];
var FLICKR_API = 'http://d3rwhhpaq6xte.cloudfront.net/flickr';
