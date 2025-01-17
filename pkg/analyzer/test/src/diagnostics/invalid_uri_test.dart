// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/context_collection_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(InvalidUriTest);
  });
}

@reflectiveTest
class InvalidUriTest extends PubPackageResolutionTest {
  test_augmentationImport_invalidScheme() async {
    await assertErrorsInCode('''
import augment 'ht:';
''', [
      error(CompileTimeErrorCode.INVALID_URI, 15, 5),
    ]);
  }

  test_libraryExport_invalidScheme() async {
    await assertErrorsInCode('''
export 'ht:';
''', [
      error(CompileTimeErrorCode.INVALID_URI, 7, 5),
    ]);
  }

  test_libraryImport_emptyUri() async {
    await assertNoErrorsInCode('''
import '' as top;
int x = 1;
class C {
  int x = 1;
  int get y => top.x; // ref
}
''');
    assertElement(findNode.simple('x; // ref'), findElement.topGet('x'));
  }

  test_libraryImport_invalidScheme() async {
    await assertErrorsInCode('''
import 'ht:';
''', [
      error(CompileTimeErrorCode.INVALID_URI, 7, 5),
    ]);
  }

  test_part_invalidScheme() async {
    await assertErrorsInCode(r'''
part 'ht:';
''', [
      error(CompileTimeErrorCode.INVALID_URI, 5, 5),
    ]);
  }
}
