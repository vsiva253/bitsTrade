import 'package:bits_trade/data/modals/child_data_modal.dart';
import 'package:bits_trade/data/modals/get_funds_model.dart';
import 'package:bits_trade/data/modals/parent_data_modal.dart';
import 'package:bits_trade/data/modals/parent_positions_model.dart';
import 'package:bits_trade/data/providers/dashboard_provider.dart';
import 'package:bits_trade/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  GetFundsModel? fundsData;
  ParentPositionsModel? positionData;
  final bool? isChildDataExists;
  final ChildData? childData;
  final Data? parentData;

  DetailsScreen(
    this.fundsData,
    this.positionData, {
    super.key,
    this.isChildDataExists,
    this.childData,
    this.parentData,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  bool isPositionsSelected = true;
  bool loading = false;

  refreshData() async {
    if (widget.childData == null) {
      widget.positionData = await ref
          .read(parentApiServiceProvider)
          .getPositions(widget.parentData!.id!);
      setState(() {});
    } else {
      widget.positionData = await ref
          .read(childApiServiceProvider)
          .getPositions(widget.childData!.id!);
      setState(() {});
    }
  }

  refreshFunds() async {
    if (widget.childData == null) {
      widget.fundsData = await ref
          .read(parentApiServiceProvider)
          .getFunds(widget.parentData!.id!);
      setState(() {});
    } else {
      widget.fundsData = await ref
          .read(childApiServiceProvider)
          .getFunds(widget.childData!.id!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 60, left: 20, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (widget.childData == null) {
                    if (widget.isChildDataExists == true) {
                      showToast(
                        'Please delete child data first',
                      );
                    } else {
                      await ref
                          .read(parentApiServiceProvider)
                          .deleteParent(widget.parentData!.id!);
                    }
                  } else {
                    await ref
                        .read(childApiServiceProvider)
                        .deleteChild(widget.childData!.id!);
                  }
                  widget.childData == null
                      ? await ref
                          .read(dashboardProvider.notifier)
                          .loadParentData()
                      : await ref
                          .read(dashboardProvider.notifier)
                          .loadChildData();

                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                },
                child: loading ? const Text('Wait..') : const Text('Delete'),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
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
                widget.childData != null
                    ? '${widget.childData?.nameTag??''}'
                    : '${widget.parentData?.nameTag??''}',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                // padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    detailsContainer(
                      context,
                      Column(
                        children: [
                          textWidget(context, 'Total Balance',
                              '${widget.fundsData?.data?.totalBalance?? '-'}'),
                          textWidget(context, 'Realized P&L',
                              '${widget.fundsData?.data?.realizedPl?? '-'}'),
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
                          textWidget(context, 'User Margin',
                              '${widget.fundsData?.data?.usedMargin?? '-'}'),
                          textWidget(context, 'Available',
                              '${widget.fundsData?.data?.availableMargin??'-'}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                // borderRadius: BorderRadius.circular(4),
                                border: BorderDirectional(
                                    end: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 0.5))),
                            child: Center(
                              child: Text(
                                'Positions',
                                style: TextStyle(
                                    color: isPositionsSelected
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: !isPositionsSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                // borderRadius: BorderRadius.circular(4),
                                border: BorderDirectional(
                                    start: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 0.5))),
                            child: Center(
                              child: Text(
                                'Orders',
                                style: TextStyle(
                                    color: isPositionsSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                               
                   
                        
                      ],
                    ),
                  ),
                   InkWell(
                  onTap: ()async {

                    refreshData();
                  },

                  child: Container(
                  
                 decoration: BoxDecoration(
                     color: Colors.blue,
                     borderRadius: BorderRadius.circular(4)
                 ),
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      
                      children: [
                        Icon(
                          Icons.refresh_rounded,color: Colors.white,
                        ),
                        SizedBox(width: 5,),
                         Text('refresh',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                  ),
                )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
         widget.positionData != null &&
                        widget.positionData!.data != null &&
                        widget.positionData!.data!.positions!.isNotEmpty
                    ?      Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total P&L : ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )),
                      Text(
                        '${widget.positionData?.data?.total ?? 0}',
                        style: TextStyle(
                          color: widget.positionData?.data?.total !=null && widget.positionData!.data!.total! > 0
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ):Container(),
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                child: widget.positionData != null &&
                        widget.positionData!.data != null &&
                        widget.positionData!.data!.positions!.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          Position? data =
                              widget.positionData?.data?.positions?[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: OrderSummaryCard(
                              name: data?.instrument ?? '',
                              orderType: data?.orderType ?? '',
                              quantity: data?.quantity ?? 0,
                              avg: data?.avgPrice ?? 0,
                              pnl: data?.pnl ?? 0,
                              ltp: data?.ltp ?? 0,
                            ),
                          );
                        },
                        itemCount:
                            widget.positionData?.data?.positions?.length ?? 0,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      )
                    :  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Center(child: Text('No positions available'))), // Display a message if positions are empty or null
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(BuildContext context, String type, String value,
      {bool optionalBool = true}) {
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
            value,
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
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.onSurface,
          //   width: 0.5,
          // ),
        ),
        child: child,
      ),
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  final String name;
  final String orderType;
  final int quantity;
  final double avg;
  final double pnl;
  final double ltp;

  const OrderSummaryCard(
      {super.key,
      required this.name,
      required this.orderType,
      required this.quantity,
      required this.avg,
      required this.pnl,
      required this.ltp});

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
            ),
          ]), // Light blue color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Qty. '),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      color: quantity > 0
                          ? Colors.green
                          : quantity == 0
                              ? Colors.black
                              : Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Avg. $avg',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$pnl',
                style: TextStyle(
                  color: pnl > 0 ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Type: $orderType',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'LTP $ltp',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
