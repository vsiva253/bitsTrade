import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/modals/parent_data_modal.dart';
import '../../data/modals/publicModals/unified_form_fields.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../data/providers/public_api_provider.dart';

enum BrokerType { zerodha, upstox }

class AddParentForm extends ConsumerStatefulWidget {
  final Data? parent;
  final bool isEditing;

  const AddParentForm({super.key, this.parent, this.isEditing = false});

  @override
  _AddParentFormState createState() => _AddParentFormState();
}

class _AddParentFormState extends ConsumerState<AddParentForm> {
  final _formKey = GlobalKey<FormState>();
  BrokerType? selectedBrokerType;
  final Map<String, TextEditingController> _controllers = {};
  bool _formFieldsLoaded = false;

  @override
  void initState() {
    super.initState();

    // If editing, set the initial broker type and initialize controllers
    if (widget.parent != null) {
      selectedBrokerType = widget.parent!.broker == 'upstox'
          ? BrokerType.upstox
          : BrokerType.zerodha;
      _initializeControllers();
    } else {
      // Initially, fetch form fields for Zerodha
      _loadFormFields(BrokerType.zerodha);
    }
  }

  Future<void> _loadFormFields(BrokerType brokerType) async {
    // Function to load form fields based on brokerType
    final response = await ref.read(formFieldsProvider(brokerType.name).future);

    List<UnifiedFormField> fields;
    if (brokerType == BrokerType.zerodha) {
      final zerodhaResponse = response as ZerodhaFormFieldsResponse;
      fields = zerodhaResponse.withoutApi.fields; // Always use withoutApi for Zerodha
    } else {
      fields = (response as FormFieldsResponse).fields;
    }

    for (var field in fields) {
      _controllers[field.id] = TextEditingController(
        text: _getInitialValue(field.id) ?? field.initialValue,
      );
    }

    setState(() {
      _formFieldsLoaded = true; // Set the flag to true after loading fields
    });
  }

  String? _getInitialValue(String fieldId) {
    if (selectedBrokerType != null && widget.parent != null) {
      switch (fieldId) {
        case 'user_id':
          return widget.parent?.userId;
        case 'login_password':
          return widget.parent?.loginPassword;
        case 'totp_scan_key':
          return widget.parent?.totpScanKey;
        case 'api_key':
          return widget.parent?.apiKey;
        case 'api_secret':
          return widget.parent?.apiSecret;
        case 'name_tag':
          return widget.parent?.nameTag;
        case 'redirect_url':
          return widget.parent?.redirectUrl;
        case 'pin':
          return widget.parent?.pin;
        case 'mobile':
          return widget.parent?.mobile;
        default:
          return null;
      }
    }
    return null;
  }

  void _initializeControllers() {
    if (widget.parent != null) {
      _controllers['user_id'] = TextEditingController(text: widget.parent!.userId ?? '');
      _controllers['login_password'] = TextEditingController(text: widget.parent!.loginPassword ?? '');
      _controllers['totp_scan_key'] = TextEditingController(text: widget.parent!.totpScanKey ?? '');
      _controllers['api_key'] = TextEditingController(text: widget.parent!.apiKey ?? '');
      _controllers['api_secret'] = TextEditingController(text: widget.parent!.apiSecret ?? '');
      _controllers['name_tag'] = TextEditingController(text: widget.parent!.nameTag ?? '');
      _controllers['redirect_url'] = TextEditingController(text: widget.parent!.redirectUrl ?? '');
      _controllers['pin'] = TextEditingController(text: widget.parent!.pin ?? '');
      _controllers['mobile'] = TextEditingController(text: widget.parent!.mobile ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formFieldsAsyncValue = selectedBrokerType != null
        ? ref.watch(formFieldsProvider(selectedBrokerType!.name))
        : null;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  widget.isEditing ? 'Update Parent Details' : 'Add Parent Details',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text('Broker Type'),
            DropdownButtonFormField<BrokerType>(
              value: selectedBrokerType,
              hint: const Text('Select Broker Type'),
              onChanged: (newValue) {
                setState(() {
                  selectedBrokerType = newValue;
                  _loadFormFields(newValue!);
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
            if (selectedBrokerType == BrokerType.zerodha) ...[
              const Text('With API'),
              CheckboxListTile(
                title: const Text('Use API'),
                value: false,
                onChanged: null, // Disable the checkbox
              ),
            ],
            if (formFieldsAsyncValue != null)
              formFieldsAsyncValue.when(
                data: (response) {
                  List<UnifiedFormField> fields;
                  if (selectedBrokerType == BrokerType.zerodha) {
                    final zerodhaResponse = response as ZerodhaFormFieldsResponse;
                    fields = zerodhaResponse.withoutApi.fields;
                  } else {
                    fields = (response as FormFieldsResponse).fields;
                  }
                  return Column(
                    children: fields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _controllers[field.id],
                          decoration: InputDecoration(
                            hintText: field.name,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) => field.required && value!.isEmpty
                              ? 'Required'
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
            Center(
              child: ElevatedButton(
                onPressed: _formFieldsLoaded ? _saveParent : null,
                child: Text(widget.isEditing ? 'Update Parent' : 'Add Parent'),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  void _saveParent() async {
    if (_formKey.currentState!.validate()) {
      final parentData = {
        "broker": selectedBrokerType!.name,
        "with_api": false, // Always set to false
        ..._controllers.map((key, controller) => MapEntry(key, controller.text)),
      };

      if (widget.isEditing) {
        await ref.read(parentApiServiceProvider).updateParent(parentData);
      } else {
        await ref.read(parentApiServiceProvider).addParent(parentData);
      }
      await ref.read(dashboardProvider.notifier).loadParentData();

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}
