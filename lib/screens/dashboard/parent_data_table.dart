import 'package:bits_trade/data/modals/get_funds_model.dart';
import 'package:bits_trade/data/modals/parent_positions_model.dart';
import 'package:bits_trade/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/modals/parent_data_modal.dart';
import '../../data/providers/dashboard_provider.dart';
import 'add_parent_form.dart';
import 'details_screen.dart'; // Import DetailsScreen

final loadingProvider = StateProvider<bool>((ref) => false);

class ParentDataTable extends ConsumerWidget {
  final Data parentData;
  final bool isChildDataExists;

  const ParentDataTable(this.isChildDataExists, {super.key, required this.parentData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('ParentDataTable: ${parentData.toJson()}');
    final isLoading = ref.watch(loadingProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
        
            children: [
              SizedBox(
                width: 140,
                child: TextButton(
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
              ),

SizedBox(
  width: MediaQuery.of(context).size.width -280,
),

              SizedBox(
                  width: 140,
                child: TextButton(
                
                  onPressed: ()async{

                    await ref.read(parentApiServiceProvider).closeAllPositions(parentData.id!);
                 
                  },
                
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      Text('Close All',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
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
                  cells: _buildCells(context, ref, parentData, isLoading),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataCell> _buildCells(BuildContext context, WidgetRef ref, Data parent, bool isLoading) {
    return [
      DataCell(Text(parent.broker ?? 'Siva'), onTap: isLoading ? null : () {
        _navigateToDetailsScreen(context, parent, ref); // Open DetailsScreen
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
                        parent.id!,
                      ); // Update connection status
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.red,
                activeTrackColor: Theme.of(context).primaryColor,
                trackOutlineColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                splashRadius: BorderSide.strokeAlignCenter,
              ),
            ),
            const Spacer()
          ],
        ),
        onTap: isLoading ? null : () {
          _navigateToDetailsScreen(context, parent, ref); // Open DetailsScreen
        },
      ),
      DataCell(Text(parent.funds?.toStringAsFixed(2)?? 0.toString()), onTap: isLoading ? null : () {
        _navigateToDetailsScreen(context, parent, ref); // Open DetailsScreen
      }),
      DataCell(Row(
        children: [
          parent.socket == false
              ? IconButton(
                  onPressed: isLoading ? null : () async {
                    if (parent.loginStatus == false) {
                      showToast(
                        'Please login to start socket',
                      );
                    } else {
                      await ref
                          .read(parentApiServiceProvider)
                          .startSocket(parent.id!);
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.teal,
                  ))
              : IconButton(
                  onPressed: isLoading ? null : () {
                    ref.read(parentApiServiceProvider).stopSocket(parent.id!);
                  },
                  icon: const Icon(
                    Icons.pause_outlined,
                    color: Colors.teal,
                  )),
          
        ],
      )),
    ];
  }

  void _navigateToDetailsScreen(BuildContext context, Data parent, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).state = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    GetFundsModel? fundsModel = await ref.read(parentApiServiceProvider).getFunds(parent.id!);
    ParentPositionsModel? positionsData = await ref.read(parentApiServiceProvider).getPositions(parent.id!);

    Navigator.pop(context); // Remove loading dialog

    ref.read(loadingProvider.notifier).state = false;

    showModalBottomSheet(
      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DetailsScreen(
            fundsModel,
            positionsData,
            parentData: parent,
            isChildDataExists: isChildDataExists,
          ), // Pass parentData to DetailsScreen
        );
      },
    );
  }
}
