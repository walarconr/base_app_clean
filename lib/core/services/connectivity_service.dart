import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current list of [ConnectivityResult] whenever the device's
/// network status changes.
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// `true` when at least one network interface is available.
///
/// Defaults to `true` while loading or on stream errors to avoid
/// false-positive "offline" states at startup.
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStreamProvider).when(
        data: (results) => !results.contains(ConnectivityResult.none),
        loading: () => true,
        error: (_, __) => true,
      );
});
