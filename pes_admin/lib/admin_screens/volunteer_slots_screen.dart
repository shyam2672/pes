import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pes_admin/admin_screens/widgets/side_menu.dart';
import 'package:pes_admin/admin_screens/widgets/title_heading_decision_button.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/list_volunteers_cubit.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/data/models/user.dart';
import 'package:pes_admin/data/models/volunteer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListVolunteersScreen extends StatefulWidget {
  @override
  _ListVolunteersScreenState createState() => _ListVolunteersScreenState();
}

class _ListVolunteersScreenState extends State<ListVolunteersScreen> {
  User user = User.empty(token: "");
  RefreshController _pageRefreshController =
          RefreshController(initialRefresh: false),
      _listRefreshController = RefreshController(initialRefresh: false);

  ListVolunteersCubit? listVolunteersCubit;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<LoginCubit>(context).user;
    listVolunteersCubit = BlocProvider.of<ListVolunteersCubit>(context);
    listVolunteersCubit!.loadVolunteerList(user.token);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: SideDrawer(),
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Volunteers",
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
          backgroundColor:
              appBarColor.withOpacity(0.8), //Theme.of(context).primaryColor,
        ),

        controller: _pageRefreshController,
        onRefresh: () {
          setState(() {
            listVolunteersCubit!.volunteers = [];
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
              Divider(
                thickness: 2,
                color: Colors.grey.withOpacity(0.1),
              ),
              Expanded(
                flex: 30,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: BlocBuilder<ListVolunteersCubit, ListVolunteersState>(
                    builder: (context, state) {
                      print(state);
                      if (state is ListVolunteersLoaded) {
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
                              listVolunteersCubit!.volunteers = [];
                            });
                            _listRefreshController.refreshCompleted();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListView(
                              padding: EdgeInsets.all(4),
                              children: listVolunteersCubit!.volunteers
                                  .map((volunteer) => VolunteerTile(
                                        volunteer: volunteer,
                                        //mySlot: true,
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                      } else if (state is ListVolunteersLoadingError) {
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

class VolunteerTile extends StatelessWidget {
  final VolunteerSlotPage volunteer;
  VolunteerTile({required this.volunteer});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        // width: 250,
        height: 80,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        margin: EdgeInsets.only(top: 5, bottom: 5),
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
                TileHeading(heading: "PES ID", text: volunteer.pes_id),
                Spacer(),
                TileHeading(heading: "NAME", text: volunteer.name),
                Spacer(),
                TileHeading(heading: "PATHSHAALA", text: volunteer.pathshaala),
                Spacer(),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, INDIVIDUAL_SLOTS, arguments: {
          'pes_id': volunteer.pes_id,
          'name': volunteer.name,
        });
      },
    );
  }
}
