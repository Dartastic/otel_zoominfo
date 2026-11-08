// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_zoominfo_suppression.dart';

class ZoomInfoResult {
  /// Creates a result.
  const ZoomInfoResult({
    this.surface,
    this.entity,
    this.searchType,
    this.matchType,
    this.matchConfidence,
    this.recordsReturned,
    this.totalResults,
    this.pageNumber,
    this.creditsCharged,
    this.creditsRemaining,
    this.creditsLimit,
    this.intentTopic,
    this.intentScore,
    this.intentSignalCount,
    this.scoopType,
    this.scoopCount,
    this.technologyCount,
    this.companyId,
    this.contactId,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? surface;
  final String? entity;
  final String? searchType;
  final String? matchType;
  final String? matchConfidence;
  final int? recordsReturned;
  final int? totalResults;
  final int? pageNumber;
  final int? creditsCharged;
  final int? creditsRemaining;
  final int? creditsLimit;
  final String? intentTopic;
  final double? intentScore;
  final int? intentSignalCount;
  final String? scoopType;
  final int? scoopCount;
  final int? technologyCount;
  final String? companyId;
  final String? contactId;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class ZoomInfoCallResult<T> {
  /// Creates a call result.
  const ZoomInfoCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final ZoomInfoResult? result;
}

Future<T> tracedZoomInfo<T>({
  required String operation,
  required Future<ZoomInfoCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (zoomInfoInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_zoominfo');
  final span = t.startSpan('zoominfo $operation', kind: SpanKind.client);
  try {
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.system', 'zoominfo')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.surface != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.surface', res.surface!)]));
      }
      if (res.entity != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.entity', res.entity!)]));
      }
      if (res.searchType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('zoominfo.search.type', res.searchType!)
        ]));
      }
      if (res.matchType != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.match.type', res.matchType!)]));
      }
      if (res.matchConfidence != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'zoominfo.match.confidence', res.matchConfidence!)
        ]));
      }
      if (res.recordsReturned != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'zoominfo.records_returned', res.recordsReturned!)
        ]));
      }
      if (res.totalResults != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('zoominfo.total_results', res.totalResults!)
        ]));
      }
      if (res.pageNumber != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('zoominfo.page', res.pageNumber!)]));
      }
      if (res.creditsCharged != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('zoominfo.credits.charged', res.creditsCharged!)
        ]));
      }
      if (res.creditsRemaining != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'zoominfo.credits.remaining', res.creditsRemaining!)
        ]));
      }
      if (res.creditsLimit != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('zoominfo.credits.limit', res.creditsLimit!)
        ]));
      }
      if (res.intentTopic != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('zoominfo.intent.topic', res.intentTopic!)
        ]));
      }
      if (res.intentScore != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble('zoominfo.intent.score', res.intentScore!)
        ]));
      }
      if (res.intentSignalCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'zoominfo.intent.signal_count', res.intentSignalCount!)
        ]));
      }
      if (res.scoopType != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.scoop.type', res.scoopType!)]));
      }
      if (res.scoopCount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('zoominfo.scoop.count', res.scoopCount!)]));
      }
      if (res.technologyCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'zoominfo.technology.count', res.technologyCount!)
        ]));
      }
      if (res.companyId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.company.id', res.companyId!)]));
      }
      if (res.contactId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.contact.id', res.contactId!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('zoominfo.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'zoominfo.error')
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
