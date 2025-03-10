import 'package:nfc_manager/nfc_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class NfcService {

  // ✅ Function to Send PDF via NFC
  static Future<void> sendPdfViaNfc(BuildContext context, String? pdfPath) async {
    if (pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF not generated yet')),
      );
      return;
    }

    Uint8List pdfBytes = await File(pdfPath).readAsBytes();
    NfcManager nfcManager = NfcManager.instance;

    bool isAvailable = await nfcManager.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NFC is not available')),
      );
      return;
    }

    nfcManager.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('NFC tag is not writable')),
        );
        nfcManager.stopSession();
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createMime('application/pdf', pdfBytes),
      ]);

      try {
        await ndef.write(message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF sent successfully via NFC')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send PDF: $e')),
        );
      } finally {
        nfcManager.stopSession();
      }
    });
  }

  // ✅ Function to Receive PDF via NFC
  static Future<void> receivePdfViaNfc(BuildContext context) async {
    NfcManager nfcManager = NfcManager.instance;

    bool isAvailable = await nfcManager.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NFC is not available')),
      );
      return;
    }

    nfcManager.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null || ndef.cachedMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No PDF data found on NFC tag')),
          );
          nfcManager.stopSession();
          return;
        }

        try {
          // ✅ Fix Uint8List Issue
          Uint8List pdfBytes = Uint8List.fromList(ndef.cachedMessage!.records.first.payload);

          // ✅ Save the received PDF to the device storage
          final output = await getApplicationDocumentsDirectory();
          final filePath = "${output.path}/received_itinerary.pdf";
          await File(filePath).writeAsBytes(pdfBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF received and saved successfully at: $filePath')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to receive PDF: $e')),
          );
        } finally {
          nfcManager.stopSession();
        }
      },
    );
  }
}
