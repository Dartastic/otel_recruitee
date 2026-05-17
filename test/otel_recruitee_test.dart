// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_recruitee/otel_recruitee.dart';
import 'package:test/test.dart';

void main() {
  group('otel_recruitee', () {
    test('suppression toggles in zone', () async {
      expect(recruiteeInstrumentationSuppressed(), isFalse);
      await runWithoutRecruiteeInstrumentationAsync(() async {
        expect(recruiteeInstrumentationSuppressed(), isTrue);
      });
      expect(recruiteeInstrumentationSuppressed(), isFalse);
    });

    test('RecruiteeResult fields default null', () {
      const r = RecruiteeResult();
      expect(r.statusCode, isNull);
    });
  });
}
