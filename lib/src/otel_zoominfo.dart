// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_zoominfo_suppression.dart';

class ZoomInfoResult {
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

class ZoomInfoCallResult<T> {
  const ZoomInfoCallResult({required this.value, this.result});
  final T value;
  final ZoomInfoResult? result;
}

Future<T> tracedZoomInfo<T>({
  required String operation,
  required Future<ZoomInfoCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (zoomInfoInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_zoominfo');
  final span = t.startSpan('zoominfo $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'zoominfo');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.surface != null) {
        span.setStringAttribute('zoominfo.surface', res.surface!);
      }
      if (res.entity != null) {
        span.setStringAttribute('zoominfo.entity', res.entity!);
      }
      if (res.searchType != null) {
        span.setStringAttribute('zoominfo.search.type', res.searchType!);
      }
      if (res.matchType != null) {
        span.setStringAttribute('zoominfo.match.type', res.matchType!);
      }
      if (res.matchConfidence != null) {
        span.setStringAttribute(
            'zoominfo.match.confidence', res.matchConfidence!);
      }
      if (res.recordsReturned != null) {
        span.setIntAttribute('zoominfo.records_returned', res.recordsReturned!);
      }
      if (res.totalResults != null) {
        span.setIntAttribute('zoominfo.total_results', res.totalResults!);
      }
      if (res.pageNumber != null) {
        span.setIntAttribute('zoominfo.page', res.pageNumber!);
      }
      if (res.creditsCharged != null) {
        span.setIntAttribute('zoominfo.credits.charged', res.creditsCharged!);
      }
      if (res.creditsRemaining != null) {
        span.setIntAttribute(
            'zoominfo.credits.remaining', res.creditsRemaining!);
      }
      if (res.creditsLimit != null) {
        span.setIntAttribute('zoominfo.credits.limit', res.creditsLimit!);
      }
      if (res.intentTopic != null) {
        span.setStringAttribute('zoominfo.intent.topic', res.intentTopic!);
      }
      if (res.intentScore != null) {
        span.setDoubleAttribute('zoominfo.intent.score', res.intentScore!);
      }
      if (res.intentSignalCount != null) {
        span.setIntAttribute(
            'zoominfo.intent.signal_count', res.intentSignalCount!);
      }
      if (res.scoopType != null) {
        span.setStringAttribute('zoominfo.scoop.type', res.scoopType!);
      }
      if (res.scoopCount != null) {
        span.setIntAttribute('zoominfo.scoop.count', res.scoopCount!);
      }
      if (res.technologyCount != null) {
        span.setIntAttribute('zoominfo.technology.count', res.technologyCount!);
      }
      if (res.companyId != null) {
        span.setStringAttribute('zoominfo.company.id', res.companyId!);
      }
      if (res.contactId != null) {
        span.setStringAttribute('zoominfo.contact.id', res.contactId!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('zoominfo.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'zoominfo.error');
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
