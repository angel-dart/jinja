import 'package:angel_framework/angel_framework.dart';
import 'package:jinja/jinja.dart';

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
  bool trimBlocks = false,
  bool leftStripBlocks = false,
  bool keepTrailingNewLine = false,
  bool optimize = true,
  Finalizer finalize = defaultFinalizer,
  bool autoEscape = false,
  Loader Function() createLoader,
  Map<String, Function> filters = const <String, Function>{},
  Map<String, Function> envFilters = const <String, Function>{},
  Map<String, Function> tests = const <String, Function>{},
  Map<String, Object> globals = const <String, Object>{},
  FieldGetter getField = defaultFieldGetter,
  ItemGetter getItem = defaultItemGetter,
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
      trimBlocks: trimBlocks,
      leftStripBlocks: leftStripBlocks,
      keepTrailingNewLine: keepTrailingNewLine,
      optimize: optimize,
      finalize: finalize,
      autoEscape: autoEscape,
      loader: createLoader(),
      filters: filters,
      envFilters: envFilters,
      tests: tests,
      globals: globals,
      getField: getField,
      getItem: getItem,
    );

    app.viewGenerator = (path, [values]) {
      return env.getTemplate(path).renderMap(values);
    };
  };
}
