import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutritionFacts = product.nutritionFacts;

    if (nutritionFacts == null) {
      return const Center(child: Text('Données indisponibles'));
    }

    final l10n = AppLocalizations.of(context)!;

    String cleanName(String name) { //enlever le dont devant sucre et acide truc
      return name.replaceFirst(RegExp(r'^[Dd]ont\s+'), '').trim();
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: const Center(
              child: Text(
                'Repères nutritionnels pour 100g',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          if (nutritionFacts.fat != null) ...[
            _NutrientRow(
              name: cleanName(l10n.product_nutrition_facts_fat),
              value: nutritionFacts.fat!.per100g,
              unit: 'g',
              nutrientType: 'fat',
            ),
            const _CustomDivider(),
          ],

          if (nutritionFacts.saturatedFat != null) ...[
            _NutrientRow(
              name: cleanName(l10n.product_nutrition_facts_saturated_fats),
              value: nutritionFacts.saturatedFat!.per100g,
              unit: 'g',
              nutrientType: 'saturated fat',
            ),
            const _CustomDivider(),
          ],

          if (nutritionFacts.sugar != null) ...[
            _NutrientRow(
              name: cleanName(l10n.product_nutrition_facts_sugars),
              value: nutritionFacts.sugar!.per100g,
              unit: 'g',
              nutrientType: 'sugar',
            ),
            const _CustomDivider(),
          ],

          if (nutritionFacts.salt != null) ...[
            _NutrientRow(
              name: cleanName(l10n.product_nutrition_facts_salt),
              value: nutritionFacts.salt!.per100g,
              unit: 'g',
              nutrientType: 'salt',
            ),
          ],
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  final String name;
  final dynamic value;
  final String unit;
  final String nutrientType;

  const _NutrientRow({
    required this.name,
    required this.value,
    required this.unit,
    required this.nutrientType,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name[0].toUpperCase() + name.substring(1), //première lettre en maj
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${value ?? '—'}$unit',
                style: TextStyle(
                  fontSize: 17,
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    double v = (value is num) ? (value as num).toDouble() : double.tryParse(value.toString()) ?? 0;
    switch (nutrientType.toLowerCase()) {
      case 'fat': return v <= 3 ? AppColors.nutrientLevelLow : (v <= 20 ? AppColors.nutrientLevelModerate : AppColors.nutrientLevelHigh);
      case 'saturated fat': return v <= 1.5 ? AppColors.nutrientLevelLow : (v <= 5 ? AppColors.nutrientLevelModerate : AppColors.nutrientLevelHigh);
      case 'sugar': return v <= 5 ? AppColors.nutrientLevelLow : (v <= 12.5 ? AppColors.nutrientLevelModerate : AppColors.nutrientLevelHigh);
      case 'salt': return v <= 0.3 ? AppColors.nutrientLevelLow : (v <= 1.5 ? AppColors.nutrientLevelModerate : AppColors.nutrientLevelHigh);
      default: return Colors.grey;
    }
  }

  String _getLabel() {
    double v = (value is num) ? (value as num).toDouble() : double.tryParse(value.toString()) ?? 0;
    String msg(double l, double m) => v <= l ? 'Faible quantité' : (v <= m ? 'Quantité modérée' : 'Quantité élevée');
    switch (nutrientType.toLowerCase()) {
      case 'fat': return msg(3, 20);
      case 'saturated fat': return msg(1.5, 5);
      case 'sugar': return msg(5, 12.5);
      case 'salt': return msg(0.3, 1.5);
      default: return '-';
    }
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFF0F0F0)),
    );
  }
}