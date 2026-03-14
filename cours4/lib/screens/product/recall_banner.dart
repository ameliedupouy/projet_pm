import 'package:flutter/material.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class RecallBanner extends StatelessWidget {
  final String label;
  const RecallBanner({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onRecallBannerTapped(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000).withOpacity(0.36),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFA60000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Color(0xFFA60000)),
          ],
        ),
      ),
    );
  }

  void _onRecallBannerTapped(BuildContext context) {
    final recallState = context.read<RecallFetcher>().state;
    final productState = context.read<ProductFetcher>().state;

    //verif que les données existent
    if (recallState is RecallFetcherSuccess && recallState.recall != null) {
      final extras = { //lie le produit et le rappel pour passer la photo 
        'recall': recallState.recall,
        'product': productState is ProductFetcherSuccess ? productState.product : null,
      };
      
      context.push('/recall', extra: extras);
    }
  }
}