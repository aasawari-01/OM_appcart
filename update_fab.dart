import 'dart:io';

void main() {
  var dirs = [
    Directory('lib/view/screens'),
    Directory('lib/feature'),
  ];
  for (var dir in dirs) {
    if (dir.existsSync()) {
      for (var f in dir.listSync(recursive: true)) {
        if (f is File && f.path.endsWith('.dart')) {
          var content = f.readAsStringSync();
          if (content.contains('floatingActionButton: CustFab') &&
              !content.contains('floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat')) {
             var newContent = content.replaceAllMapped(
                 RegExp(r'(\s+)floatingActionButton:\s*CustFab'),
                 (match) => '${match[1]}floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,${match[1]}floatingActionButton: CustFab'
             );
             f.writeAsStringSync(newContent);
             print('Updated ${f.path}');
          }
        }
      }
    }
  }
}
