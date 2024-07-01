import 'package:bits_trade/data/providers/dashboard_provider.dart';
import 'package:bits_trade/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/modals/child_data_modal.dart';
import '../../utils/text_field_title.dart';

enum BrokerType { zerodha, upstox } // Add other broker types as needed

class AddChildForm extends ConsumerStatefulWidget {
  final ChildData? child;
  final bool isEditing;

  const AddChildForm({super.key, this.child, this.isEditing = false});

  @override
  _AddChildFormState createState() => _AddChildFormState();
}

class _AddChildFormState extends ConsumerState<AddChildForm> {
  final _formKey = GlobalKey<FormState>();
  final _brokerTypeController = TextEditingController();
  late BrokerType selectedBrokerType; // Store selected broker type
  final _loginPasswordController = TextEditingController();
  final _totpScanKeyController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();
  final _multiplierController = TextEditingController();
  final _nameTagController = TextEditingController();
  final _withApiController = TextEditingController();
  bool _withApi = false; // Flag to track "with API" selection

  @override
  void initState() {
    super.initState();
    selectedBrokerType = widget.child?.broker == 'zerodha'
        ? BrokerType.zerodha
        : BrokerType.upstox; // Set initial broker type
    _brokerTypeController.text = selectedBrokerType.name; // Set initial text
    _loginPasswordController.text = widget.child?.loginPassword ?? '';
    _totpScanKeyController.text = widget.child?.totpScanKey ?? '';
    _apiKeyController.text = widget.child?.apiKey ?? '';
    _apiSecretController.text = widget.child?.apiSecret ?? '';
    _multiplierController.text = widget.child?.multiplier ?? '';
    _nameTagController.text = widget.child?.nameTag ?? '';
    _withApi = widget.child?.withApi ?? false; // Set initial "withApi" state
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    widget.isEditing
                        ? 'Update Child Details'
                        : 'Add Child Details',
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
              const SizedBox(height: 10),
              // Broker Type Dropdown
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              // Login Password Field
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
              const SizedBox(height: 15),
              // TOTP Scan Key Field
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

              // API Key Field (Show only if "with API" is selected)
              if (_withApi) ...[
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                // API Secret Field (Show only if "with API" is selected)
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
              const SizedBox(height: 15),
              // Multiplier Field
              const textFieldTitle(title: 'Multiplier'),
              TextFormField(
                controller: _multiplierController,
                decoration: InputDecoration(
                  hintText: 'Multiplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              // Name Tag Field
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
                  onPressed: () => _saveChild(),
                  child: Text(widget.isEditing ? 'Update Child' : 'Add Child'),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChild() async {
    if (_formKey.currentState!.validate()) {
      final childData = {
        'broker': selectedBrokerType.name,
        'login_password': _loginPasswordController.text,
        'totp_scan_key': _totpScanKeyController.text,
        'api_key': _apiKeyController.text,
        'api_secret': _apiSecretController.text,
        'multiplier': _multiplierController.text,
        'user_id': '1', // Hardcoded user id for now, will be dynamic in future
        'name_tag': _nameTagController.text,
        'with_api': _withApi, // Include "with_api" flag
      };
      if (widget.isEditing) {
        // Update existing child
        await ref.read(childApiServiceProvider).updateChild(
            childData, widget.child!.id!);
      } else {
        // Add new child
        await ref.read(childApiServiceProvider).addChild(childData);
      }
      // Trigger a reload of the child data in the DashboardScreen
      await ref.read(dashboardProvider.notifier).loadChildData();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _brokerTypeController.dispose();
    _loginPasswordController.dispose();
    _totpScanKeyController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    _multiplierController.dispose();
    _nameTagController.dispose();
    super.dispose();
  }
}