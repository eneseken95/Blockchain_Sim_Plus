# 📖 Blockchain Sözlüğü (Glossary)

Bu belge, `Blockchain Sim+` projesinde kullanılan temel terimlerin açıklamalarını içerir.

## Temel Kavramlar

### 🧱 Block (Blok)
Verilerin (işlemlerin) saklandığı dijital bir kutudur. Her blok, kendinden önceki bloğun "parmak izini" (Hash) taşır, bu da onları birbirine zincirler.

### 🔗 Blockchain (Blokzinciri)
Blokların birbirine kriptografik olarak bağlandığı dağıtık veri tabanıdır. "Değiştirilemez" olma özelliğini bu zincir yapısından alır.

### #️⃣ Hash
Herhangi bir veriyi (ne kadar büyük olursa olsun) sabit uzunlukta, benzersiz bir karakter dizisine dönüştüren matematiksel fonksiyondur. Simülatörde **SHA-256** kullanılır.
*   **Özelliği:** Verideki tek bir bit bile değişse, Hash tamamen değişir.

### 🔢 Nonce (Number Used Once)
Madencilerin (Miners) bir bloğun Hash'ini hedef zorluk (Difficulty) seviyesine getirmek için sürekli değiştirdikleri rastgele sayıdır.

### ⛏️ Mining (Madencilik) / Proof of Work (PoW)
Ağı güvenli tutmak için yapılan işlemdir. Bilgisayarlar, belirli bir kurala uyan (örneğin "000" ile başlayan) bir Hash bulmak için yarışır. Bu işlem enerji ve işlemci gücü gerektirir.

### ⚖️ Proof of Stake (PoS)
Madenciliğe alternatif bir konsensüs mekanizmasıdır. Burada blok üretim hakkı, "Stake" edilen (kilitlenen) varlık miktarına göre belirlenir. Daha az enerji harcar.

## Cüzdan ve İşlemler

### 🔑 Private Key (Özel Anahtar)
Sizin "Dijital İmzanız"dır. Cüzdanınızdaki varlıkları harcama yetkisi verir. Kimseyle paylaşılmamalıdır.

### 🌍 Public Key (Genel Anahtar) & Address
Size para gönderilmesi için başkalarına verdiğiniz adrestir. Özel anahtardan matematiksel olarak türetilir, ancak tersine işlem yapılamaz.

### ✍️ Digital Signature (Dijital İmza)
Bir işlemin gerçekten o cüzdanın sahibi tarafından yapıldığını kanıtlayan kriptografik kanıttır. İşlem verisi + Özel Anahtar kullanılarak oluşturulur.
