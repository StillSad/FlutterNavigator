import 'package:flutter/widgets.dart';

class AppRouteInformationParser
    extends RouteInformationParser<List<RouteSettings>> {
  const AppRouteInformationParser() : super();

  @override
  Future<List<RouteSettings>> parseRouteInformation(
      RouteInformation routeInformation) async {

    print('parseRouteInformation location:${routeInformation.location}');

    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return [const RouteSettings(name: '/home')];
    }

    print('parseRouteInformation:${uri.pathSegments.toString()}');

    final routeSettings = uri.pathSegments
        .map((pathSegment) => RouteSettings(
              name: '/$pathSegment',
              arguments: pathSegment == uri.pathSegments.last
                  ? uri.queryParameters
                  : null,
            ))
        .toList();

    return routeSettings;
  }

  @override
  RouteInformation? restoreRouteInformation(List<RouteSettings> configuration) {
    print('restoreRouteInformation:$configuration');

    final location = configuration.last.name;
    final arguments = _restoreArguments(configuration.last);
    return RouteInformation(location: '$location$arguments');
  }

  String _restoreArguments(RouteSettings routeSettings) {

    if (routeSettings.name != 'details') return '';
    var args = routeSettings.arguments as Map;
    print('_restoreArguments:${args['imgUrl']}');
    return '?imgUrl=${args['imgUrl']}';
  }
}
