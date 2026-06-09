import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../notification/notification_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc
    extends HydratedBloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState(PermissionStatus.denied)) {
    on<NotificationEvent>((event, emit) async {
      if (event is SyncNotificationPermission) {
        await _emitFromOsPermission(emit);
      } else if (event is UpdateNotification) {
        await _emitFromOsPermission(emit);
      } else if (event is ToggleNotification) {
        if (state.status == PermissionStatus.denied ||
            state.status == PermissionStatus.permanentlyDenied) {
          await NotificationService().ensureReady();
          await _emitFromOsPermission(emit);
        } else if (state.status == PermissionStatus.restricted) {
          emit(const NotificationState(PermissionStatus.granted));
        } else if (state.status == PermissionStatus.granted) {
          await NotificationService().cancelAllNotifications();
          emit(const NotificationState(PermissionStatus.restricted));
        }
      }
    });
  }

  Future<void> _emitFromOsPermission(
    Emitter<NotificationState> emit,
  ) async {
    if (state.status == PermissionStatus.restricted) {
      return;
    }

    final osStatus = await Permission.notification.status;
    if (osStatus.isGranted) {
      emit(const NotificationState(PermissionStatus.granted));
    } else if (osStatus.isPermanentlyDenied) {
      emit(const NotificationState(PermissionStatus.permanentlyDenied));
    } else {
      emit(const NotificationState(PermissionStatus.denied));
    }
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    try {
      PermissionStatus status = PermissionStatus.denied;
      switch (json['status'] as int) {
        case 1:
          status = PermissionStatus.denied;
          break;
        case 2:
          status = PermissionStatus.permanentlyDenied;
          break;
        case 3:
          status = PermissionStatus.granted;
          break;
        case 4:
          status = PermissionStatus.restricted;
          break;
        default:
          status = PermissionStatus.denied;
      }
      return NotificationState(status);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    try {
      int value = 0;
      switch (state.status) {
        case PermissionStatus.denied:
          value = 1;
          break;
        case PermissionStatus.permanentlyDenied:
          value = 2;
          break;
        case PermissionStatus.granted:
          value = 3;
          break;
        case PermissionStatus.restricted:
          value = 4;
          break;
        default:
          value = 0;
      }
      return {'status': value};
    } catch (_) {
      return null;
    }
  }
}
