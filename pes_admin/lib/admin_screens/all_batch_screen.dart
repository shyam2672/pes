import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/all_batches_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/delete_batch_cubit.dart';
import 'package:pes_admin/cubit/batch_edit_cubit.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pes_admin/admin_screens/widgets/batch_tile.dart';

class AllBatches extends StatefulWidget {
  var bottomSheetController;

  @override
  State<AllBatches> createState() => _State();
}

class _State extends State<AllBatches> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _showBottomNotification(BuildContext context, message) {
    widget.bottomSheetController = showModalBottomSheet(
        routeSettings: RouteSettings(name: "/bottom-sheet"),
        useRootNavigator: true,
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(padding: EdgeInsets.all(10), child: Text(message));
        });
    // widget.bottomSheetController.closed.then((value) {
    //   print(value);
    // });
  }

  Widget topbar() {
    if (batchDeleteCubit!.state is BatchSelectionActive) {
      Navigator.pop(context);
      return AvailabilityButtons(
        onTap: () {
          batchDeleteCubit!.selectedBatches = [];
          batchDeleteCubit!.emit(BatchDeleteInitial());
        },
        child: Center(
          child: BlocBuilder<BatchDeleteCubit, BatchDeleteState>(
            builder: (context, state) {
              return Text(
                "Cancel",
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      );
    } else {
      return BlocBuilder<BatchEditCubit, BatchEditState>(
        builder: (context, state) {
          if (batchEditCubit!.state is BatchEditSelect) {
            // Navigator.pop(context);
            return AvailabilityButtons(
              onTap: () {
                batchEditCubit!.selectBatch();
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            return PopupMenuButton(
                // padding: EdgeInsets.zero,
                onCanceled: () {
              print('Popupmenu cancelled!');
            }, itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ADD_BATCH,
                            arguments: {"isBeingEdited": false});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.add,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Add Batch",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        batchEditCubit!.selectBatch();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.edit,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Edit Batch",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        batchDeleteCubit!.selectBatchDelete();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 30)),
                      icon: Icon(
                        Icons.delete,
                        color: appBarColor,
                      ),
                      label: Text(
                        "Delete Batches",
                        style: TextStyle(color: appBarColor),
                      )),
                ),
              ];
            });
          }
        },
      );
    }
  }

  AllBatchesCubit? batchesCubit;
  BatchDeleteCubit? batchDeleteCubit;
  BatchEditCubit? batchEditCubit;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    batchesCubit = BlocProvider.of<AllBatchesCubit>(context);
    batchesCubit!.loadAllBatches(user.token);
    batchDeleteCubit = BlocProvider.of<BatchDeleteCubit>(context);
    batchEditCubit = BlocProvider.of<BatchEditCubit>(context);

    return BlocConsumer<BatchDeleteCubit, BatchDeleteState>(
      listenWhen: ((previous, current) {
        return current is BatchDelApplicationSubmitted ||
            current is BatchDelApplicationNotSubmitted ||
            current is BatchDeleteLoading;
      }),
      listener: (context, state) {
        Navigator.popUntil(
            context, (route) => Navigator.defaultRouteName != ALL_BATCHES);
        if (state is BatchDelApplicationSubmitted) {
          _showBottomNotification(context, "Batch Deleted");
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => batchesCubit!.allBatches = []);
          });
        } else if (state is BatchDelApplicationNotSubmitted) {
          _showBottomNotification(context, state.message);
          Timer(Duration(seconds: 3), () {
            // Navigator.popUntil(context, (route) => !route.hasActiveRouteBelow);
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() => batchesCubit!.allBatches = []);
          });
        } else if (state is BatchDeleteLoading) {
          _showBottomNotification(context, "Processing Delete Request...");
        }
      },
      buildWhen: (previous, current) {
        return (previous is BatchSelectionActive ||
            current is BatchSelectionActive);
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          //drawer: SideDrawer(),
          appBar: AppBar(
            actions: [topbar()],
            elevation: 0,
            // centerTitle: true,
            title: const Text(
              "All Batches",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: appBarColor,
          ),
          body: SmartRefresher(
            enablePullDown: true,
            header: WaterDropMaterialHeader(
              backgroundColor: appBarColor
                  .withOpacity(0.8), //Theme.of(context).primaryColor,
            ),

            controller: _pageRefreshController,
            onRefresh: () {
              if (batchDeleteCubit!.state is! BatchSelectionActive) {
                setState(() {
                  batchesCubit!.allBatches = [];
                });
              }
              _pageRefreshController.refreshCompleted();
            },
            // onLoading: _onLoading,
            child: Container(
              color: appBarColor,
              child: Container(
                padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 18, 18, 18),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          BlocBuilder<BatchDeleteCubit, BatchDeleteState>(
                            builder: (context, state) {
                              if (state is BatchSelectionActive) {
                                return AvailabilityButtons(
                                  onTap: () {
                                    batchDeleteCubit!
                                        .batchDeleteApplication(user.token);
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else {
                                return BlocBuilder<BatchEditCubit,
                                    BatchEditState>(
                                  builder: (context, state) {
                                    if (state is BatchEditSelect) {
                                      return Column(
                                        children: [
                                          Text(
                                            "Select Batch to Edit",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          Text(
                                            getWeek(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color:
                          Color.fromARGB(255, 233, 231, 231).withOpacity(0.5),
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: EdgeInsets.only(top: 0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                "Batch",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 138, 136, 136)),
                              ),
                              Spacer(),
                              Spacer(),
                              Text(
                                "Classes taught",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 138, 136, 136)),
                              ),
                              Spacer(),

                              Text(
                                "\t\t\t                ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 138, 136, 136)),
                              ),
                              Spacer(),
                              //_tileButtons(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: BlocBuilder<AllBatchesCubit, AllBatchesState>(
                          builder: (context, state) {
                            print(state);
                            if (state is AllBatchesLoaded) {
                              return SmartRefresher(
                                enablePullDown: true,
                                header: WaterDropMaterialHeader(
                                  backgroundColor: appBarColor.withOpacity(
                                      0.8), //Theme.of(context).primaryColor,
                                ),
                                controller: _listRefreshController,
                                onRefresh: () {
                                  if (batchDeleteCubit!.state
                                      is! BatchSelectionActive) {
                                    setState(() {
                                      batchesCubit!.allBatches = [];
                                    });
                                  }
                                  _listRefreshController.refreshCompleted();
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(4),
                                  children: batchesCubit!.allBatches
                                      .map((batch) => BatchTile(
                                            batch: batch,
                                            myBatch: false,
                                          ))
                                      .toList(),
                                ),
                              );
                            } else if (state is AllBatchesLoadFailure) {
                              return Center(
                                  child: Text(
                                state.error,
                                style: TextStyle(fontSize: 20),
                              ));
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> months = [
    "January",
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String getWeek() {
    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(days: now.weekday % 7));
    DateTime end = start.add(const Duration(days: 6));

    return ("${start.day} ${months[start.month - 1].substring(0, 3) + "(Sun)"} - ${end.day} ${months[end.month - 1].substring(0, 3) + "(Sat)"}");
  }
}

class AvailabilityButtons extends StatelessWidget {
  final Widget child;
  final Function()? onTap;

  const AvailabilityButtons(
      {Key? key, required this.onTap, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 35,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 247, 57, 215),
          Color.fromARGB(255, 247, 98, 57)
        ]),
        // color: const Color(0xff274D76),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromARGB(255, 247, 57, 215),
          width: 1,
        ),
      ),
      child: InkWell(child: child, onTap: onTap),
    );
  }
}
