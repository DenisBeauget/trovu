import 'package:Trovu/model/product.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/screen/popup.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:Trovu/service/product_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
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
    String welcomeText =
        "${AppLocalizations.of(context)!.home_welcome} ${userProvider.user!.display_name ?? ''}";
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                  Center(child: Text(welcomeText, style: classicText())),
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
                              LocalProduct? result;
                              try {
                                result =
                                    await ProductService().scanAndSaveProduct();
                              } on Exception catch (e) {
                                showErrorSnackbar(
                                    context,
                                    AppLocalizations.of(context)!
                                        .error_find_product);
                                showReportDialog(context, null);
                              }

                              if (result != null) {
                                showReportDialog(context, result);
                              } else {
                                showErrorSnackbar(
                                    context,
                                    AppLocalizations.of(context)!
                                        .error_find_product);
                                showReportDialog(context, null);
                              }
                            },
                            style: btnPrimaryStyle(context),
                            child:
                                Text(AppLocalizations.of(context)!.produt_scan),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              showReportDialog(context, null);
                            },
                            style: btnPrimaryStyle(context),
                            child:
                                Text(AppLocalizations.of(context)!.product_add),
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
