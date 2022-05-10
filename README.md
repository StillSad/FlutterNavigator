## Navigator2.0

### 基本概念

1. Page：用来表示路由栈中各个页面的不可变对象，Page是个抽象类，通常使用它的派生类MateriaPage或CupertinoPage
2. Router：配置Navigator
3. RouteDelegate：定义路由行为，监听RouteInfomationParser和应用状态，并构建Pages
4. RouteInformationParser：应用再web端，移动端可缺省

### 基本使用

1、定义**RouterDelegate** 并混入**ChangeNotifier**和**PopNavigatorRouterDelegateMixin**

```dart
class AppRouteDelegate extends RouterDelegate<dynamic>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<MaterialPage> _pages = [];

  @override
  Widget build(BuildContext context) {
    print('AppRouteDelegate:build');
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(dynamic configuration) async {}
    
  bool _onPopPage(Route<dynamic> route, dynamic result) {
    //处理路由退栈逻辑
    if(!route.didPop(result)) return false;

    if(_pages.isEmpty) return false;

    _pages.removeLast();
    return true;
  }
    
}
```

再build中创建了Navigator为路由管理者，并设置了pages和onPopPage属性。

这里pages是存放Page对象的列表，页面会显示pages里最后一个元素对应的页面。onPopPage 是当路由被pop时的回调，在这里处理路由退栈逻辑

2、增加**创建Page**、**压入新页面**、**替换当前显示页面** 三个方法

```dart
///创建Page  
MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
        case "/home":
            child = const HomePage();
            break;
        case "/splash":
            child = const SplashPage();
            break;
        case "/login":
            child = const LoginPage();
            break;
        case "/details":
            child = DetailsPage(routeSettings.arguments! as String);
            break;
        default:
            child = const Scaffold();
}

	return MaterialPage(
    	child: child,
    	key: Key(routeSettings.name!) as LocalKey,
    	name: routeSettings.name,
    	arguments: routeSettings.arguments);
}

///压入新页面
void push({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
}

///替换当前显示页面
void replace({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
        _pages.removeLast();
    }
    push(name: name, arguments: arguments);
}
```

3、替换MaterialApp home属性为Router

```dart
///实例化一个AppRouteDelegate的全局变量方便其他位置使用
AppRouteDelegate appRouteDelegate = AppRouteDelegate();

class MyApp extends StatelessWidget {
  
   MyApp({Key? key}) : super(key: key) {
     appRouteDelegate.push(name: '/splash');
   }

  @override
  Widget build(BuildContext context) {
    var router = Router(
      routerDelegate: appRouteDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );

    return MaterialApp(
      title: 'Navigator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: router,
    );
  }
}
```

4、在页面使用

SplashPage

```dart
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3),(){
      ///3s后替换SplahsPage为HomePage
      appRouteDelegate.replace(name: '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("SplashPage"),),
    );
  }
}
```

HomePage

```dart
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Center(
            child: Text("HomePage"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                ///跳转到Detail页面
                appRouteDelegate.push(
                    name: '/details',
                    arguments:
                        'https://t7.baidu.com/it/u=801209673,1770377204&fm=193&f=GIF');
              },
              child: Text("跳转details"))
        ],
      ),
    ));
  }
}
```

DetailsPage

```dart
class DetailsPage extends StatefulWidget {
  String imageUrl;

  DetailsPage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Container(
        child: SafeArea(
          child: Container(child: Image.network(widget.imageUrl),),
        ),
      )
    );
  }
}
```

### 兼容浏览器URL

基本使用在网页上运行时会有两个问题

* 当页面发生变化时地址栏url并不会一起改变

* 在地址栏url输入地址时不能进入到指定页面

1、定义**RouteInformationParser**

```dart
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
```

parseRouteInformation:将URL地址转换成路由状态(RouteSettings)

restoreRouteInformation:将路由状态转换为一个URL地址

2、修改RouterDelegate添加方法

```dart
  @override
  List<Page> get currentConfiguration => List.of(_pages);

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {
    debugPrint('setNewRoutePath ${configuration.last.name}');

    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());

  }

  void _setPath(List<MaterialPage> pages) {
    _pages.clear();
    _pages.addAll(pages);

    if(_pages.first.name != '/') {
      _pages.insert(0, _createPage(const RouteSettings(name: '/')));
    }

    notifyListeners();
  }

```

