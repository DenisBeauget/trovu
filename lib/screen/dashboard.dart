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
    final userName = userProvider.user?.display_name ?? 'Utilisateur';

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bienvenue, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A5D23),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Voici votre tableau de bord Trovu',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6E7F3E),
                ),
              ),
              const SizedBox(height: 24),
              _buildStatisticsCard(),
              const SizedBox(height: 24),
              _buildAccountCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.analytics, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Statistiques de votre compte Trovu',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatItem(
                    Icons.inventory, 'Nombre total de produits', totalReport),
                const SizedBox(height: 16),
                _buildStatItem(
                    Icons.kitchen, 'Produits dans votre frigo', totalProduct),
                const SizedBox(height: 16),
                _buildStatItem(Icons.score, 'Nutriscore moyen', 'B'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    final userProvider = Provider.of<UserProvider>(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.manage_accounts,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Votre compte Trovu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatItem(
                    Icons.person, 'Nom : ', userProvider.user?.display_name),
                const SizedBox(height: 16),
                _buildStatItem(
                    Icons.email, 'Email : ', userProvider.user?.email),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, Object? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
