import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/modals/parent_data_modal.dart';
import '../../data/providers/dashboard_provider.dart';
import 'add_parent_form.dart';
import 'details_screen.dart'; // Import DetailsScreen

class ParentDataTable extends ConsumerWidget {
  final Data parentData;

  const ParentDataTable({super.key, required this.parentData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('ParentDataTable: ${parentData.toJson()}');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                showModalBottomSheet(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: AddParentForm(
                          parent: parentData,
                          isEditing: true,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    'Edit Parent',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/edit_icon.png',
                    height: 20,
                    fit: BoxFit.cover,
                    width: 20,
                  )
                ],
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Login')),
                DataColumn(label: Text('Funds')),
            
                DataColumn(label: Text('Actions')),
              ],
              rows: [
                DataRow(
                  color: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiary),
                  cells: _buildCells(context, ref, parentData),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataCell> _buildCells(
      BuildContext context, WidgetRef ref, Data parent) {
    return [
      DataCell(Text(parent.broker ?? 'Siva'), onTap: () {
        _navigateToDetailsScreen(context, parent); // Open DetailsScreen
      }),
     DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: parent.loginStatus ?? false,
                onChanged: (bool value) {
                  ref.read(dashboardProvider.notifier).updateParentConnection(
                      parent.id!, ); // Update connection status
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.red,
                activeTrackColor: Theme.of(context).primaryColor,
                trackOutlineColor:  MaterialStateColor.resolveWith((states) => Colors.white),
                splashRadius: BorderSide.strokeAlignCenter,
              ),
            ),
            Spacer()
          ],
        ),
        onTap: () {
          _navigateToDetailsScreen(context, parent); // Open DetailsScreen
        },
      ),
      DataCell(const Text('1000'), onTap: () {
        _navigateToDetailsScreen(context, parent); // Open DetailsScreen
      }),
      
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await ref.read(parentApiServiceProvider).deleteParent(parent.id!);
              ref.read(dashboardProvider.notifier).loadParentData();
            },
          ),
        ],
      )),
    ];
  }

  void _navigateToDetailsScreen(BuildContext context, Data parent) {
    showModalBottomSheet(
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DetailsScreen(childData: null, parentData: parent), // Pass parentData to DetailsScreen
        );
      },
    );
  }
}
