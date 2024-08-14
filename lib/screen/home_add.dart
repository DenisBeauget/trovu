import 'package:Trovu/model/product.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/popup_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:Trovu/service/product_service.dart';

class HomeAdd extends StatefulWidget {
  const HomeAdd({super.key});

  @override
  State<HomeAdd> createState() => _HomeAddState();
}

class _HomeAddState extends State<HomeAdd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6432978385593557/8904586750',
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isAdLoaded)
              SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(
                  ad: _bannerAd!,
                ),
              ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Center(
                      child: Text(
                          "Bienvenue ${userProvider.user!.display_name}",
                          style: classicText())),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 350,
                      height: 380,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: 100,
                              width: 100,
                              child: Image(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      'assets/images/basket_gif.gif'))),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              LocalProduct? result =
                                  await ProductService().scanAndSaveProduct();

                              if (result != null) {
                                showReportDialog(context, result);
                              }
                            },
                            style: btnPrimaryStyle(context),
                            child: const Text("Scanner un produit"),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              showReportDialog(context, null);
                            },
                            style: btnPrimaryStyle(context),
                            child: const Text("Ajouter un produit"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
