'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "a8cdde172dc451580438d1adb1420efd",
"icons/Icon-maskable-512.png": "a8cdde172dc451580438d1adb1420efd",
"icons/Icon-192.png": "f8b5d6071c1ad7814e8d2c6340f36f9f",
"icons/Icon-maskable-192.png": "f8b5d6071c1ad7814e8d2c6340f36f9f",
"manifest.json": "d41d8cd98f00b204e9800998ecf8427e",
"index.html": "d0b9154da46e39aa7e6c529e4eb622cc",
"/": "d0b9154da46e39aa7e6c529e4eb622cc",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "65edf493fb1e2e729f1598c7c75ed8d7",
"assets/assets/images/background.png": "e0605234a360c31aae0779bd5ddbc1fa",
"assets/assets/images/crown.png": "9b0dfb0e2d49ea088438988cb98a75e0",
"assets/fonts/MaterialIcons-Regular.otf": "894851c106792542eba8b79a689db734",
"assets/NOTICES": "2a5ff1600f19381b879cade19f0ccb4d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/playing_cards/assets/card_imagery/qs.png": "c01ffe97d768bb26c1293749647dfcfd",
"assets/packages/playing_cards/assets/card_imagery/qd.png": "01751a267acc9e7a5fd4b1373e9d3179",
"assets/packages/playing_cards/assets/card_imagery/heart.png": "6f7fcfdfc88ec70f6bc4dcd339568b03",
"assets/packages/playing_cards/assets/card_imagery/kh.png": "ce45da39c0f70540e158b16a0a8ead86",
"assets/packages/playing_cards/assets/card_imagery/jh.png": "f7730fbbcf96889e45d2f9958ff825aa",
"assets/packages/playing_cards/assets/card_imagery/jd.png": "ae263f367ef9e4c4b8ad40563623cea7",
"assets/packages/playing_cards/assets/card_imagery/bw_joker.png": "1d1c6ad3fa8a3bde172cada9104d124d",
"assets/packages/playing_cards/assets/card_imagery/kd.png": "806f30f77fcf9f11249ac3bb0174965b",
"assets/packages/playing_cards/assets/card_imagery/color_joker.png": "11eb99352b7b787e53cf10c122565826",
"assets/packages/playing_cards/assets/card_imagery/qh.png": "2d142e0a95f0adbd44b5c7c0172ef577",
"assets/packages/playing_cards/assets/card_imagery/kc.png": "cf60d0e257ec768bfee576f261e1a644",
"assets/packages/playing_cards/assets/card_imagery/qc.png": "85d80978a888f5a7a61eb016dddee679",
"assets/packages/playing_cards/assets/card_imagery/js.png": "137bbce282a776498eb8b33618a77db9",
"assets/packages/playing_cards/assets/card_imagery/diamond.png": "f2eb19afc052c30eb571e4c6c6046d68",
"assets/packages/playing_cards/assets/card_imagery/jc.png": "104dca27ba3f0734a5fde520f94d0eb3",
"assets/packages/playing_cards/assets/card_imagery/back_001.png": "28c80e04ab991b80cc2aa5d18aa879aa",
"assets/packages/playing_cards/assets/card_imagery/club.png": "d1fd0ca4bd3ccc4c5e852f3ce15dccd8",
"assets/packages/playing_cards/assets/card_imagery/spade.png": "981c0b10f109bd3e9cb408b61f7a33a7",
"assets/packages/playing_cards/assets/card_imagery/ks.png": "660271be7e65fe06f3b2034a83af6f24",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "4a2148f22e2c8fc02dcebf4c9431fe24",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "b7f13db9dd11ca0610dbf612ed1efd34",
"flutter_bootstrap.js": "a862ab3ad2ee0b99ff2931a567e20c7d",
"version.json": "f0372243c58db1a9206cbde44345ba2a",
"main.dart.js": "ceb89ac3ddb8e53f5b75d95e66f9d304"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
