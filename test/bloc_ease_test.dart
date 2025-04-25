import 'package:flutter_test/flutter_test.dart';

// Import all test files here
import 'core/states.test.dart' as states_test;
import 'mixins/state_cache_mixin.test.dart' as state_cache_mixin_test;
import 'core/base_bloc.extensions.test.dart' as base_bloc_extensions_test;
import 'mixins/state_debounce.mixin.test.dart' as state_debounce_mixin_test;
import 'utils/bloc_ease_utils.test.dart' as bloc_ease_utils_test;
void main() {
  // Run all test files
  group('BlocEase Tests', () {
    group('Core', () {
      states_test.main();
      base_bloc_extensions_test.main();
    });

    group('Mixins', () {
      state_cache_mixin_test.main();
      state_debounce_mixin_test.main();
    });

    group('Utils', () {
      bloc_ease_utils_test.main();
    });
  });
}
