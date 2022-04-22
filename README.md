# stocks_dividend_capital

Sermaye arttırımları ve temettüler ile hisselerin geçmişten bugüne fiyat değerlemesini kullanıcılara sunarak yatırım yapma yolunda yardımcı olmayı hedefliyoruz.

# İçindekiler
- [Commit Standartı](#commit)
- [API](#api)
- [Teknolojiler](#Teknolojiler)
- [To-Do Task](#To-Do-Tasks)
- [Done Task](#Gerceklestirilenler)
- [Kütüphaneler](#Kutuphaneler)


#### Commit
`[Commit Id][commit message]` şeklindedir. 

#### API


#### Teknolojiler;
- Flutter/Dart
- MongoDB

#### To-Do Tasks
- Ana ekranda hisseler yazıları kaldırılıp midas benzeri yapı kurulacak.
- Temettü grafiğinde UI düzenlemeleri yapılacak(tarih, tutar başlıkları)
- Isloaded true olmadan hisseler ekranına geçiş engellenecek.

#### Gerceklestirilenler
- Proje Oluşturulması(C'in-1)
- Readme.md dosyasının güncellenmesi(C'in-1)
- IOS ve Android için derleme ayarı düzeltildi.(C'in-2)
- Ana Ekran eklemesi yapıldı.(C'in-2)
- Ekrandaki debug yazısı kaldırıldı.(C'in-2)
- NavigationBar eklendi.(C'in-2)
- Menüler eklendi.(C'in-2)
- Carousel Slider eklendi.(C'in-2)
- MVC düzeninde class'lar eklendi.(C'in-2)
- Widget denemeleri için Testpage eklendi.(C'in-2)
- Carousel otomatik geçiş eklendi (C'in-3)
- Bilgilendirme mesajları için Toast kütüphanesi eklendi.(C'in-4)
- Carousel kartlarının geçiş süreleri uzatıldı.(C'in-4)
- Belirli başlı hisseler ana ekrana eklendi.(C'in-4)
- Ana menü'ye 5 hisse eklenecek.(C'in-4)
- View'ler ayırıldı.(C'in-4)
- MongoDB bağlantısı yapıldı.(C'in-4)
- Carousel'de gösterilecek mesajlar için db'ye bağlanıldı.(C'in-4)
- Carousel ile seçili hisseler bağlandı(DB'den getirilecek sonradan düzetltmeler için)(C'in-5)
- Ortak metotlar için helper sınıfı oluşturulacak.(C'in-5)
- MongoDB Bağlantı ayarları yapıldı.(C'in-5)
- Arama özellikli Dropdown kütüphanesi eklendi.(C'in-6)
- Ana ekran'daki hisseler düzeltildi.(C'in-6)
- Hisseler ekranı başlangıç tasarımı yapıldı.(C'in-6)
- Hisse seçtirme, tarih ve tutar girişi alındı.(C'in-6)
- Hisse seçtirme girişi DB'den getirildi.(C'in-7)
- Hisse arama özelliği eklendi.(C'in-7)
- Seçilen Hissenin son 5 yıllık temettü grafiği eklendi.(C'in-7)
- Seçilen Hissenin geçmiş temettü ve bedelsiz verileri getirildi.(C'in-7)
- Hissenin girilen tarih için fiyatı getirildi.(C'in-8)
- Hesapla butonu eklenecek ve sonuç gösterildi.(C'in-8)
- UI Düzenlemeleri yapıldı. (C'in-8)

#### Kutuphaneler
- cupertino_icons: IOS Iconlarının kulanımı için. [Kutuphane](https://pub.dev/packages/cupertino_icons/install)
- carousel_slider: Kaydırmalı kartlar eklemek için [Kutuphane](https://pub.dev/packages/carousel_slider/install)
- toast: Bilgilendirme mesajları için [Kutuphane](https://pub.dev/packages/toast/install)
- mongo_dart: MongoDB bağlantısının kurulması için [Kutuphane](https://pub.dev/packages/mongo_dart/install)
- dropdown_search: Liste içerisinde aramalı dropdown componeneti için [Kutuphane](https://pub.dev/packages/dropdown_search/install)
- fl_chart: Seçilen hissenin geçmiş temettü grafiğini görmek için [Kutuphane](https://pub.dev/packages/fl_chart/install)
- intl: DateTime format işlemleri için [Kutuphane](https://pub.dev/packages/intl/install)

#### Hata yorumlamaları
Api çağırımlarında gelen cevaplar aşağıdaki gibidir bu kontroller eklenmelidir.
- Success (Status Code 200)
- Unauthorized (Status Code 401)
- Unauthorized (Status Code 407) -> İşyatırım apisi için
- Internal Server Error (Status Code 500)