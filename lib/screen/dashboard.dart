import 'package:Trovu/model/user_stock.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/connexion.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:Trovu/service/user_stocks_service.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalReport = 0;
  int totalProduct = 0;

  void _loadTotalReport() async {
    final userTotalReport = await UserService()
        .getTotalReportForUser(supabase.auth.currentUser!.id);

    final userStockList = await UserStocksService()
        .getUserStockListById(supabase.auth.currentUser!.id);

    setState(() {
      totalProduct = userStockList.length;
      totalReport = userTotalReport;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTotalReport();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                        style: classicMediumText(),
                        "Ton profil Trovu ${userProvider.user?.display_name}"),
                  ),
                  const SizedBox(height: 20)
                ]),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pin),
                    Text(
                      "Total report : $totalReport",
                      style: classicMediumText(),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inventory),
                    Text(
                      "Total produit dans le frigo :  $totalProduct",
                      style: classicMediumText(),
                    )
                  ],
                )
              ])
            ])));
  }
}
