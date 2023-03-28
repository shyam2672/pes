import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/admin_screens/widgets/slot_tile.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/volunteer_slots_cubit.dart';
import 'package:pes_admin/data/models/slots.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IndividualSlotsScreen extends StatefulWidget {
  String pes_id, name;
  IndividualSlotsScreen({required this.pes_id, required this.name});
  @override
  _IndividualSlotsScreenState createState() => _IndividualSlotsScreenState();
}

class _IndividualSlotsScreenState extends State<IndividualSlotsScreen> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  VolunteerSlotsCubit? volunteerSlotsCubit;

  @override
  void initState() {
    super.initState();
  }

  List<Slot> currentSlots() {
    List<Slot> current_slots = [];
    for (Slot s in volunteerSlotsCubit!.allSlots) {
      for (int i in volunteerSlotsCubit!.current) {
        if (s.slotId == i.toString()) {
          current_slots.add(s);
          break;
        }
      }
    }
    return current_slots;
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    volunteerSlotsCubit = BlocProvider.of<VolunteerSlotsCubit>(context);
    volunteerSlotsCubit!.allSlots = [];
    volunteerSlotsCubit!.individualSlots(user.token, widget.pes_id);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: Text(
          widget.name + "'s Current Slots",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: appBarColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pushNamed(context, CHANGE_SLOT, arguments: {
            'allSlots': volunteerSlotsCubit!.allSlots,
            'currentSlots': volunteerSlotsCubit!.current,
            'requestedSlots': volunteerSlotsCubit!.requested,
            'pes_id': widget.pes_id
          }).then((value) {
            setState(() {
              volunteerSlotsCubit!.allSlots = [];
            });
          });
          print("Button tapped");
        },
        child: Container(
          height: 50,
          width: 50,
          // width: MediaQuery.of(context).size.width * 0.70,
          margin: EdgeInsets.all(10),
          //padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 245, 72, 72),
            //borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromARGB(255, 245, 72, 72),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ), //Text("Edit ",style: const TextStyle(color: Colors.white,fontFamily: "Roboto",fontSize: 17),)
          ),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          backgroundColor:
              appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
        ),

        controller: _pageRefreshController,
        onRefresh: () {
          setState(() {
            volunteerSlotsCubit!.allSlots = [];
          });
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
            child: Column(children: [
              Spacer(),
              /*+Expanded(
                  flex: 2,
                  child: Text(
                    "Hi ${user.name}, your Slots",
                    style: TextStyle(fontSize: 20),
                  ),
                ),*/
              // Divider(
              //   thickness: 2,
              //   color: Colors.grey.withOpacity(0.1),
              // ),
              Expanded(
                flex: 30,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: BlocBuilder<VolunteerSlotsCubit, VolunteerSlotsState>(
                    builder: (context, state) {
                      print(state);
                      if (state is VolunteerSlotsLoaded) {
                        return SmartRefresher(
                          enablePullDown: true,
                          header: WaterDropMaterialHeader(
                            backgroundColor: appBarColor.withOpacity(
                                0.8), //Theme.of(context).primaryColor,
                          ),
                          controller: _listRefreshController,
                          onRefresh: () {
                            // setState(() {});
                            setState(() {
                              volunteerSlotsCubit!.allSlots = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          child: ListView(
                            padding: EdgeInsets.all(4),
                            children: currentSlots()
                                .map((volunteer) => SlotTile(
                                      slot: volunteer,
                                      mySlot: false,
                                    ))
                                .toList(),
                          ),
                        );
                      } else if (state is VolunteerSlotsLoadFailed) {
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
            ]),
          ),
        ),
      ),
    );
  }
}
