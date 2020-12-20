# ecommerceapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ###
## ##### HHGSUN ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ###

Wordpress:
1. JWT için eklentiyi kur: https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/
  - wp-config.php dosyasına
  define('JWT_AUTH_SECRET_KEY', 'your-top-secrect-key'); //HHGSUN
  bu kodu ekleyin, define(NONCE_SALT..) alanından sonra eklenebilir.

2. WooCommerce eklentisini kur
  ## WooCommerce Ayarlar -> Hesaplar ve Gizlilik
  - Misafir ödemesi -> hiçbiri işaretli olmamalı
  - Hesap oluşturma bölümünde bu alanlar işaretlenmeli
    - Bir hesap oluşturulurken müşterinin adı, soyadı veya e-posta adresine bağlı olarak bir hesap kullanıcı adı oluşturulur.

3. WooCommerce consumerKey ve consumerSecret keylerini oluşturup constants.dart dosyasında ilgili alanlara ekle

Android:
1. flutter_secure_storage eklentisi için app/build.gradle minSdkVersion 18 olmalı

Ios:
1. 