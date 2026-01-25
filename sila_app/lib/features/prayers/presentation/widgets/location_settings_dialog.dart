import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/services/location_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:geocoding/geocoding.dart';

class LocationSettingsDialog extends StatefulWidget {
  const LocationSettingsDialog({super.key});

  @override
  State<LocationSettingsDialog> createState() => _LocationSettingsDialogState();
}

class _LocationSettingsDialogState extends State<LocationSettingsDialog> {
  final _prefs = PrefsService();
  bool _isAuto = true;
  final _cityController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isAuto = await _prefs.isAutoLocation();
    final stored = await _prefs.getStoredLocation();
    if (mounted) {
      setState(() {
        _isAuto = isAuto;
        if (stored != null) {
          _cityController.text = stored['city'];
        }
      });
    }
  }

  Future<void> _saveManual() async {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final loc = await locationFromAddress(cityName);
      if (loc.isNotEmpty) {
        await _prefs.saveManualLocation(loc.first.latitude, loc.first.longitude, cityName);
        if (mounted) Navigator.pop(context, true); // Return true to refresh
      } else {
        // Show error (SnackBar not ideal in dialog, usually validation text)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("City not found")));
      }
    } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleAuto(bool value) async {
    setState(() => _isAuto = value);
    if (value) {
      await _prefs.setAutoLocation(true);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("location_settings".tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text("auto_location".tr()),
            value: _isAuto,
            onChanged: _toggleAuto,
          ),
          if (!_isAuto) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "enter_city".tr(),
                border: const OutlineInputBorder(),
                suffixIcon: _isLoading ? const Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)) : null,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveManual,
              child: Text("save".tr()),
            ),
          ],
        ],
      ),
    );
  }
}
