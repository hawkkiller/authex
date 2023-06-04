import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:l/l.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) {
    final buf = StringBuffer()
      ..writeln('Request to ${data.url}')
      ..writeln('Method: ${data.method}')
      ..writeln('Headers: ${data.headers}')
      ..writeln('Body: ${data.body}');
    l.i(buf.toString());
    return SynchronousFuture(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) {
    final buf = StringBuffer()
      ..writeln('Response from ${data.url}')
      ..writeln('Status code: ${data.statusCode}')
      ..writeln('Headers: ${data.headers}')
      ..writeln('Body: ${data.body}');
    l.i(buf.toString());
    return SynchronousFuture(data);
  }
}
