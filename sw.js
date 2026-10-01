// Service Worker para Atalat Visitas (Offline-First)
const CACHE_NAME = 'atalat-visitas-v2.7.3';
const ASSETS_TO_CACHE = [
  '/',
  '/index.html',
  '/manifest.json',
  '/pqfl.html',
  '/relatorio_pqfl_manoel_messias.html',
  '/logo_atalat.png',
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(ASSETS_TO_CACHE).catch(err => {
        console.warn('Cache addAll fallback:', err);
      });
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  // Ignora requisições não-GET e chamadas à API do Supabase
  if (event.request.method !== 'GET') return;
  if (event.request.url.includes('supabase.co')) return;

  // 1. PÁGINAS HTML (Navegação): Network-First para SEMPRE exibir alterações mais recentes quando online
  if (event.request.mode === 'navigate' || event.request.destination === 'document') {
    event.respondWith(
      fetch(event.request).then(networkResponse => {
        if (networkResponse && networkResponse.status === 200) {
          let copy = networkResponse.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, copy));
        }
        return networkResponse;
      }).catch(() => {
        return caches.match(event.request).then(cached => cached || caches.match('/index.html'));
      })
    );
    return;
  }

  // 2. DEMAIS RECURSOS ESTÁTICOS (Imagens, CDN): Stale-While-Revalidate
  event.respondWith(
    caches.match(event.request).then(cachedResponse => {
      let fetchPromise = fetch(event.request).then(networkResponse => {
        if (networkResponse && networkResponse.status === 200) {
          caches.open(CACHE_NAME).then(cache => cache.put(event.request, networkResponse.clone()));
        }
        return networkResponse;
      }).catch(() => {});

      return cachedResponse || fetchPromise;
    })
  );
});
