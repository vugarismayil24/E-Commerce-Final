import 'package:e_com_app/screens/payment_screen.dart';

import 'package:flutter/material.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        
        title: const Text("Delivery Options"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 380,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xffFADEC7),
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Image.network(
                        "https://s3-alpha-sig.figma.com/img/9a11/cdca/114c57530582307a01d0c7ac62ec7485?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=PvBznquG53nWq2ArDi7bqNVEMmFZyrNadG-LpKaJ71HWNyv38NnYKwrCglHvt~TgCBVvqgGR2JL8-VWjLIeUbn6zsaz29vTWvMnTs7jWB18oHza6SFPlWALWJ53ZQEcdCbngFileDUGBEMSotzS~xMrUha5F0mceUV0m5ldMIzA2DYgJQejtfDB4QyYvSdsY5XPS9uf6N9ze4uWBHjGpqQW8dARkWAy1sRRdpKdW8tiiL1c2DK6XwjhtvUdf5WKr-ijlqfR4bpJuOJKkpfY3YzI2Ipc9Gwj3tKZ9UoICcDxanGlPbti2CyAAUX0KF3mRVdLiDaROytE1sLRwUhGzgQ__",
                        scale: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Home delivery - Delivery times between 48 hours and 72 hours.",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("0,00DT"),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaymentScreen(),),);},
                        child: const Text("OK"),
                      ),
                      const SizedBox(width: 10,)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}