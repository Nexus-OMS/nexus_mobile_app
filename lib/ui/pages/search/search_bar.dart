import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/enum/search_types.dart';
import 'package:nexus_mobile_app/ui/pages/search/search_page.dart';

const double CUSTOM_APP_BAR_HEIGHT = kToolbarHeight;

class SearchBar extends StatefulWidget {
  final bool floating;
  final Function(dynamic) searchReturn;
  final List<SearchTypes> searchTypes;

  const SearchBar(
      {Key key,
      @required this.floating,
      @required this.searchReturn,
      this.searchTypes})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CUSTOM_APP_BAR_HEIGHT,
      margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Center(
        child: Card(
          elevation: widget.floating ? 4 : 0,
          child: InkWell(
              onTap: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_context) => context.clientProvider(
                            SearchPage(context.client,
                                filters: widget.searchTypes ??
                                    [SearchTypes.users]))));
                widget.searchReturn(result);
              },
              child: Container(
                height: kToolbarHeight,
                child: Center(
                  child: Icon(Icons.search),
                ),
              )),
        ),
      ),
    );
  }
}
