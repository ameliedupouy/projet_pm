import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _SectionWidget(
            title: 'Ingrédients',
            child: _buildIngredientsList(product.ingredients),
          ),

          _SectionWidget(
            title: 'Substances allergènes',
            child: _buildSimpleList(product.allergens, "Aucune"),
          ),

          _SectionWidget(
            title: 'Additifs',
            child: _buildSimpleList(product.additives?.values.toList(), "Aucune"),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildIngredientsList(List<String>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) {
      return const _RowItem(label: "Données indisponibles");
    }

    return Column(
      children: [
        for (int i = 0; i < ingredients.length; i++) ...[
          _buildIngredientRow(ingredients[i]),
          if (i < ingredients.length - 1) const _CustomDivider(),
        ],
      ],
    );
  }

  Widget _buildIngredientRow(String text) {
    if (text.contains(':')) {
      final parts = text.split(':');
      return _RowItem(label: parts[0].trim(), value: parts[1].trim());
    }
    return _RowItem(label: text);
  }

  Widget _buildSimpleList(List<String>? items, String emptyLabel) {
    if (items == null || items.isEmpty) {
      return _RowItem(label: emptyLabel);
    }
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _RowItem(label: items[i]),
          if (i < items.length - 1) const _CustomDivider(),
        ],
      ],
    );
  }
}


class _RowItem extends StatelessWidget {
  final String label;
  final String? value;

  const _RowItem({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          if (value != null)
            Expanded(
              child: Text(
                value!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF4A4A4A), //gris foncé lisible
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionWidget({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFF8F8FA),
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}