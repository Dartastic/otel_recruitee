// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_recruitee_suppression.dart';

class RecruiteeResult {
  /// Creates a result.
  const RecruiteeResult({
    this.companyId,
    this.offerId,
    this.offerTitle,
    this.offerStatus,
    this.candidateId,
    this.candidateStage,
    this.disqualifiedAt,
    this.placementId,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? companyId;
  final String? offerId;
  final String? offerTitle;
  final String? offerStatus;
  final String? candidateId;
  final String? candidateStage;
  final String? disqualifiedAt;
  final String? placementId;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class RecruiteeCallResult<T> {
  /// Creates a call result.
  const RecruiteeCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final RecruiteeResult? result;
}

Future<T> tracedRecruitee<T>({
  required String operation,
  required Future<RecruiteeCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (recruiteeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_recruitee');
  final span = t.startSpan('recruitee $operation', kind: SpanKind.client);
  try {
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.system', 'recruitee')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('recruitee.company.id', res.companyId!)]));
      }
      if (res.offerId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('recruitee.offer.id', res.offerId!)]));
      }
      if (res.offerTitle != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('recruitee.offer.title', res.offerTitle!)
        ]));
      }
      if (res.offerStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('recruitee.offer.status', res.offerStatus!)
        ]));
      }
      if (res.candidateId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('recruitee.candidate.id', res.candidateId!)
        ]));
      }
      if (res.candidateStage != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'recruitee.candidate.stage', res.candidateStage!)
        ]));
      }
      if (res.disqualifiedAt != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'recruitee.candidate.disqualified_at', res.disqualifiedAt!)
        ]));
      }
      if (res.placementId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('recruitee.placement.id', res.placementId!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('recruitee.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'recruitee.error')
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
