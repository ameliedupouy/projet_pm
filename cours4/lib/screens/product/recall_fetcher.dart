import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

sealed class RecallFetcherState {}

class RecallFetcherLoading extends RecallFetcherState {}

class RecallFetcherError extends RecallFetcherState {
  final Object error;
  RecallFetcherError(this.error);
}

class RecallFetcherEmpty extends RecallFetcherState {}

class RecallFetcherSuccess extends RecallFetcherState {  //si un rappel est trouvé
  final bool hasRecall;
  RecallFetcherSuccess(this.hasRecall);
}

class RecallFetcher extends ChangeNotifier {
  RecallFetcher({required this.barcode}) {
    _fetchRecall();
  }

  final String barcode;

  RecallFetcherState _state = RecallFetcherLoading();
  RecallFetcherState get state => _state;

  final PocketBase pb = PocketBase('http://127.0.0.1:8090');

  Future<void> _fetchRecall() async {
    try {
      _state = RecallFetcherLoading();
      notifyListeners();

      final result = await pb.collection('rappels_produits').getList(
            page: 1,
            perPage: 1,
            filter: 'gtin="$barcode"',
          );

      final hasRecall = result.items.isNotEmpty;

      if (hasRecall) {
        _state = RecallFetcherSuccess(true);
      } else {
        _state = RecallFetcherEmpty();
      }

      notifyListeners();
    } catch (e) {
      _state = RecallFetcherError(e);
      notifyListeners();
    }
  }
}