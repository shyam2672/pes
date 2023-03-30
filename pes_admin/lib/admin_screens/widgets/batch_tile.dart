import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/slot_button.dart';
import 'package:pes_admin/admin_screens/widgets/tile_heading.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/batch_edit_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/delete_batch_cubit.dart';
import 'package:pes_admin/cubit/batch_edit_cubit.dart';
import 'package:pes_admin/data/models/batches.dart';

import '../../data/models/user.dart';

class BatchTile extends StatelessWidget {
  final Batch batch;
  final bool myBatch;
  TextEditingController _remarks = TextEditingController();
  User user = User.empty(token: "");

  BatchTile({Key? key, required this.batch, required this.myBatch})
      : super(key: key);

  Widget collapsedTile(bool isCollapsed, context) {
    return Container(
      // width: 250,
      height: 80,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.only(top: 5, bottom: isCollapsed ? 5 : 0),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 247, 98, 57),
              Color.fromARGB(255, 247, 57, 215),
            ]),
            // color: Color.fromARGB(255, 249, 66, 224),
            width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Row(
            children: [
              Spacer(),
              TileHeading(
                heading: "BATCH",
                text: batch.batch,
                noOfSiblings: 3,
              ),
              Spacer(),
              TileHeading(
                heading: "Classes taught",
                text: batch.remarks,
                noOfSiblings: 3,
              ),
              Spacer(),
              //_tileButtons(context),
              SlotButton(
                text: 'Syllabus',
                onPressed: () {
                  Navigator.pushNamed(context, SYLLABUS_SCREEN,
                      arguments: {'batch': batch.batch});
                },
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  BatchDeleteCubit? batchDeleteCubit;
  bool selected = false;
  BatchEditCubit? batchEditCubit;

  @override
  Widget build(BuildContext context) {
    print("Home Refreshed");
    user = BlocProvider.of<LoginCubit>(context).user;
    //attendanceCubit = BlocProvider.of<AttendanceCubit>(context);
    batchDeleteCubit = BlocProvider.of<BatchDeleteCubit>(context);
    batchEditCubit = BlocProvider.of<BatchEditCubit>(context);

    return BlocBuilder<BatchDeleteCubit, BatchDeleteState>(
      builder: (context, state) {
        if (!myBatch && state is BatchSelectionActive) {
          return Stack(
            children: [
              collapsedTile(true, context),
              BatchCheckBox(batch: batch),
            ],
          );
        } else {
          return BlocBuilder<BatchEditCubit, BatchEditState>(
            builder: (context, state) {
              if (state is BatchEditSelect) {
                return InkWell(
                  onTap: () {
                    batchEditCubit!.editBatch(batch);
                    Navigator.pushNamed(context, ADD_BATCH, arguments: {
                      'isBeingEdited': true,
                    });
                  },
                  child: collapsedTile(true, context),
                );
              } else {
                return //ExpandableNotifier(child:
                    Container(
                  //collapsed: ExpandableButton(
                  child: collapsedTile(true, context),
                );
                /*expanded: Stack(
                      children: [
                        moreInfo(context),
                        ExpandableButton(
                          child: collapsedTile(false),
                        ),
                      ],
                    )*/
                //),
                //);
              }
            },
          );
        }
      },
    );
  }

  _tileButtons(context) {
    return Row(
      children: [
        Spacer(),
        SlotButton(
          onPressed: () {
            Navigator.pushNamed(context, SYLLABUS_SCREEN,
                arguments: {'batch': batch.batch});
          },
          text: "Syllabus",
        ),
        Spacer(),
      ],
    );
  }
}

class BatchCheckBox extends StatefulWidget {
  bool value = false;
  final Batch batch;

  BatchCheckBox({Key? key, required this.batch}) : super(key: key);

  @override
  State<BatchCheckBox> createState() => _BatchCheckBoxState();
}

class _BatchCheckBoxState extends State<BatchCheckBox> {
  DeleteState(context) {
    if (!widget.value &&
        !batchDeleteCubit!.selectedBatches.contains(widget.batch.batch)) {
      //If Checked
      batchDeleteCubit!.selectedBatches.add(widget.batch.batch);
    } else if (widget.value &&
        batchDeleteCubit!.selectedBatches.contains(widget.batch.batch)) {
      batchDeleteCubit!.selectedBatches.removeAt(
          batchDeleteCubit!.selectedBatches.indexOf(widget.batch.batch));
    }
    print(batchDeleteCubit!.selectedBatches);
    setState(() {
      widget.value =
          batchDeleteCubit!.selectedBatches.contains(widget.batch.batch);
    });
  }

  BatchDeleteCubit? batchDeleteCubit;
  @override
  Widget build(BuildContext context) {
    batchDeleteCubit = BlocProvider.of<BatchDeleteCubit>(context);
    widget.value =
        batchDeleteCubit!.selectedBatches.contains(widget.batch.batch);
    return InkWell(
      onTap: () {
        DeleteState(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // width: 250,
        height: 100,
        padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: !widget.value
              ? Color(0xffE9EDF1).withOpacity(0.0)
              : Colors.grey.withOpacity(0.1),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Checkbox(
            value: widget.value,
            onChanged: (bool) => {DeleteState(context)},
          ),
        ),
      ),
    );
  }
}
