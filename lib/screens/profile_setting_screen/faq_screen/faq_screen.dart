import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sıkça Sorulan Sorular'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFAQItem(
            question: 'Uygulamayı nasıl kullanabilirim?',
            answer:
                'Uygulamayı kullanmak için önce kayıt olmanız gerekmektedir. Kayıt olduktan sonra giriş yaparak tüm özelliklerden yararlanabilirsiniz.',
          ),
          _buildFAQItem(
            question: 'Nasıl kayıt olabilirim?',
            answer:
                'Kayıt olmak için giriş ekranında "Kayıt Ol" butonuna tıklayın ve gerekli bilgileri doldurun. E-posta adresinizi doğruladıktan sonra kayıt işleminiz tamamlanacaktır.',
          ),
          _buildFAQItem(
            question: 'Şifremi unuttum, ne yapmalıyım?',
            answer:
                'Giriş ekranında "Şifremi Unuttum" butonuna tıklayarak e-posta adresinizi girin. Size gönderilen e-posta üzerinden şifrenizi sıfırlayabilirsiniz.',
          ),
          _buildFAQItem(
            question: 'Siparişlerimi nasıl takip edebilirim?',
            answer:
                'Siparişlerinizi profil ekranında "Siparişlerim" bölümünden takip edebilirsiniz. Sipariş durumları ve detaylarına bu bölümden ulaşabilirsiniz.',
          ),
          _buildFAQItem(
            question: 'Ürün iadesi nasıl yapabilirim?',
            answer:
                'Ürün iadesi yapmak için "İade Talepleri" bölümüne gidin ve iade etmek istediğiniz ürünü seçin. İade sürecini bu bölümden başlatabilirsiniz.',
          ),
          _buildFAQItem(
            question: 'Müşteri hizmetlerine nasıl ulaşabilirim?',
            answer:
                'Müşteri hizmetlerine ulaşmak için profil ekranındaki "Destek" bölümünü kullanabilirsiniz. Bize e-posta gönderebilir veya canlı destek hattımızdan yardım alabilirsiniz.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.transparent),
      ),
      elevation: 0,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
