'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/NOTICES": "777f4b2b15915db4e1d35b8f96da42d6",
"assets/AssetManifest.bin.json": "b2f4a58498dfc529c1199148f3b989a3",
"assets/FontManifest.json": "bf56da640282efe5571fec13e7e79ec1",
"assets/lib/assets/minibus1.jpg": "700f8f6d9ec9f89426ca1b0646a405ab",
"assets/lib/assets/reward3.jpeg": "148ea97c148545b26ef3397d96c80e95",
"assets/lib/assets/sedan2.jpg": "b1e1696b2da854c520adaf637cc19969",
"assets/lib/assets/car-12.jpeg": "11d58920213f8cf8b7d49412f631b221",
"assets/lib/assets/reward2.jpeg": "1cc9f9b6e4ad64c83daba1965c351b83",
"assets/lib/assets/car-10.jpeg": "a61a2410d53e1d418214d063ba074194",
"assets/lib/assets/car_wasing_4.jpg": "7c4222a339ba28081f4a14c6f54e7598",
"assets/lib/assets/reward8.jpeg": "1ccdee64577b06b7eda0f006fb6ef55d",
"assets/lib/assets/car-7.jpeg": "4cf2d542932852d18b54dc3a207c5618",
"assets/lib/assets/car_wasing_2.jpg": "eac9a54da315fd66a5a33eb1c756f83a",
"assets/lib/assets/minibus3.jpg": "9aefacdfe04faebdb6c7213bc850c397",
"assets/lib/assets/reward5.jpeg": "2f566c501f5baf6e17112e26de13a18a",
"assets/lib/assets/reward4.jpeg": "f1d1650177a10ec1946b95761fdaecc6",
"assets/lib/assets/motobyke1.jpg": "f8d17356316c8d153067e1430ffbce7d",
"assets/lib/assets/car-4.jpeg": "48b133455afe99f0a463206bc0c4f57a",
"assets/lib/assets/car_wasing_5.jpg": "0f218e25501eee7c54318f3301f285b1",
"assets/lib/assets/reward7.jpeg": "f6652b2bb414faf5acb60ee1f48ee4d0",
"assets/lib/assets/hashback4.jpg": "e335d5cb2fc220f94e06413b17e149f5",
"assets/lib/assets/kbm_logo.png": "6b798e9b594548234eabb7859549e50b",
"assets/lib/assets/car_wasing_8.jpg": "6e1d9b23f745d222f029e2fc7ac926ca",
"assets/lib/assets/car-promo1.jpeg": "d1dc2d7a52c87f7cd6d8a9104d55e8b8",
"assets/lib/assets/minibus2.jpg": "8d7c90978a8446de7bda84bc5de2ae01",
"assets/lib/assets/car_wasing_7.jpg": "447472a62aa1f31a1a947d611afa102a",
"assets/lib/assets/car-8.jpeg": "8fa33dbe4175ae56bf1744ba095a6949",
"assets/lib/assets/car-16.jpeg": "d8eb8b954c4b03ca2e4c50445b3bb63a",
"assets/lib/assets/car_wasing_6.jpg": "79010530c6f62fc3d3d9e0f407b5d350",
"assets/lib/assets/reward9.jpeg": "b9c0872a92aa2a49901fc7ff14d16fe2",
"assets/lib/assets/car_wasing_1.jpg": "2be0ae362414c9e61097562d037585ed",
"assets/lib/assets/car_wasing_9.jpg": "dee15bebc1f52e9f30428dd9aa580a0d",
"assets/lib/assets/car-promo2.jpeg": "4391d4fe800ba314738a6f847d782d91",
"assets/lib/assets/sedan3.png": "d6569923d8bba26913ca5e2f729ab1ee",
"assets/lib/assets/car_wasing_3.jpg": "97713a70995443edc76896ad3d5930ff",
"assets/lib/assets/car-11.jpeg": "96d2ee43e8ff5070cca6d88450d00dfe",
"assets/lib/assets/sedan1.jpg": "2da4722ab4fb920a3f2c396ca5bf5e8e",
"assets/lib/assets/hashback3.jpg": "08fa8a55a16a084caf35165e1b136f81",
"assets/lib/assets/car-13.jpeg": "c622364f22333fdc52ba1fe2e867965e",
"assets/lib/assets/car-1.jpeg": "57deb8ca9d4d4292104e56b53a7b3070",
"assets/lib/assets/car-17.jpeg": "2b41b352791aa3e2f624633ce6b4afae",
"assets/lib/assets/reward1.jpeg": "1c253a5875af27e3b72b936a55aedc50",
"assets/lib/assets/car-9.jpeg": "1b178dc5b9c4dde6b157d14f07bedece",
"assets/lib/assets/car-6.jpeg": "522aa34814c27af21b814f7b0a0b9096",
"assets/lib/assets/car-3.jpeg": "9ca3ad7b8504f0e981236a1a841df0cc",
"assets/lib/assets/reward12.jpeg": "56c69d5d6fc3564ee2af9ffd82972298",
"assets/lib/assets/hashback2.jpg": "d320f98701f9b81fe9bec71ec26b659a",
"assets/lib/assets/hashback.jpg": "4b00749a94c7084964400511ed0e7c20",
"assets/lib/assets/motobike3.jpg": "0154622e076913a2de9d97c05a90bc9d",
"assets/lib/assets/minibus4.jpg": "dd71d4fc2bd2f61f4e7405b0d87883de",
"assets/lib/assets/car-15.jpeg": "1a37c6183a5cb6bc879ed2f29a3be89b",
"assets/lib/assets/reward11.jpeg": "9a2d83f4eec1f99d555f6f53c740aa9a",
"assets/lib/assets/car-2.jpeg": "c05de51bbc95a87404dadd2bce0375fb",
"assets/lib/assets/reward10.jpeg": "fd02c3f10581ef7bb92ce447e35d9244",
"assets/lib/assets/reward6.jpeg": "88ad43a2a7a860eb206dcc25a9ee5e51",
"assets/lib/assets/car-5.jpeg": "750b4d68588ecfcd7c65f003f4df9ed1",
"assets/lib/assets/car-14.jpeg": "a478995633f5662ce8aa5f41ebfb3ffb",
"assets/lib/assets/motobike2.jpg": "4a6473eb769fc5e7eb7aa7aa534ee8ed",
"assets/lib/assets/reward13.jpeg": "b29feb93d0068c5877162c849ede3374",
"assets/fonts/MaterialIcons-Regular.otf": "287239f76b52b5773b297b2bd2cde4a4",
"assets/AssetManifest.json": "40527d78d2deba9ed0d848e86cbebaf6",
"assets/AssetManifest.bin": "c96faf72c70619118618870788c30198",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/packages/amplify_authenticator/assets/social-buttons/google.png": "a1e1d65465c69a65f8d01226ff5237ec",
"assets/packages/amplify_authenticator/assets/social-buttons/SocialIcons.ttf": "1566e823935d5fe33901f5a074480a20",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js": "77727e3a27ad3662c8fe30922a27626e",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js.map": "1d2af1f0a021761b289f4bf0fed87242",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js": "fa742e283e40fa499a72f9a314f9f53a",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js.map": "b77186f134bc5be76a9c7b6512461a00",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"index.html": "acff3e409001a5932c8d206bb16692fa",
"/": "acff3e409001a5932c8d206bb16692fa",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"main.dart.js": "742315b31f2b7bf4daa425f053e586e2",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "c8bb6a1aa6eb338275d4f3a000a52c67",
"version.json": "0b1e5224f1efbf67323d722a75ad0f1b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
