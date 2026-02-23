import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/success/product_header.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab0.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab1.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab2.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab3.dart';
import 'package:provider/provider.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:formation_flutter/screens/product/recall_banner.dart';

class ProductPageBody extends StatefulWidget {
  const ProductPageBody({super.key});

  @override
  State<ProductPageBody> createState() => _ProductPageBodyState();
}

class _ProductPageBodyState extends State<ProductPageBody> {
  late ProductDetailsCurrentTab _tab;

  @override
  void initState() {
    super.initState();
    _tab = ProductDetailsCurrentTab.summary;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Provider<Product>(
      create: (_) =>
          (context.read<ProductFetcher>().state as ProductFetcherSuccess)
              .product,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                ProductPageHeader(),
                SliverPadding(
                  padding: EdgeInsetsDirectional.only(top: 10.0),
                  sliver: SliverFillRemaining(
                    fillOverscroll: true,
                    hasScrollBody: false,
                    child: _getBody(),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: _tab.index,
            onTap: (int position) => setState(
              () => _tab = ProductDetailsCurrentTab.values[position],
            ),
            items: ProductDetailsCurrentTab.values
                .map(
                  (ProductDetailsCurrentTab tab) => BottomNavigationBarItem(
                    icon: Icon(tab.icon),
                    label: tab.label(localizations),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        Consumer<RecallFetcher>(
          builder: (context, recall, _) {
            return switch (recall.state) {
              RecallFetcherLoading() => const SizedBox.shrink(),
              RecallFetcherError(error: var erreur) => const SizedBox.shrink(),
              RecallFetcherEmpty() => const SizedBox.shrink(),
              RecallFetcherSuccess(hasRecall: final hasRecall) =>
                hasRecall
                    ? const RecallBanner(
                        //bannière rouge produit rappelé
                        label: "Ce produit fait l'objet d'un rappel",
                      )
                    : const SizedBox.shrink(),
            };
          },
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: _tab != ProductDetailsCurrentTab.summary,
                child: ProductTab0(),
              ),
              Offstage(
                offstage: _tab != ProductDetailsCurrentTab.info,
                child: ProductTab1(),
              ),
              Offstage(
                offstage: _tab != ProductDetailsCurrentTab.nutrition,
                child: ProductTab2(),
              ),
              Offstage(
                offstage: _tab != ProductDetailsCurrentTab.nutritionalValues,
                child: ProductTab3(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum ProductDetailsCurrentTab {
  summary(AppIcons.tab_barcode),
  info(AppIcons.tab_fridge),
  nutrition(AppIcons.tab_nutrition),
  nutritionalValues(AppIcons.tab_array);

  const ProductDetailsCurrentTab(this.icon);

  final IconData icon;

  String label(AppLocalizations appLocalizations) => switch (this) {
    ProductDetailsCurrentTab.summary => appLocalizations.product_tab_summary,
    ProductDetailsCurrentTab.info => appLocalizations.product_tab_properties,
    ProductDetailsCurrentTab.nutrition =>
      appLocalizations.product_tab_nutrition,
    ProductDetailsCurrentTab.nutritionalValues =>
      appLocalizations.product_tab_nutrition_facts,
  };
}
