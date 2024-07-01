import 'package:bits_trade/screens/dashboard/details_screen.dart';
import 'package:flutter/material.dart';
import '../../data/modals/child_data_modal.dart';
import 'add_child_form.dart';

class ChildDataTable extends StatelessWidget {
  final List<ChildData> childData;

  const ChildDataTable({super.key, required this.childData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          // Add Child Button
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
                shape:
                    const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const SingleChildScrollView(
                      child: AddChildForm(
                        isEditing: false,
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                Text(
                  'Add Child',
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
                ),
              ],
            ),
          ),
          // DataTable for Children
          DataTable(
            headingRowColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            columns: const [
              DataColumn(label: Text('S.no')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Login')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Multiplier')),
              DataColumn(label: Text('Play/Pause')),
              DataColumn(label: Text('Actions')), // Added Actions column
            ],
            rows: childData
                .map((child) => DataRow(
                      color: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      cells: _buildCells(context, child),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<DataCell> _buildCells(BuildContext context, ChildData child) {
    return [
      DataCell(Text(childData.indexOf(child).toString())),
      DataCell(Text(child.broker ?? ''), onTap: () {
        _navigateToDetailsScreen(context, child);
      }),
      DataCell(const Text('Connected'), onTap: () {
        _navigateToDetailsScreen(context, child);
      }),
      DataCell(const Text('Active'), onTap: () {
        _navigateToDetailsScreen(context, child);
      }),
      DataCell(Text(child.multiplier ?? ''), onTap: () {
        _navigateToDetailsScreen(context, child);
      }),
      DataCell(const Text('Play/Pause'), onTap: () {
        _navigateToDetailsScreen(context, child);
      }),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditChildBottomSheet(context, child); // Show Edit Child form
              },
            ),
         
          ],
        ),
      ), // Actions column
    ];
  }

  void _navigateToDetailsScreen(BuildContext context, ChildData child) {
    showModalBottomSheet(
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DetailsScreen(childData: child),
        );
      },
    );
  }

  void _showEditChildBottomSheet(BuildContext context, ChildData child) {
    showModalBottomSheet(
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: AddChildForm(
              child: child, // Pass the child data for editing
              isEditing: true,
            ),
          ),
        );
      },
    );
  }}

