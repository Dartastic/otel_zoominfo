// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_zoominfo/otel_zoominfo.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_zoominfo-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('contact.search records credits + result counts', () async {
    await tracedZoomInfo<String>(
      operation: 'contact.search',
      invoke: () async => const ZoomInfoCallResult(
        value: 'ok',
        result: ZoomInfoResult(
          entity: 'contact',
          searchType: 'standard',
          recordsReturned: 25,
          totalResults: 1024,
          creditsCharged: 25,
          creditsRemaining: 9700,
          creditsLimit: 10000,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('zoominfo contact.search')!);
    expect(a['zoominfo.records_returned'], 25);
    expect(a['zoominfo.credits.charged'], 25);
    expect(a['zoominfo.credits.remaining'], 9700);
  });

  test('intent.search records topic + score', () async {
    await tracedZoomInfo<String>(
      operation: 'intent.search',
      invoke: () async => const ZoomInfoCallResult(
        value: 'ok',
        result: ZoomInfoResult(
          entity: 'intent',
          intentTopic: 'CDP Platform',
          intentScore: 87.5,
          intentSignalCount: 14,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('zoominfo intent.search')!);
    expect(a['zoominfo.intent.topic'], 'CDP Platform');
    expect(a['zoominfo.intent.score'], 87.5);
  });

  test('rate_limit sets span error', () async {
    await tracedZoomInfo<String>(
      operation: 'contact.search',
      invoke: () async => const ZoomInfoCallResult(
        value: 'ok',
        result: ZoomInfoResult(
          errorCode: 'rate_limit_exceeded',
          statusCode: 429,
        ),
      ),
    );
    expect(
      spans.findSpanByName('zoominfo contact.search')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutZoomInfoInstrumentationAsync(() async {
      await tracedZoomInfo<String>(
        operation: 'lookup.contact',
        invoke: () async => const ZoomInfoCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('zoominfo '), isEmpty);
  });
}
