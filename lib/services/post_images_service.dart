import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service helper to post images to a hosting endpoint.
/// By default this will use catbox.moe (reliable and free, no auth required).
/// Returns a map with: { 'success': bool, 'url': String? , 'message': String? , 'body': String? }
class PostImagesService {
  // Default to catbox.moe - reliable, free, no authentication required
  static const String _defaultHost = 'https://catbox.moe/user/api.php';

  /// Uploads a single image file.
  /// Supports multiple free image hosts:
  /// - catbox.moe (default) - reliable, no auth
  /// - imgbb.com - requires API key
  /// - 0x0.st - simple, no auth
  static Future<Map<String, dynamic>> upload(File file, {String? host, String? apiKey}) async {
    host ??= _defaultHost;

    try {
      // catbox.moe API (default and most reliable)
      if (host.contains('catbox.moe')) {
        final uri = Uri.parse(host);
        var request = http.MultipartRequest('POST', uri);

        // catbox.moe requires 'reqtype' field set to 'fileupload'
        request.fields['reqtype'] = 'fileupload';

        // Add the file with field name 'fileToUpload'
        request.files.add(await http.MultipartFile.fromPath('fileToUpload', file.path));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final body = response.body.trim();
          // catbox.moe returns the direct URL as plain text
          if (body.startsWith('http')) {
            debugPrint('✅ Image uploaded successfully to catbox.moe: $body');
            return {'success': true, 'url': body};
          }
          debugPrint('❌ Unexpected catbox.moe response: $body');
          return {'success': false, 'message': 'Unexpected response format', 'body': body};
        }

        debugPrint('❌ catbox.moe upload failed with status: ${response.statusCode}');
        return {'success': false, 'message': 'Upload failed', 'body': response.body, 'statusCode': response.statusCode};
      }

      // imgbb.com API (requires API key)
      if (host.contains('imgbb.com')) {
        if (apiKey == null || apiKey.isEmpty) {
          return {'success': false, 'message': 'imgbb.com requires an API key. Get one free at https://api.imgbb.com/'};
        }

        final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');
        var request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath('image', file.path));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          try {
            final jsonData = json.decode(response.body);
            if (jsonData['success'] == true && jsonData['data'] != null && jsonData['data']['url'] != null) {
              final url = jsonData['data']['url'] as String;
              debugPrint('✅ Image uploaded successfully to imgbb: $url');
              return {'success': true, 'url': url};
            }
          } catch (e) {
            debugPrint('❌ imgbb parse error: $e');
          }
        }
        return {'success': false, 'message': 'imgbb upload failed', 'body': response.body};
      }

      // 0x0.st and other simple hosts (fallback)
      Uri uri = Uri.parse(host);
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Follow a single redirect if provided
      if (response.statusCode >= 300 && response.statusCode < 400) {
        final location = response.headers['location'];
        if (location != null && location.isNotEmpty) {
          try {
            uri = Uri.parse(location);
            request = http.MultipartRequest('POST', uri);
            request.files.add(await http.MultipartFile.fromPath('file', file.path));
            streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
          } catch (e) {
            debugPrint('❌ Redirect follow failed: $e');
            return {'success': false, 'message': 'Redirect follow failed', 'body': e.toString()};
          }
        }
      }

      if (response.statusCode == 200) {
        final body = response.body.trim();
        // Simple hosts like 0x0.st return a plain URL as text
        if (body.startsWith('http')) {
          debugPrint('✅ Image uploaded successfully: $body');
          return {'success': true, 'url': body};
        }

        // Try parse JSON responses
        try {
          final jsonData = json.decode(body);
          if (jsonData is Map<String, dynamic>) {
            if (jsonData['link'] != null && jsonData['link'] is String) {
              debugPrint('✅ Image uploaded successfully (link): ${jsonData['link']}');
              return {'success': true, 'url': jsonData['link']};
            }
            if (jsonData['url'] != null && jsonData['url'] is String) {
              debugPrint('✅ Image uploaded successfully (url): ${jsonData['url']}');
              return {'success': true, 'url': jsonData['url']};
            }
            if (jsonData['data'] != null && jsonData['data']['link'] != null) {
              debugPrint('✅ Image uploaded successfully (data.link): ${jsonData['data']['link']}');
              return {'success': true, 'url': jsonData['data']['link']};
            }
            if (jsonData['key'] != null && jsonData['key'] is String) {
              debugPrint('✅ Image uploaded successfully (key): ${jsonData['key']}');
              return {'success': true, 'url': jsonData['key']};
            }
          }
        } catch (_) {
          // not JSON, ignore
        }
      }

      debugPrint('❌ Upload failed - Status: ${response.statusCode}, Body: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');
      return {'success': false, 'message': 'Upload failed', 'body': response.body, 'statusCode': response.statusCode};
    } catch (e) {
      debugPrint('❌ PostImagesService.upload exception: $e');
      return {'success': false, 'message': 'Upload error: ${e.toString()}'};
    }
  }

  /// Helper method to try multiple hosts with fallback
  static Future<Map<String, dynamic>> uploadWithFallback(File file, {String? apiKey}) async {
    // Try catbox.moe first (most reliable)
    var result = await upload(file, host: 'https://catbox.moe/user/api.php');
    if (result['success'] == true) return result;

    debugPrint('⚠️ catbox.moe failed, trying alternative...');

    // Try 0x0.st as fallback
    result = await upload(file, host: 'https://0x0.st');
    if (result['success'] == true) return result;

    // If both fail, return the last error
    return result;
  }
}
