class UnifiedFormField {
  final String id;
  final String name;
  final String type;
  final bool required;
  final String? initialValue;
  final String? pattern;

  UnifiedFormField({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    this.initialValue,
    this.pattern,
  });

  factory UnifiedFormField.fromJson(Map<String, dynamic> json) {
    return UnifiedFormField(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      initialValue: json['initial_value'] as String?,
      pattern: json['pattern'] as String?,
    );
  }
}

class FormFieldsResponse {
  final List<UnifiedFormField> fields;
  final List<String> notes;

  FormFieldsResponse({
    required this.fields,
    required this.notes,
  });

  factory FormFieldsResponse.fromJson(Map<String, dynamic> json) {
    return FormFieldsResponse(
      fields: (json['fields'] as List<dynamic>)
          .map((field) => UnifiedFormField.fromJson(field as Map<String, dynamic>))
          .toList(),
      notes: (json['note'] as List<dynamic>).cast<String>(),
    );
  }
}

class ZerodhaFormFieldsResponse {
  final FormFieldsResponse withApi;
  final FormFieldsResponse withoutApi;

  ZerodhaFormFieldsResponse({
    required this.withApi,
    required this.withoutApi,
  });

  factory ZerodhaFormFieldsResponse.fromJson(Map<String, dynamic> json) {
    return ZerodhaFormFieldsResponse(
      withApi: FormFieldsResponse.fromJson(json['with_api']),
      withoutApi: FormFieldsResponse.fromJson(json['without_api']),
    );
  }
}
