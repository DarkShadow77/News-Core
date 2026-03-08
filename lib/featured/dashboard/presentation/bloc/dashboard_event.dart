part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class PageChangedEvent extends DashboardEvent {
  final int index;

  PageChangedEvent({required this.index});
}
