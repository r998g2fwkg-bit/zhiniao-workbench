const CACHE_NAME = 'zhiniao-v1';
const PRECACHE = [
  './',
  'manifest.webmanifest',
  'icon-256.png',
  'icon-512.png',
  'assets/avatars/maximov0607@outlook.com.jpg',
  'assets/avatars/huangxu888666@icloud.com.jpg',
  'assets/avatars/927699803@qq.com.jpg',
  'assets/avatars/358610149@qq.com.jpg',
  'assets/avatars/3150971652@qq.com.jpg'
];

self.addEventListener('install', e => {
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(PRECACHE)).catch(err => {
    console.warn('[SW] precache failed', err);
  }));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))
    )).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;
  const isHtml = req.mode === 'navigate' || req.destination === 'document';
  e.respondWith(isHtml ? networkFirst(req) : cacheFirst(req));
});

function networkFirst(req) {
  return fetch(req).then(res => {
    if (res && res.status === 200) {
      const clone = res.clone();
      caches.open(CACHE_NAME).then(c => c.put(req, clone)).catch(() => {});
    }
    return res;
  }).catch(() => {
    return caches.match(req).then(cached => cached || new Response('<h1>离线中，请联网后重试</h1>', {
      headers: { 'Content-Type': 'text/html' }
    }));
  });
}

function cacheFirst(req) {
  return caches.match(req).then(cached => {
    if (cached) return cached;
    return fetch(req).then(res => {
      if (res && res.status === 200) {
        const clone = res.clone();
        caches.open(CACHE_NAME).then(c => c.put(req, clone)).catch(() => {});
      }
      return res;
    }).catch(() => new Response());
  });
}
