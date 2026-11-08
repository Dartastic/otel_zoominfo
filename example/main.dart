// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_zoominfo/otel_zoominfo.dart';

/// Traces Zoominfo calls with OpenTelemetry.
///
/// `otel_zoominfo` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Zoominfo call in
/// [tracedZoomInfo]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'zoominfo-example');

  // Traces a Zoominfo call.
  final zoomInfoId = await tracedZoomInfo<String>(
    operation: 'create',
    invoke: () async {
      // Make the Zoominfo call here, then report what it returned.
      const id = 'zoominfo_8f3a2c';
      return const ZoomInfoCallResult(
          value: id,
          result: ZoomInfoResult(
              surface: 'example',
              entity: 'example',
              searchType: 'standard',
              matchType: 'standard',
              matchConfidence: 'example',
              recordsReturned: 1,
              totalResults: 1,
              pageNumber: 1,
              creditsCharged: 1,
              creditsRemaining: 1,
              creditsLimit: 25,
              intentTopic: 'orders',
              intentScore: 0.5,
              intentSignalCount: 3,
              scoopType: 'standard',
              scoopCount: 3,
              technologyCount: 3,
              companyId: 'company_8f3a2c',
              contactId: 'contact_8f3a2c',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedZoomInfo create returned $zoomInfoId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutZoomInfoInstrumentationAsync.
  await runWithoutZoomInfoInstrumentationAsync(
    () => tracedZoomInfo<String>(
      operation: 'create',
      invoke: () async {
        const id = 'zoominfo_8f3a2c';
        return const ZoomInfoCallResult(
            value: id,
            result: ZoomInfoResult(
                surface: 'example',
                entity: 'example',
                searchType: 'standard',
                matchType: 'standard',
                matchConfidence: 'example',
                recordsReturned: 1,
                totalResults: 1,
                pageNumber: 1,
                creditsCharged: 1,
                creditsRemaining: 1,
                creditsLimit: 25,
                intentTopic: 'orders',
                intentScore: 0.5,
                intentSignalCount: 3,
                scoopType: 'standard',
                scoopCount: 3,
                technologyCount: 3,
                companyId: 'company_8f3a2c',
                contactId: 'contact_8f3a2c',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
