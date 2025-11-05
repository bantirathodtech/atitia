// Firebase Cloud Messaging Service Worker
// This file is required for Firebase Messaging to work on web
//
// IMPORTANT: Service workers run in a separate context and cannot access
// Flutter's EnvironmentConfig directly. These values must be manually kept
// in sync with lib/common/constants/environment_config.dart
//
// VALUES SOURCE:
// - apiKey: EnvironmentConfig.firebaseWebApiKey
// - authDomain: EnvironmentConfig.firebaseAuthDomain
// - projectId: EnvironmentConfig.firebaseProjectId
// - storageBucket: EnvironmentConfig.firebaseStorageBucket
// - messagingSenderId: EnvironmentConfig.firebaseMessagingSenderId
// - appId: EnvironmentConfig.firebaseWebAppId
// - measurementId: EnvironmentConfig.firebaseWebMeasurementId
//
// UPDATE INSTRUCTIONS:
// If Firebase configuration changes, update both:
// 1. lib/common/constants/environment_config.dart
// 2. This file (web/firebase-messaging-sw.js)
//
// Last verified: All values match EnvironmentConfig as of latest commit

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize Firebase in the service worker
// Values match EnvironmentConfig.firebaseWebApiKey, etc.
firebase.initializeApp({
  apiKey: 'AIzaSyArl95qqaPZNtT2_NVg9sY15t06zq5h6dg', // EnvironmentConfig.firebaseWebApiKey
  authDomain: 'atitia-87925.firebaseapp.com', // EnvironmentConfig.firebaseAuthDomain
  projectId: 'atitia-87925', // EnvironmentConfig.firebaseProjectId
  storageBucket: 'atitia-87925.firebasestorage.app', // EnvironmentConfig.firebaseStorageBucket
  messagingSenderId: '665010238088', // EnvironmentConfig.firebaseMessagingSenderId
  appId: '1:665010238088:web:4ab7c29b9112469119a53d', // EnvironmentConfig.firebaseWebAppId
  measurementId: 'G-SBS8EXZF76' // EnvironmentConfig.firebaseWebMeasurementId
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
