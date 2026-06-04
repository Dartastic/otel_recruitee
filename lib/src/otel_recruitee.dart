// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_recruitee_suppression.dart';

class RecruiteeResult {
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

class RecruiteeCallResult<T> {
  const RecruiteeCallResult({required this.value, this.result});
  final T value;
  final RecruiteeResult? result;
}

Future<T> tracedRecruitee<T>({
  required String operation,
  required Future<RecruiteeCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (recruiteeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_recruitee');
  final span = t.startSpan('recruitee $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'recruitee')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.companyId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('recruitee.company.id', res.companyId!)]));
      }
      if (res.offerId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('recruitee.offer.id', res.offerId!)]));
      }
      if (res.offerTitle != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('recruitee.offer.title', res.offerTitle!)]));
      }
      if (res.offerStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('recruitee.offer.status', res.offerStatus!)
        ]));
      }
      if (res.candidateId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('recruitee.candidate.id', res.candidateId!)
        ]));
      }
      if (res.candidateStage != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('recruitee.candidate.stage', res.candidateStage!)
        ]));
      }
      if (res.disqualifiedAt != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'recruitee.candidate.disqualified_at', res.disqualifiedAt!)
        ]));
      }
      if (res.placementId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('recruitee.placement.id', res.placementId!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('recruitee.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'recruitee.error')
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
