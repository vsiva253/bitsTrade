import 'package:bits_trade/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/modals/parent_data_modal.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../utils/text_field_title.dart';

enum BrokerType { zerodha, upstox } // Add other broker types as needed

class AddParentForm extends ConsumerStatefulWidget {
  final Data? parent;
  final bool isEditing;

  const AddParentForm({super.key, this.parent, this.isEditing = false});

  @override
  _AddParentFormState createState() => _AddParentFormState();
}

class _AddParentFormState extends ConsumerState<AddParentForm> {
  final _formKey = GlobalKey<FormState>();
  final _brokerTypeController = TextEditingController();
  late BrokerType selectedBrokerType; // Store selected broker type
  final _userIdController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _totpScanKeyController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();
  final _nameTagController = TextEditingController();
  final _withApiController = TextEditingController();
  bool _withApi = false; // Flag to track "with API" selection

  @override
  void initState() {
    super.initState();
    selectedBrokerType = widget.parent?.broker == 'zerodha'
        ? BrokerType.zerodha
        : BrokerType.upstox; // Set initial broker type
    _brokerTypeController.text = selectedBrokerType.name; // Set initial text
    _userIdController.text = widget.parent?.userId ?? '';
    _loginPasswordController.text = widget.parent?.loginPassword ?? '';
    _totpScanKeyController.text = widget.parent?.totpScanKey ?? '';
    _apiKeyController.text = widget.parent?.apiKey ?? '';
    _apiSecretController.text = widget.parent?.apiSecret ?? '';
    _nameTagController.text = widget.parent?.nameTag ?? '';
    _withApi = widget.parent?.withApi ?? false; // Set initial "withApi" state
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  widget.isEditing
                      ? 'Update Parent Details'
                      : 'Add Parent Details',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),
            const textFieldTitle(title: 'Broker Type'),
            DropdownButtonFormField<BrokerType>(
              value: selectedBrokerType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedBrokerType = newValue!;
                  _brokerTypeController.text = newValue.name;
                });
              },
              items: BrokerType.values.map((BrokerType value) {
                return DropdownMenuItem<BrokerType>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            // With API Checkbox
            const textFieldTitle(title: 'With API'),
            CheckboxListTile(
              title: const Text('Use API'),
              value: _withApi,
              onChanged: (value) {
                setState(() {
                  _withApi = value!;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const textFieldTitle(title: 'User ID'),
            TextFormField(
              controller: _userIdController,
              decoration: InputDecoration(
                hintText: 'User ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(
              height: 15,
            ),
            const textFieldTitle(title: 'Login Password'),

            TextFormField(
              controller: _loginPasswordController,
              decoration: InputDecoration(
                hintText: 'Login Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(
              height: 15,
            ),
            const textFieldTitle(title: 'TOTP Scan Key'),

            TextFormField(
              controller: _totpScanKeyController,
              decoration: InputDecoration(
                hintText: 'TOTP Scan Key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            if (_withApi) ...[
              const SizedBox(
                height: 15,
              ),
              const textFieldTitle(title: 'API Key'),
              TextFormField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  hintText: 'API Key',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(
                height: 15,
              ),
              const textFieldTitle(title: 'API Secret'),
              TextFormField(
                controller: _apiSecretController,
                decoration: InputDecoration(
                  hintText: 'API Secret',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            const textFieldTitle(title: 'Name Tag'),
            TextFormField(
              controller: _nameTagController,
              decoration: InputDecoration(
                hintText: 'Name Tag',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveParent(),
                child: Text(widget.isEditing ? 'Update Parent' : 'Add Parent'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  void _saveParent() async {
    if (_formKey.currentState!.validate()) {
      final parentData = {
        'broker': selectedBrokerType.name,
        'user_id': _userIdController.text,
        'login_password': _loginPasswordController.text,
        'totp_scan_key': _totpScanKeyController.text,
        'api_key': _apiKeyController.text,
        'api_secret': _apiSecretController.text,
        'name_tag': _nameTagController.text,
        'with_api': _withApi, // Include "with_api" flag
      };
      if (widget.isEditing) {
        await ref.read(parentApiServiceProvider).updateParent(parentData);
        //update state

      } else {
        await ref.read(parentApiServiceProvider).addParent(parentData);

      }
      await ref.read(dashboardProvider.notifier).loadParentData();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _brokerTypeController.dispose();
    _userIdController.dispose();
    _loginPasswordController.dispose();
    _totpScanKeyController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    _nameTagController.dispose();
    super.dispose();
  }
}