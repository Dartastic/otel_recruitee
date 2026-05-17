# otel_recruitee

Dartastic OpenTelemetry bridge for Recruitee (recruiting / ATS).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_recruitee/otel_recruitee.dart';

await tracedRecruitee<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return RecruiteeCallResult(value: r, result: RecruiteeResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutRecruiteeInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
