# transmedika_one_to_one_call

Transmedika SDK Video Call

## Supported Platforms

- Android
- IOS
- Web

## Functionality

| Feature | Android |  iOS  | Web |
| :-------------: | :-------------:|:-----:| :-----: |
| Audio/Video | :heavy_check_mark: | [WIP] | :heavy_check_mark: |

## Contoh

Saya menggunakan contoh pada main.dart

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transmedika_one_to_one_call/webrtc/profile.dart';
import 'one_to_one_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}
```


## Menerima Panggilan

Untuk menerima panggilan mekanisme aplikasinya kamu akan menerima notifikasi dari firebase. 
Data myself, other, consultationId bisa kamu dapatkan dari data yang dikirim lewat notifikasi tersebut dan 
kamu cukup panggil dan masukan data tersebut ke kontruktor class OneToOneScreen. 
Lihat contoh di bawah ini.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    final mySelf = {
      'email': "maman@rskp.com",
      'name': 'TN, MAMAN',
      'uuid': '7bfb1588-fc6a-4878-a96f-126cd6a6692c',
      'profilePicture': 'https://upload.wikimedia.org/wikipedia/commons/0/04/Elon_Musk_and_Hans_Koenigsmann_at_the_SpaceX_CRS-8_post-launch_press_conference_%2826223624532%29_%28cropped%29.jpg',
      'token': 'xxxxxxxxxxxx'
    };

    final other = {
      'email': "dion@rskp.com",
      'name': 'dr. Dionisius Panji Wijanarko, Sp.B',
      'uuid': '42c6145f-8143-4d67-ad30-6f84571e0f65',
      'profilePicture': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/710px-Donald_Trump_official_portrait.jpg',
    };

    String consultationId = '224';

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OneToOneScreen(
          mySelf: mySelf,
          other: other,
          consultationId: consultationId,
          onMessage: (message){
            ///put your toast or widget for display message
          },
        )
    );
  }
}
```

## Memanggil

Untuk bisa melakukan panggilan kamu harus request GET ke endpoint ini auth/check-device-id-multiple untuk mendapatkan data firebase token dari device.
Firebase token hanya digunakan jika kamu ingin menelepon saja, jadi optional untuk isi data konstruktornya.
Lihat contoh di bawah ini.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    final mySelf = {
      'email': "maman@rskp.com",
      'name': 'TN, MAMAN',
      'uuid': '7bfb1588-fc6a-4878-a96f-126cd6a6692c',
      'profilePicture': 'https://upload.wikimedia.org/wikipedia/commons/0/04/Elon_Musk_and_Hans_Koenigsmann_at_the_SpaceX_CRS-8_post-launch_press_conference_%2826223624532%29_%28cropped%29.jpg',
      'token': 'xxxxxxxxxxxx'
    };

    final other = {
      'email': "dion@rskp.com",
      'name': 'dr. Dionisius Panji Wijanarko, Sp.B',
      'uuid': '42c6145f-8143-4d67-ad30-6f84571e0f65',
      'profilePicture': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/710px-Donald_Trump_official_portrait.jpg',
    };

    String consultationId = '224';
    
    List<String> fcmTokens = ['fYSu5ILSvcKFUwyPRo--kl:APA91bF7c3EVBX7jvGvhQZrFC-Y2t83sjZ79gljq03WE9finRILE608KHAZkrX0MRIjAZL2Fi2Cvy1orZY8C9sgNfTH_eHWJl0X7quGSyusbTDaCnwVtGuwT22H3PbQwhaPmAXgqX6Oq'];

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OneToOneScreen(
          mySelf: mySelf,
          other: other,
          consultationId: consultationId,
          fcmTokens: fcmTokens,
          onMessage: (message){
            ///put your toast or widget for display message
          },
        )
    );
  }
}
```

## Preview Images
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/Screenshot_20230405-143410.png" width="320px" />
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/Screenshot_20230405-143434.png" width="320px" />
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/web.PNG" width="480px"/>

## Conclusion
have a nice day 🙂