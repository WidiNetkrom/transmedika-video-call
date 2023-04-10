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

    Profile mySelf = Profile(
        email: "maman@rskp.com",
        name: 'TN, MAMAN',
        uuid: '7bfb1588-fc6a-4878-a96f-126cd6a6692c',
        profilePicture: null,
        token: 'xxxxxxxxxxxx'
    );

    Profile other = Profile(
        email: "dion@rskp.com",
        name: 'dr. Dionisius Panji Wijanarko, Sp.B',
        uuid: '42c6145f-8143-4d67-ad30-6f84571e0f65',
        profilePicture: null
    );

    String consultationId = '224';

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OneToOneScreen(
            mySelf: mySelf,
            other: other,
            consultationId: consultationId
        )
    );
  }
}
```

## Menelepon

Untuk bisa melakukan panggilan kamu harus request GET ke endpoint ini auth/check-device-id-multiple untuk mendapatkan data firebase token dari device.
Firebase token hanya digunakan jika kamu ingin menelepon saja, jadi optional untuk isi data konstruktornya.
Lihat contoh di bawah ini.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    Profile mySelf = Profile(
        email: "maman@rskp.com",
        name: 'TN, MAMAN',
        uuid: '7bfb1588-fc6a-4878-a96f-126cd6a6692c',
        profilePicture: null,
        token: 'xxxxxxxxxxxx'
    );

    Profile other = Profile(
        email: "dion@rskp.com",
        name: 'dr. Dionisius Panji Wijanarko, Sp.B',
        uuid: '42c6145f-8143-4d67-ad30-6f84571e0f65',
        profilePicture: null
    );

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
            fcmTokens: fcmTokens
        )
    );
  }
}
```

## Preview Images
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/Screenshot_20230405-143410.png" width="320px" />
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/Screenshot_20230405-143434.png" width="320px" />
<img src="https://raw.githubusercontent.com/WidiNetkrom/transmedika-video-call/main/screenshoots/web.PNG" />

## Conclusion
have a nice day 🙂