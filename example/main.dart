// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_recruitee/otel_recruitee.dart';

/// Traces Recruitee calls with OpenTelemetry.
///
/// `otel_recruitee` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Recruitee call in
/// [tracedRecruitee]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'recruitee-example');

  // Traces a Recruitee call.
  final recruiteeId = await tracedRecruitee<String>(
    operation: 'create',
    invoke: () async {
      // Make the Recruitee call here, then report what it returned.
      const id = 'recruitee_8f3a2c';
      return const RecruiteeCallResult(
          value: id,
          result: RecruiteeResult(
              companyId: 'company_8f3a2c',
              offerId: 'offer_8f3a2c',
              offerTitle: 'example',
              offerStatus: 'succeeded',
              candidateId: 'candidate_8f3a2c',
              candidateStage: 'example',
              disqualifiedAt: 'example',
              placementId: 'placement_8f3a2c',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedRecruitee create returned $recruiteeId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutRecruiteeInstrumentationAsync.
  await runWithoutRecruiteeInstrumentationAsync(
    () => tracedRecruitee<String>(
      operation: 'create',
      invoke: () async {
        const id = 'recruitee_8f3a2c';
        return const RecruiteeCallResult(
            value: id,
            result: RecruiteeResult(
                companyId: 'company_8f3a2c',
                offerId: 'offer_8f3a2c',
                offerTitle: 'example',
                offerStatus: 'succeeded',
                candidateId: 'candidate_8f3a2c',
                candidateStage: 'example',
                disqualifiedAt: 'example',
                placementId: 'placement_8f3a2c',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
