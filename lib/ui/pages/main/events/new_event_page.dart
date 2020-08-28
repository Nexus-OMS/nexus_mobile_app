import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/models/event.dart';
import 'package:nexus_mobile_app/models/event_type.dart';
import 'package:nexus_mobile_app/models/model.dart';
import 'package:nexus_mobile_app/ui/components/selection_row.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/ui/typography.dart';

class NewEventPage extends StatefulWidget {
  final List<EventType> types;
  NewEventPage(this.types);
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

enum _NewEventState { none, loading }

class _NewEventPageState extends State<NewEventPage> {
  EventRepository repository;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  int selectedType;

  _NewEventState _state = _NewEventState.none;

  Event event;

  @override
  void initState() {
    super.initState();
    repository = EventRepository(context.client);
    event = Event();
    event.event_type = widget.types[0].id;
    _dateFocus.addListener(() {
      if (_dateFocus.hasFocus) {
        showDate();
      }
    });
    _nameFocus.requestFocus();
  }

  void showDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: event.date,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (date != null) {
      setState(() {
        event.date = date;
      });
      _dateController.text = DateFormat.yMMMMEEEEd().format(date);
      _dateFocus.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _insets = EdgeInsets.fromLTRB(24, 12, 24, 12);
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Headline('New Event'),
                    ),
                    Padding(
                      padding: _insets,
                      child: SelectionRow(
                          (Model model) => event.event_type = model.id,
                          0,
                          widget.types),
                    ),
                    Padding(
                      padding: _insets,
                      child: TextFormField(
                        focusNode: _nameFocus,
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: _insets,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Date'),
                        focusNode: _dateFocus,
                        keyboardType: null,
                        controller: _dateController,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      setState(() {
                        _state = _NewEventState.loading;
                        event.name = _nameController.text;
                      });
                      var resp = await repository.saveEvent(event);
                      if (resp != null) {
                        Navigator.of(context).pop(resp);
                      } else {
                        setState(() {
                          _state = _NewEventState.none;
                        });
                      }
                    },
                    child: _state == _NewEventState.loading
                        ? CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ],
              )
            ],
          )),
    ));
  }
}
