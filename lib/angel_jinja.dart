import 'package:angel_framework/angel_framework.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/src/undefined.dart';
import 'package:jinja/src/parser.dart' show ParserCallback;

export 'package:jinja/src/loaders.dart';

/// Configures an Angel server to use Jinja2 to render templates.
///
/// By default, templates are loaded from the filesystem;
/// pass your own [createLoader] callback to override this.
///
/// All options other than [createLoader] are passed to either [FileSystemLoader]
/// or [Environment].
AngelConfigurer jinja({
  String blockStart = '{%',
  String blockEnd = '%}',
  String variableStart = '{{',
  String variableEnd = '}}',
  String commentStart = '{#',
  String commentEnd = '#}',
  bool autoEscape = false,
  bool trimBlocks = false,
  bool leftStripBlocks = false,
  Loader Function() createLoader,
  bool optimize = true,
  Map<String, ParserCallback> extensions = const <String, ParserCallback>{},
  Map<String, Object> globals = const <String, Object>{},
  Map<String, Function> filters = const <String, Function>{},
  Map<String, Function> tests = const <String, Function>{},
}) {
  return (app) {
    createLoader ??= () {
      return FileSystemLoader();
    };
    var env = Environment(
      blockStart: blockStart,
      blockEnd: blockEnd,
      variableStart: variableStart,
      variableEnd: variableEnd,
      commentStart: commentStart,
      commentEnd: commentEnd,
      optimize: optimize,
      loader: createLoader(),
      extensions: extensions,
      globals: globals,
      filters: filters,
      tests: tests,
    );

    app.viewGenerator = (path, [values]) {
      return env.getTemplate(path).renderMap(values);
    };
  };
}
