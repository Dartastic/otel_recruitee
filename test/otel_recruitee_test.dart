// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
