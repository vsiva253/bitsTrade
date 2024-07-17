import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/modals/child_data_modal.dart';
import '../../data/modals/publicModals/unified_form_fields.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../data/providers/public_api_provider.dart';
import '../../utils/text_field_title.dart';

enum BrokerType { zerodha, upstox }

class AddChildForm extends ConsumerStatefulWidget {
  final ChildData? child;
  final bool isEditing;

  const AddChildForm({super.key, this.child, this.isEditing = false});

  @override
  _AddChildFormState createState() => _AddChildFormState();
}

class _AddChildFormState extends ConsumerState<AddChildForm> {
  final _formKey = GlobalKey<FormState>();
  BrokerType? selectedBrokerType;
  bool _withApi = false;  // Default to false
  final Map<String, TextEditingController> _controllers = {};

  // Use a flag to track if the form fields have been loaded
  bool _formFieldsLoaded = false;

  @override
  void initState() {
    super.initState();

    if (widget.child != null) {
      selectedBrokerType = widget.child!.broker == 'upstox'
          ? BrokerType.upstox
          : BrokerType.zerodha;
      _withApi = widget.child!.broker == 'zerodha' && widget.child!.withApi!;
    }

    // Fetch form fields for the initial state
    if (selectedBrokerType != null) {
      _loadFormFields(selectedBrokerType!, _withApi);
    }
  }

  Future<void> _loadFormFields(BrokerType brokerType, bool withApi) async {
    final response = await ref.read(formFieldsProvider2(brokerType.name).future);

    List<UnifiedFormField> fields;
    if (brokerType == BrokerType.zerodha) {
      final zerodhaResponse = response as ZerodhaFormFieldsResponse;
      fields = withApi ? zerodhaResponse.withApi.fields : zerodhaResponse.withoutApi.fields;
    } else {
      fields = (response as FormFieldsResponse).fields;
    }

    for (var field in fields) {
      _controllers[field.id] = TextEditingController(
        text: _getInitialValue(field.id) ?? field.initialValue,
      );
    }

    // Set the flag to indicate that the form fields have been loaded
    setState(() {
      _formFieldsLoaded = true;
    });
  }

  String? _getInitialValue(String fieldId) {
    if (widget.child != null) {
      switch (fieldId) {
        case 'user_id':
          return widget.child?.userId;
        case 'login_password':
          return widget.child?.loginPassword;
        case 'totp_scan_key':
          return widget.child?.totpScanKey;
        case 'api_key':
          return widget.child?.apiKey;
        case 'api_secret':
          return widget.child?.apiSecret;
        case 'name_tag':
          return widget.child?.nameTag;
        case 'redirect_url':
          return widget.child?.redirectUrl;
        case 'pin':
          return widget.child?.pin;
        case 'mobile':
          return widget.child?.mobile;
        case 'multiplier':
          return widget.child?.multiplier;
        default:
          return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formFieldsAsyncValue = selectedBrokerType != null
        ? ref.watch(formFieldsProvider2(selectedBrokerType!.name))
        : null;

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
              const textFieldTitle(title: 'Broker Type'),
              DropdownButtonFormField<BrokerType>(
                value: selectedBrokerType,
                hint: const Text('Select Broker Type'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedBrokerType = newValue!;
                    // Always set _withApi to false for Zerodha
                    _withApi = false;
                    // Fetch form fields for the new broker type
                    _loadFormFields(newValue, _withApi);
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
                const textFieldTitle(title: 'With API'),
                CheckboxListTile(
                  title: const Text('Use API'),
                  value: _withApi,
                  onChanged: null, // Disable the checkbox
                ),
              ],
              if (formFieldsAsyncValue != null)
                formFieldsAsyncValue.when(
                  data: (response) {
                    List<UnifiedFormField> fields;
                    if (selectedBrokerType == BrokerType.zerodha) {
                      final zerodhaResponse = response as ZerodhaFormFieldsResponse;
                      fields = _withApi
                          ? zerodhaResponse.withApi.fields
                          : zerodhaResponse.withoutApi.fields;
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
                            validator: (value) {
                               if (field.required && (value == null || value.isEmpty)) {
                              return 'Required';
                            }
                            if (field.pattern != null && !RegExp(field.pattern!).hasMatch(value!)) {
                              return 'Invalid format';
                            }
                            return null;
                            }
                                
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => Container(
                  margin:const EdgeInsets.symmetric(vertical: 70),
                  child:const Center(child:  CircularProgressIndicator())),
                  error: (error, stack) => Text('Error: $error'),
                ),
              Center(
                child: ElevatedButton(
                  onPressed: _formFieldsLoaded ? _saveChild : null,
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
        "broker": selectedBrokerType!.name,
        "with_api": _withApi,
        // Assign values from controllers to childData
        ..._controllers.map((key, controller) => MapEntry(key, controller.text)),
      };

      if (widget.isEditing) {
        await ref.read(childApiServiceProvider).updateChild(childData, widget.child!.id!);
      } else {
        await ref.read(childApiServiceProvider).addChild(childData);
      }
      await ref.read(dashboardProvider.notifier).loadChildData();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}
