import 'package:nexus_mobile_app/models/models.dart';

class APIRoutes {
  static Map<Type, String> routes = {
    User: '/api/v1/users',
    Update: '/api/v1/updat', // fix to updates
    Unit: '/api/v1/units',
    Announcement: '/api/v1/announcements',
    Attendance: '/api/v1/attendance',
    AttendanceType: '/api/v1/attendance/types',
    Event: '/api/v1/events',
    EventType: '/api/v1/eventtypes',
    Level: '/api/v1/level',
    Permission: '/api/v1/permissions',
    Position: '/api/v1/positions',
    Rank: '/api/v1/ranks',
    Term: '/api/v1/terms',
  };
}
