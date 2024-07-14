import 'package:bits_trade/screens/bottombar.dart';
import 'package:bits_trade/screens/dashboard/child_data_table.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/providers/dashboard_provider.dart';
import 'add_parent_form.dart';
import 'add_child_form.dart';
import 'parent_data_table.dart';
import '../../widgets/dotted_container.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isSubscriptionActive = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool temp = ref.watch(subscriptionStatusProvider);

      if (temp) {
        ref.read(dashboardProvider.notifier).loadParentData();
        ref.read(dashboardProvider.notifier).loadChildData();
      }

      isSubscriptionActive = temp;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      body: isLoading
          ? Column(
              children: [
                ...List.generate(2, (index) => const ParentDataShimmer()),
                ...List.generate(4, (_) => const ChildDataShimmer())
                // ParentDataShimmer()
              ],
            )
          : !isSubscriptionActive
              ? Center(
                  child: Column(
                
                    children: [
                         SizedBox(height:  MediaQuery.of(context).size.height*0.13,),
                      Image.asset(
                        'assets/nodata.png',
                      
                        width: MediaQuery.of(context).size.width*0.7,
                        height:MediaQuery.of(context).size.width*0.7,
                      ),
                         SizedBox(height: 20,),
                      Text('Please Subscribe to Start Copy Trading',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              )
                      ),

                      Container(
                        width: 200,
                        height: 50,
                        margin: EdgeInsets.all(15),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => BottomBar()));
                          },
                          child:const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('View Plans ---',
                                  style: TextStyle(
                                    color: Colors.white
                                  )
                              ),
                              
                              Icon(Icons.arrow_forward_ios_rounded,size: 19,),
                            ],
                          ),
                        ),
                      )
                   
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    if (dashboardState.parentData == null)
                      ...List.generate(2, (index) => const ParentDataShimmer())
                    // ParentDataShimmer()
                    else if (dashboardState.parentData?.data?.id != null)
                      ParentDataTable(
                          parentData: dashboardState.parentData!.data!,
                          dashboardState.childData?.isNotEmpty == true)
                    else
                      _buildAddParentContainer(context),
                    const SizedBox(height: 50),
                    if (dashboardState.parentData == null)
                      ...List.generate(4, (_) => const ChildDataShimmer())
                    else if (dashboardState.parentData?.data?.id != null)
                      dashboardState.childData?.isNotEmpty == true
                          ? ChildDataTable(childData: dashboardState.childData!)
                          : _buildAddChildContainer(context)
                    else
                      Container()
                  ],
                ),
    );
  }

  Widget _buildAddParentContainer(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: DottedBorderContainer(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _showAddParentModal(context),
                        child: const Text(
                          'Add Parent',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/add_button.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),

SizedBox(
  height: 35,
),
          Image.asset(
            'assets/parent.png',
    
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildContainer(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: DottedBorderContainer(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _showAddChildModal(context),
                        child: const Text(
                          'Add Child',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/add_button.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),


        
        ],
      ),
    );
  }

  void _showAddParentModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddParentForm(),
            ),
          ),
        );
      },
    );
  }

  void _showAddChildModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddChildForm(),
            ),
          ),
        );
      },
    );
  }
}

class ParentDataShimmer extends StatelessWidget {
  const ParentDataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.tertiary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(20),
        height: 100,
        child: Column(
          children: List.generate(
            2,
            (index) => Expanded(
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChildDataShimmer extends StatelessWidget {
  const ChildDataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.tertiary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        padding: const EdgeInsets.all(20),
        height: 80,
        child: Column(
          children: List.generate(
            1,
            (index) => Expanded(
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
