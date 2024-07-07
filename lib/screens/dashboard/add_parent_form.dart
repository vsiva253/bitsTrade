import 'package:bits_trade/data/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/modals/parent_data_modal.dart';
import '../../data/modals/publicModals/unified_form_fields.dart';
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
  bool _withApi = true;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    // Initially, fetch form fields for Zerodha (with API)
    _loadFormFields(BrokerType.zerodha, true); 

    // Set selectedBrokerType and _withApi based on widget.parent
    if (widget.parent != null) {
      selectedBrokerType = widget.parent!.broker == 'upstox'
          ? BrokerType.upstox
          : BrokerType.zerodha;
      _withApi = widget.parent!.broker == 'zerodha' && widget.parent!.withApi!;
      _initializeControllers();
    }
  }

  void _loadFormFields(BrokerType brokerType, bool withApi) {
    // Function to load form fields based on brokerType and withApi
    ref.read(formFieldsProvider(brokerType.name)).whenData((response) {
      List<UnifiedFormField> fields;
      if (brokerType == BrokerType.zerodha) {
        final zerodhaResponse = response as ZerodhaFormFieldsResponse;
        fields = withApi
            ? zerodhaResponse.withApi.fields
            : zerodhaResponse.withoutApi.fields;
      } else {
        fields = (response as FormFieldsResponse).fields;
      }

      for (var field in fields) {
        _controllers[field.id] = TextEditingController(
          text: _getInitialValue(field.id) ?? field.initialValue,
        );
      }
      setState(() {}); // Rebuild to reflect changes
    });
  }

  String? _getInitialValue(String fieldId) {
    // Only load initial values if selectedBrokerType is not null
    if (selectedBrokerType != null) {
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
          return widget.parent?.redirectUrl; // Add for 'redirect_url'
        case 'pin':
          return widget.parent?.pin; // Add for 'pin'
        case 'mobile':
          return widget.parent?.mobile; // Add for 'mobile'
        default:
          return null;
      }
    }
    return null; // Return null if selectedBrokerType is null
  }

  void _initializeControllers() {
    // Initialize controllers based on parent data (if available)
    if (widget.parent != null) {
      _controllers['user_id'] = TextEditingController(text: widget.parent!.userId ?? '');
      _controllers['login_password'] = TextEditingController(text: widget.parent!.loginPassword ?? '');
      _controllers['totp_scan_key'] = TextEditingController(text: widget.parent!.totpScanKey ?? '');
      _controllers['api_key'] = TextEditingController(text: widget.parent!.apiKey ?? '');
      _controllers['api_secret'] = TextEditingController(text: widget.parent!.apiSecret ?? '');
      _controllers['name_tag'] = TextEditingController(text: widget.parent!.nameTag ?? '');
      _controllers['redirect_url'] = TextEditingController(text: widget.parent!.redirectUrl ?? ''); // Add 'redirect_url'
      _controllers['pin'] = TextEditingController(text: widget.parent!.pin ?? ''); // Add 'pin'
      _controllers['mobile'] = TextEditingController(text: widget.parent!.mobile ?? ''); // Add 'mobile'
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
                  _withApi = selectedBrokerType == BrokerType.upstox;
                  // Fetch form fields for the new broker type
                  _loadFormFields(newValue!, _withApi); 
                  // Initialize controllers based on parent data if selectedBrokerType changes from editing
                  _initializeControllers(); 
                });
              },
              items: BrokerType.values.map((BrokerType value) {
                return DropdownMenuItem<BrokerType>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            if (selectedBrokerType == null) ...[
              const SizedBox(height: 15),
              const Text('Please select a broker type to load the form fields.'),
            ],
            if (selectedBrokerType != null) ...[
              const SizedBox(height: 15),
              if (selectedBrokerType == BrokerType.zerodha) ...[
                const Text('With API'),
                CheckboxListTile(
                  title: const Text('Use API'),
                  value: _withApi,
                  onChanged: (value) {
                    setState(() {
                      _withApi = value!;
                      // Fetch form fields for Zerodha based on "withApi" state
                      _loadFormFields(BrokerType.zerodha, value); 
                    });
                  },
                ),
              ],
              formFieldsAsyncValue!.when(
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
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          validator: (value) =>
                              field.required && value!.isEmpty ? 'Required' : null,
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
                  onPressed: _saveParent,
                  child: Text(widget.isEditing ? 'Update Parent' : 'Add Parent'),
                ),
              ),
            ],
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
        "with_api": _withApi,
        ..._controllers.map((key, controller) => MapEntry(key, controller.text)),
      };

      // Debug print to check values
      _controllers.forEach((key, controller) {
        print('Key: $key, Value: ${controller.text}');
      });

      if(widget.isEditing){
        await ref.read(parentApiServiceProvider).updateParent(parentData);  

      }else{

          await ref.read(parentApiServiceProvider).addParent(parentData);

      }
      await ref.read(dashboardProvider.notifier).loadParentData();
          

      print(parentData); // Use this data to save to the database (or API)

      // Add other required fields if necessary

      // Perform save operation...

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
}