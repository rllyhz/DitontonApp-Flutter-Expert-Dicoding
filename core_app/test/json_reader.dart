import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  if (dir.endsWith('core_app')) {
    return File('$dir/test/$name').readAsStringSync();
  }
  return File('$dir/core_app/test/$name').readAsStringSync();
}
