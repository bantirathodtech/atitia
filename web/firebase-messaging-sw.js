// Firebase Cloud Messaging Service Worker
// This file is required for Firebase Messaging to work on web

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize Firebase in the service worker
// Note: In production, consider using environment variables or a config file
// These values should match EnvironmentConfig in your Flutter app
firebase.initializeApp({
  apiKey: 'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg',
  authDomain: 'atitia-87925.firebaseapp.com',
  projectId: 'atitia-87925',
  storageBucket: 'atitia-87925.firebasestorage.app',
  messagingSenderId: '665010238088',
  appId: '1:665010238088:web:4ab7c29b9112469119a53d',
  measurementId: 'G-SBS8EXZF76'
});

// Initialize Firebase Messaging
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  
  const notificationTitle = payload.notification?.title || 'Atitia Notification';
  const notificationOptions = {
    body: payload.notification?.body || 'You have a new notification',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'atitia-notification',
    requireInteraction: true,
    actions: [
      {
        action: 'open',
        title: 'Open App'
      },
      {
        action: 'close',
        title: 'Close'
      }
    ]
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', (event) => {
  console.log('Notification clicked:', event);
  
  event.notification.close();
  
  if (event.action === 'open' || !event.action) {
    // Open the app
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});

// Handle notification close
self.addEventListener('notificationclose', (event) => {
  console.log('Notification closed:', event);
});
