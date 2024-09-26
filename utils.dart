import 'dart:io';

String readInput(String prompt) {
  stdout.write('$prompt: ');
  return stdin.readLineSync() ?? '';
}

void printError(String message) {
  print('Error: $message');
}
