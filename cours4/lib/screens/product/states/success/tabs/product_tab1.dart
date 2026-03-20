import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  static const double _kHorizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          if (product.ingredients != null && product.ingredients!.isNotEmpty) //affiche les ingrédients s'ils existent
            _SectionWidget(
              title: 'Ingrédients',
              children: product.ingredients!
                  .map((ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          ingredient,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
            ),

          if (product.allergens != null && product.allergens!.isNotEmpty) //affiche les allergènes s'ils existent
            _SectionWidget(
              title: 'Substances allergènes',
              children: product.allergens!
                  .map((allergen) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          allergen,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
            ),

          if (product.traces != null && product.traces!.isNotEmpty) //affiche si existant
            _SectionWidget(
              title: 'Traces',
              children: product.traces!
                  .map((trace) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          trace,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
            ),

          if (product.additives != null && product.additives!.isNotEmpty) //si existant
            _SectionWidget(
              title: 'Additifs',
              children: product.additives!.entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),

          if ((product.ingredients == null || product.ingredients!.isEmpty) && //si pas de données : message
              (product.allergens == null || product.allergens!.isEmpty) &&
              (product.traces == null || product.traces!.isEmpty) &&
              (product.additives == null || product.additives!.isEmpty))
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Aucune données disponible',
                  style: TextStyle(color: AppColors.grey2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ProductTab1._kHorizontalPadding,
        24.0,
        ProductTab1._kHorizontalPadding,
        16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}