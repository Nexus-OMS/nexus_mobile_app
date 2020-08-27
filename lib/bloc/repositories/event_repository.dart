import 'dart:async';

import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/services/PaginateService.dart';

class EventRepository {
  PaginateService eventPager;
  List<Event> events = [];
  List<EventType> types = [];

  EventRepository() {
    eventPager = PaginateService(route: APIRoutes.routes[Event]);
  }

  bool nullEmpty(dynamic obj) {
    return (obj == null || obj.length == 0);
  }

  Future<List<Event>> pageEvents({String query, bool refresh}) async {
    if (refresh ?? false) {
      eventPager = PaginateService(route: APIRoutes.routes[Event]);
      events = [];
    }
    var raw_values = query != null
        ? await eventPager.page(query: query)
        : await eventPager.page();
    for (var item in raw_values) {
      var event = Event.fromMap(item);
      events.removeWhere((sitem) => sitem.id == event.id);
      events.add(event);
    }
    return events;
  }

  static Future<List<Attendance>> getEventAttendance(int id) async {
    var event = await AuthorizedClient.get(
        route: '${APIRoutes.routes[Event]}/${id.toString()}/attendance');
    var attendance = <Attendance>[];
    if (event != null) {
      for (var att in event['attendance']) {
        attendance.add(Attendance.fromMap(att));
      }
      return attendance;
    }
    return event;
  }

  static Future<Event> saveEvent(Event event) async {
    try {
      var resp = await AuthorizedClient.post(
          route: APIRoutes.routes[Event], content: event.toMap());
      resp['event_type'] = resp['event_type']['o_id'];
      resp['term'] = resp['term']['term'];
      return Event.fromMap(resp);
    } catch (e) {
      return null;
    }
  }

  static Future<Attendance> saveAttendance(int event_id,
      {int user_id, String user_uid, int attendance_type = 4}) async {
    try {
      if (user_uid != null) {
        // TODO figure out a better way for an organization to set what
        // to cut the string down by
        var content = {
          'uid': user_uid.substring(0, user_uid.length - 1),
          'event_id': event_id.toString(),
          'attendance_type': attendance_type.toString()
        };
        var resp = await AuthorizedClient.post(
            route: APIRoutes.routes[Attendance] + '/storebyuid',
            content: content);
        return Attendance.fromMap(resp);
      } else {
        var content = {
          'user_id': user_id.toString(),
          'event_id': event_id.toString(),
          'attendance_type': attendance_type.toString()
        };
        var resp = await AuthorizedClient.post(
            route: APIRoutes.routes[Attendance], content: content);
        return Attendance.fromMap(resp);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Event>> getEvents(EventType type) async {
    var _events = [];
    try {
      var raw_values = await AuthorizedClient.get(
          route: '/api/v1/self/events?type=${type.id}');
      for (var item in raw_values) {
        var event = Event.fromMap(item);
        _events.removeWhere((sitem) => sitem.id == event.id);
        _events.add(event);
      }
    } catch (e) {
      return null;
    }
    return _events;
  }

  Future<List<EventType>> getEventTypes() async {
    try {
      var raw_values =
          await AuthorizedClient.get(route: APIRoutes.routes[EventType]);
      for (var item in raw_values) {
        var event = EventType.fromMap(item);
        types.removeWhere((sitem) => sitem.id == event.id);
        types.add(event);
      }
    } catch (e) {
      return null;
    }
    return types;
  }
}
