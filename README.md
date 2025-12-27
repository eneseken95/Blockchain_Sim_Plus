# 🌐 Blockchain Sim+ (Elite Edition)

![Blockchain Sim+ Banner](Screenshots/banner.png)

> **"Kodla Öğren, Simülasyonla Keşfet."**
> *Bu proje, Blockchain teknolojisinin temellerini sadece anlatmakla kalmayıp, interaktif bir simülasyonla yaşatarak öğreten elit bir eğitim platformudur.*

---

## 📚 İçindekiler (Curriculum)
1. [Proje Vizyonu](#-proje-vizyonu)
2. [Sanal Dershane: Blockchain Nedir?](#-sanal-dershane-blockchain-nedir)
    - [Blok Anatomisi (Block.swift)](#1-blok-anatomisi-blockswift)
    - [Madencilik ve PoW (PoWEngine.swift)](#2-madencilik-ve-pow-powengineswift)
    - [Validatörler ve PoS (PoSEngine.swift)](#3-validatörler-ve-pos-posengineswift)
    - [Cüzdan ve İşlemler (Wallet.swift & Transaction.swift)](#4-cüzdan-ve-işlemler-walletswift--transactionswift)
3. [Sözlük (Glossary)](GLOSSARY.md) - *Tüm terimlerin açıklamaları burada!*
4. [Teknik Mimari (MVVM + Clean)](#-teknik-mimari)
5. [Kurulum ve Kullanım](#-kurulum-ve-kullanım)
6. [Katkıda Bulunma (Contribution)](#-katkıda-bulunma)

---

## 🎯 Proje Vizyonu

**Blockchain Sim+**, statik diyagramların ötesine geçerek dinamik bir öğrenme deneyimi sunar. Bu repo, bir iOS uygulaması olmanın ötesinde, Swift dili ile yazılmış canlı bir **Blockchain Ders Kitabı** niteliğindedir.

Kodların içine yerleştirdiğimiz **Eğitici Yorum Satırları (///)** sayesinde, sadece uygulamayı çalıştırarak değil, kodu okuyarak da "Hash", "Nonce", "Difficulty" gibi kavramların *nasıl* implemente edildiğini görebilirsiniz.

---

## 🎓 Sanal Dershane: Blockchain Nedir?

### 1. Blok Anatomisi (`Block.swift`)
Bir blok, tıpkı dijital bir defter yaprağı gibidir. Ancak bu yaprağın üzerinde silinemez bir mühür vardır: **Hash**.

Dosya: `Domain/Models/Block.swift`
```swift
// Block.swift içinden kısa bir kesit:
var hash: String {
    // Header verisini alıp SHA-256 ile şifreliyoruz.
    // Eğer bloktaki TEK BİR HARF bile değişirse, bu Hash tamamen değişir!
    let digest = SHA256.hash(data: headerData)
    return digest.map { String(format: "%02x", $0) }.joined()
}
```
**Özgüdındar Notu:** Bloklar birbirine `prevHash` (önceki bloğun mührü) ile bağlanır. Bu yüzden zincirin ortasındaki bir bloğu değiştirmek, ondan sonra gelen tüm blokları bozar ("Avalanche Effect").

### 2. Madencilik ve PoW (`PoWEngine.swift`)
Madencilik, aslında zor bir matematik problemini çözme yarışıdır. Bilgisayarınız rastgele sayılar (`nonce`) deneyerek, bulduğu Hash'in belirli sayıda "0" ile başlamasını sağlamaya çalışır.

Dosya: `Data/Engines/PoWEngine.swift`
```swift
// Madencilik Döngüsü:
// Hash "000..." ile başlayana kadar nonce'u 1 arttır.
// Bu işlem işlemci gücü (Work) gerektirir.
while !b.isValidPoW() { 
    b.nonce &+= 1 
}
```
*Simülatörde "Difficulty" ayarını arttırarak bu işlemin nasıl logaritmik olarak zorlaştığını gözlemleyebilirsiniz.*

### 3. Validatörler ve PoS (`PoSEngine.swift`)
Proof of Stake (PoS), enerji harcamak yerine "Varlık" (Stake) kullanır. Ne kadar çok coininiz varsa, bir sonraki bloğu oluşturma şansınız o kadar artar. Ama dikkat! Hata yaparsanız ceza (Slashing) yersiniz.

Dosya: `Data/Engines/PoSEngine.swift`
```swift
// Ağırlıklı Rastgele Seçim:
// Zengin validatörlerin seçilme ihtimali daha yüksektir.
guard let idx = rng.weightedIndex(weights: w) else { ... }

// Ceza Mekanizması (Slashing):
if isMalicious {
    vals[idx].stake -= slashAmount // Kötü davrananın parasını kes!
}
```

### 4. Cüzdan ve İşlemler (`Wallet.swift` & `Transaction.swift`)
Blockchain sadece bloklardan ibaret değildir; asıl amacı değer transferidir.
`Wallet` sınıfı, modern kriptografinin kalbi olan **Public/Private Key** çiftini oluşturur.

Dosya: `Domain/Models/Transaction.swift` & `Wallet.swift`
```swift
// Dijital İmza:
// İşlemi YALNIZCA cüzdanın gerçek sahibi imzalayabilir.
// Bu imza, işlem verisi (Kime, Ne kadar) ile matematiksel olarak bağlanır.
let signature = try privateKey.signature(for: transactionData)
```
*Bu sayede, işlemin içeriği değiştirilirse veya başkası sizin adınıza işlem yapmaya çalışırsa, imza doğrulaması (Verification) başarısız olur.*

---

## 🏛 Teknik Mimari

Proje, endüstri standardı **Clean Architecture** prensiplerine sadık kalarak, **MVVM** (Model-View-ViewModel) deseniyle geliştirilmiştir.

*   **Domain Layer**: İş mantığı (`Block`, `ConsensusEngine`). SwiftUI veya veritabanından bağımsızdır. Saf Swift kodudur.
*   **Data Layer**: Veri yönetimi ve motorlar (`PoWEngine`, `PoSEngine`).
*   **Presentation Layer**: Kullanıcı arayüzü (`SwiftUI`).

Bu ayrım, öğrencilerin "Arayüz kodu" ile "Blockchain mantığını" birbirine karıştırmadan öğrenmesini sağlar.

---

## 🚀 Kurulum ve Kullanım

1.  Bu repoyu klonlayın:
    ```bash
    git clone https://github.com/eneseken95/Blockchain_Sim_Plus.git
    ```
2.  `Blockchain/Blockchain.xcodeproj` dosyasını Xcode ile açın.
3.  `Cmd + R` tuşuna basarak simülatörü başlatın.
4.  **Deneyin:** Ayarlar menüsünden "Difficulty" seviyesini 4'e çıkarın ve blok üretim hızının nasıl düştüğünü izleyin!

---

## 🤝 Katkıda Bulunma

Bu proje açık kaynaklı bir eğitim materyalidir. Yeni bir özellik mi eklemek istiyorsunuz?
Lütfen `CONTRIBUTING.md` dosyasını okuyun ve Pull Request göndermekten çekinmeyin!

---
*Copyright © 2025 Enes Eken. Apache License 2.0 ile lisanslanmıştır.*
