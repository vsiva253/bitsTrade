import 'package:bits_trade/data/modals/child_data_modal.dart';
import 'package:bits_trade/data/modals/parent_data_modal.dart';
import 'package:bits_trade/data/providers/dashboard_provider.dart';
import 'package:bits_trade/screens/dashboard/dashboard_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final ChildData? childData;
  final Data? parentData;

  const DetailsScreen({Key? key, this.childData, this.parentData}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: ()async {
              setState(() {
                    loading=true;
              });
                widget.childData==null?await ref.read(parentApiServiceProvider).deleteParent(widget.parentData!.id!)  :await ref.read(childApiServiceProvider).deleteChild(widget.childData!.id!);
                   widget.childData==null?await ref.read(dashboardProvider.notifier).loadParentData() :await ref.read(dashboardProvider.notifier).loadChildData();
                  
                    setState(() {
                      loading=false;
                    });
                  Navigator.pop(context);
                },
                child:loading? Text('Wait..'): Text('Delete'),
              ),
            ),
            Container(
              width: 130,
              child: ElevatedButton(onPressed: () {

                  Navigator.pop(context);
              }, child: Text('Close')),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        leading: const Icon(
          Icons.abc,
          color: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.childData != null ? '${widget.childData?.nameTag}' : '${widget.parentData?.nameTag}',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  detailsContainer(
                    context,
                    Column(
                      children: [
                        textWidget(context, 'Broker', '${widget.childData?.broker}', '${widget.parentData?.broker}'),
                        textWidget(context, 'Broker Id', 'siva sai reddy', '${widget.parentData?.broker}'),
                        textWidget(context, 'Login', 'Connected', '${widget.parentData?.broker}'),
                        textWidget(context, 'Status', 'Active', '${widget.parentData?.broker}'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  detailsContainer(
                    context,
                    Column(
                      children: [
                        textWidget(context, 'Total Balance', '1,00,0000', '${widget.parentData?.broker}'),
                        textWidget(context, 'User Margin', '5000000', '${widget.parentData?.broker}'),
                        textWidget(context, 'Realized P&L', '20000', '${widget.parentData?.broker}'),
                        textWidget(context, 'Available', '27000', '${widget.parentData?.broker}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Orders',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 15,
              ),
              const OrderSummaryCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(BuildContext context, String type, String child, String parent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$type -',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            widget.childData != null ? child : parent,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Expanded detailsContainer(BuildContext context, dynamic child) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
            width: 0.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
    
   decoration: BoxDecoration(
       color: Theme.of(context).colorScheme.tertiary,
       borderRadius: BorderRadius.circular(4),
       boxShadow: [
         BoxShadow(
           color: Colors.grey.withOpacity(0.1), 
           spreadRadius: 0,
           blurRadius: 4,
           offset: const Offset(0, 4), // changes position of shadow
         ),]
   ), // Light blue color
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty. 150',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Avg. 355.00',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bank Nifty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Order type: Normal',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50000CE',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                'LTP 383.00',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
