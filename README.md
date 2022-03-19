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
- API Request ile hisseler getirilecek.
- Hisseler getirilirken progressbar eklenecek.
- Hissenin girilen tarih için fiyatı getirilecek.
- Ana menü'ye 5 hisse eklenecek.
- Carousel ile seçili hisseler bağlanacak.(EREGL, SASA, TOASO, FROTO, HEKTS)
- Ortak metotlar için helper sınıfı oluşturulacak.
- Hisseler ekranı tasarımı tamamlanacak.


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

#### Kutuphaneler
cupertino_icons: Iconların kulanımı için. [Kutuphane](https://pub.dev/packages/cupertino_icons/install)
carousel_slider: Kaydırmalı kartlar eklemek için [Kutuphane](https://pub.dev/packages/carousel_slider/install)

#### Hata yorumlamaları
Api çağırımlarında gelen cevaplar aşağıdaki gibidir bu kontroller eklenmelidir.
- Success (Status Code 200)
- Unauthorized (Status Code 401)
- Unauthorized (Status Code 407) -> İşyatırım apisi için
- Internal Server Error (Status Code 500)