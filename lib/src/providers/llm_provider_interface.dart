// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';

/// An abstract class representing an attachment in a chat message.
///
/// This class serves as a base for different types of attachments
/// (e.g., files, images, links) that can be included in a chat message.
sealed class Attachment {
  /// Creates an [Attachment] with the given name.
  ///
  /// [name] is the name of the attachment, which must not be null.
  const Attachment({required this.name});

  /// The name of the attachment.
  final String name;

  /// Determines the MIME type of a given file.
  ///
  /// This method attempts to determine the MIME type in the following order:
  /// 1. Use the file's reported MIME type if available.
  /// 2. Look up the MIME type based on the file path.
  /// 3. Default to 'application/octet-stream' if the MIME type cannot be
  ///    determined.
  ///
  /// [file] is the XFile object representing the file.
  ///
  /// Returns a String representing the MIME type of the file.
  static String _mimeType(XFile file) =>
      file.mimeType ?? lookupMimeType(file.path) ?? 'application/octet-stream';
}

/// Represents a file attachment in a chat message.
///
/// This class extends [Attachment] and provides specific properties and methods
/// for handling file attachments.
final class FileAttachment extends Attachment {
  /// The MIME type of the file attachment.
  final String mimeType;

  /// The binary content of the file attachment.
  final Uint8List bytes;

  /// Creates a [FileAttachment] with the given name, MIME type, and bytes.
  ///
  /// [name] is the name of the file attachment.
  /// [mimeType] is the MIME type of the file.
  /// [bytes] is the binary content of the file.
  FileAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  /// Creates a [FileAttachment] from an [XFile].
  ///
  /// This factory method asynchronously reads the file content and determines
  /// its MIME type.
  ///
  /// [file] is the XFile object representing the file to be attached.
  ///
  /// Returns a Future that completes with a [FileAttachment] instance.
  static Future<FileAttachment> fromFile(XFile file) async => FileAttachment(
        name: file.name,
        mimeType: Attachment._mimeType(file),
        bytes: await file.readAsBytes(),
      );
}

/// Represents an image attachment in a chat message.
///
/// This class extends [Attachment] and provides specific properties and methods
/// for handling image attachments.
final class ImageAttachment extends Attachment {
  /// The MIME type of the image attachment.
  final String mimeType;

  /// The binary content of the image attachment.
  final Uint8List bytes;

  /// Creates an [ImageAttachment] with the given name, MIME type, and bytes.
  ///
  /// [name] is the name of the image attachment.
  /// [mimeType] is the MIME type of the image.
  /// [bytes] is the binary content of the image.
  ImageAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  /// Creates an [ImageAttachment] from an [XFile].
  ///
  /// This factory method asynchronously reads the file content and determines
  /// its MIME type. It throws an exception if the file is not an image.
  ///
  /// [file] is the XFile object representing the image file to be attached.
  ///
  /// Returns a Future that completes with an [ImageAttachment] instance.
  /// Throws an Exception if the file is not an image.
  static Future<ImageAttachment> fromFile(XFile file) async {
    final mimeType = Attachment._mimeType(file);
    if (!mimeType.toLowerCase().startsWith('image/')) {
      throw Exception('Not an image: $mimeType');
    }

    return ImageAttachment(
      name: file.name,
      mimeType: mimeType,
      bytes: await file.readAsBytes(),
    );
  }
}

/// Represents a link attachment in a chat message.
///
/// This class extends [Attachment] and provides specific properties for
/// handling link attachments.
final class LinkAttachment extends Attachment {
  /// The URL of the link attachment.
  final Uri url;

  /// Creates a [LinkAttachment] with the given name and URL.
  ///
  /// [name] is the name of the link attachment.
  /// [url] is the URI of the link.
  LinkAttachment({required super.name, required this.url});
}

/// An abstract class representing a Language Model (LLM) provider.
///
/// This class defines the interface for interacting with different LLM
/// services. Implementations of this class should provide the logic for
/// generating text responses based on input prompts and optional attachments.
abstract class LlmProvider {
  /// Generates an embedding for a given document.
  ///
  /// This method should be implemented to create a numerical representation
  /// (embedding) of the input document, which can be used for tasks like
  /// semantic search or document comparison.
  ///
  /// [document] is the text content of the document to be embedded.
  ///
  /// Returns a [Future] that resolves to a [List<double>] representing the
  /// document's embedding.
  Future<List<double>> getDocumentEmbedding(String document);

  /// Generates an embedding for a given query.
  ///
  /// This method should be implemented to create a numerical representation
  /// (embedding) of the input query, which can be used for tasks like
  /// semantic search or query-document matching.
  ///
  /// [query] is the text content of the query to be embedded.
  ///
  /// Returns a [Future] that resolves to a [List<double>] representing the
  /// query's embedding.
  Future<List<double>> getQueryEmbedding(String query);

  /// Generates a stream of text based on the given prompt and attachments.
  ///
  /// This method should be implemented to interact with the specific LLM
  /// service and generate text responses.
  ///
  /// [prompt] is the input text to generate a response for. [attachments] is an
  /// optional iterable of [Attachment] objects to include with the prompt.
  /// These can be images, files, or links that provide additional context for
  /// the LLM.
  ///
  /// Returns a [Stream] of [String] containing the generated text chunks. This
  /// allows for streaming responses as they are generated by the LLM.
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });
}

/// A function that generates a stream of text based on a prompt and
/// attachments.
typedef LlmStreamGenerator = Stream<String> Function(
  String prompt, {
  Iterable<Attachment> attachments,
});
