import 'dart:io';

import 'package:dart_pre_commit/dart_pre_commit.dart';
import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  print(arguments);
  Map<Git, UserBackFun> params = {
    Git.commitMsg: _conventionalCommitMsg,
    // Git.preCommit: _preCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> _preCommit() async {
  // Run dart_pre_commit package function to auto run various flutter commands
  final result = await DartPreCommit.run();
  return result.isSuccess;
}

Future<bool> _conventionalCommitMsg() async {
  var commitMsg = Utils.getCommitEditMsg();
  RegExp conventionCommitPattern = RegExp(
      r'''^(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge){1}(\([\w\-\.]+\))?(!)?:( )?([\w ])+([\s\S]*)''');

  if (conventionCommitPattern.hasMatch(commitMsg)) return true;

  if (!RegExp(
          r'(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)')
      .hasMatch(commitMsg)) {
    print(
        '🛑 Invalid type used in commit message. It should be one of (feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)');
  } else {
    print(
        '🛑 Commit message should follow conventional commit pattern: https://www.conventionalcommits.org/en/v1.0.0/');
  }

  // var pwd = await Process.run('pwd', []);
  // print('pwd: ${pwd.stdout}');
  var result = await Process.run('git-chglog', ['-o', 'CHANGELOG.md']);
  // var result = await Process.run('git-chglog', ['v1.0.3..v1.0.4']);
  print('Exit code: ${result.exitCode}');
  print('Standard output: ${result.stdout}');
  print('Standard error: ${result.stderr}');

  return false;
}
