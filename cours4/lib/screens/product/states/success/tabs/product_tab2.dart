import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  static const double _kHorizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutritionFacts = product.nutritionFacts;

    if (nutritionFacts == null) { //si aucune données
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Aucune données nutritionnelles disponibles',
            style: TextStyle(color: AppColors.grey2),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              _kHorizontalPadding,
              24.0,
              _kHorizontalPadding,
              24.0,
            ),
            child: Text(
              'Repères nutritionnels pour 100g',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
          ),

          if (nutritionFacts.fat != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_fat,
              value: nutritionFacts.fat!.per100g,
              unit: 'g',
              nutrientType: 'fat',
            ),

          if (nutritionFacts.saturatedFat != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_saturated_fats,
              value: nutritionFacts.saturatedFat!.per100g,
              unit: 'g',
              nutrientType: 'saturated fat',
            ),

          if (nutritionFacts.carbohydrate != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_carbohydrates,
              value: nutritionFacts.carbohydrate!.per100g,
              unit: 'g',
              nutrientType: 'carbohydrate',
            ),

          if (nutritionFacts.sugar != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_sugars,
              value: nutritionFacts.sugar!.per100g,
              unit: 'g',
              nutrientType: 'sugar',
            ),

          if (nutritionFacts.fiber != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_fiber,
              value: nutritionFacts.fiber!.per100g,
              unit: 'g',
              nutrientType: 'fiber',
            ),

          if (nutritionFacts.proteins != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_proteins,
              value: nutritionFacts.proteins!.per100g,
              unit: 'g',
              nutrientType: 'protein',
            ),

          if (nutritionFacts.salt != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_salt,
              value: nutritionFacts.salt!.per100g,
              unit: 'g',
              nutrientType: 'salt',
            ),

          if (nutritionFacts.sodium != null)
            _NutrientRow(
              name: AppLocalizations.of(context)!
                  .product_nutrition_facts_sodium,
              value: nutritionFacts.sodium!.per100g,
              unit: 'mg',
              nutrientType: 'sodium',
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({
    required this.name,
    required this.value,
    required this.unit,
    required this.nutrientType,
  });

  final String name;
  final dynamic value;
  final String unit;
  final String nutrientType;

  double? _parseValue() {
    if (value is num) {
      return (value as num).toDouble();
    } else if (value is String) {
      return double.tryParse(value as String);
    }
    return null;
  }

  Color _getColor() { //détermine la couleur en fonction de la valeur et du nutriment
    final doubleValue = _parseValue();
    if (doubleValue == null) return AppColors.grey2;

    switch (nutrientType.toLowerCase()) {
      case 'fat':
        if (doubleValue <= 3) return AppColors.nutrientLevelLow;
        if (doubleValue <= 20) return AppColors.nutrientLevelModerate;
        return AppColors.nutrientLevelHigh;

      case 'saturated fat':
        if (doubleValue <= 1.5) return AppColors.nutrientLevelLow;
        if (doubleValue <= 5) return AppColors.nutrientLevelModerate;
        return AppColors.nutrientLevelHigh;

      case 'sugar':
        if (doubleValue <= 5) return AppColors.nutrientLevelLow;
        if (doubleValue <= 12.5) return AppColors.nutrientLevelModerate;
        return AppColors.nutrientLevelHigh;

      case 'salt':
      case 'sodium':
        if (doubleValue <= 0.3) return AppColors.nutrientLevelLow;
        if (doubleValue <= 1.5) return AppColors.nutrientLevelModerate;
        return AppColors.nutrientLevelHigh;

      default:
        return AppColors.grey2;
    }
  }

  String _getLabel() {
    final doubleValue = _parseValue();
    if (doubleValue == null) return '-';

    switch (nutrientType.toLowerCase()) {
      case 'fat':
        if (doubleValue <= 3) return 'Faible quantité';
        if (doubleValue <= 20) return 'Quantité modérée';
        return 'Quantité élevée';

      case 'saturated fat':
        if (doubleValue <= 1.5) return 'Faible quantité';
        if (doubleValue <= 5) return 'Quantité modérée';
        return 'Quantité élevée';

      case 'sugar':
        if (doubleValue <= 5) return 'Faible quantité';
        if (doubleValue <= 12.5) return 'Quantité modérée';
        return 'Quantité élevée';

      case 'salt':
      case 'sodium':
        if (doubleValue <= 0.3) return 'Faible quantité';
        if (doubleValue <= 1.5) return 'Quantité modérée';
        return 'Quantité élevée';

      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final label = _getLabel();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ProductTab2._kHorizontalPadding,
        12.0,
        ProductTab2._kHorizontalPadding,
        12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${value ?? '—'} $unit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}