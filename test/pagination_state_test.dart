import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/models/pagination_state.dart';

void main() {
  group('PaginationState Unit Tests', () {
    test('Default values are correct', () {
      const state = PaginationState<String>();
      expect(state.items, isEmpty);
      expect(state.page, 1);
      expect(state.hasMore, true);
      expect(state.isLoading, false);
      expect(state.isLoadingMore, false);
      expect(state.errorMessage, isNull);
      expect(state.isEmpty, true);
    });

    test('copyWith updates state correctly', () {
      const state = PaginationState<String>(isLoading: true);
      expect(state.isLoading, true);

      final updated = state.copyWith(
        items: ['item1', 'item2'],
        page: 1,
        hasMore: true,
        isLoading: false,
      );

      expect(updated.items.length, 2);
      expect(updated.page, 1);
      expect(updated.hasMore, true);
      expect(updated.isLoading, false);
      expect(updated.isEmpty, false);
    });

    test('copyWith handles pagination append and isLoadingMore', () {
      final state = const PaginationState<String>(
        items: ['item1', 'item2'],
        page: 1,
      ).copyWith(isLoadingMore: true);

      expect(state.isLoadingMore, true);
      expect(state.items.length, 2);

      final page2 = state.copyWith(
        items: [...state.items, 'item3', 'item4'],
        page: 2,
        hasMore: false,
        isLoadingMore: false,
      );

      expect(page2.items.length, 4);
      expect(page2.page, 2);
      expect(page2.hasMore, false);
      expect(page2.isLoadingMore, false);
    });

    test('copyWith handles error and clearError properly', () {
      const state = PaginationState<String>();
      final withError = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error',
      );
      expect(withError.errorMessage, 'Network error');

      final cleared = withError.copyWith(
        isLoading: true,
        clearError: true,
      );
      expect(cleared.errorMessage, isNull);
      expect(cleared.isLoading, true);
    });
  });
}
