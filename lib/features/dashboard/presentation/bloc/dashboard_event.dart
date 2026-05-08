part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

class ChangeDashboardPeriod extends DashboardEvent {
  final DashboardPeriod period;

  const ChangeDashboardPeriod(this.period);

  @override
  List<Object?> get props => [period];
}
