import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

@sealed
class AppBlocObserver extends BlocObserver {
  static final log = Logger('BlocObserver');
  static AppBlocObserver? _instance;

  factory AppBlocObserver.instance() => _instance ??= const AppBlocObserver._();
  const AppBlocObserver._();

  @override
  // Тут так нужно.
  // ignore:avoid-dynamic
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log.severe('Unhandled bloc exception', error, stackTrace);
  }
}
