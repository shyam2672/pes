import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes/constants/strings.dart';
import 'package:pes/cubit/login_cubit.dart';
import 'package:pes/cubit/slot_change_cubit.dart';
import 'package:pes/volunteer_screen/all_slots_screen.dart';

class SideDrawer extends StatelessWidget {
  SlotChangeCubit? slotChangeCubit;
  @override
  Widget build(BuildContext context) {
    slotChangeCubit = BlocProvider.of<SlotChangeCubit>(context);
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 247, 98, 57),
                        Color.fromARGB(255, 247, 57, 215),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Volunteer',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Container(
              height: 0.1,
              color: Colors.grey,
            ),
            // ListTile(
            //   leading: const Icon(Icons.home),
            //   title: const Text('Home'),
            //   onTap: () => {},
            // ),
            ListTile(
              leading: const Icon(IconData(0xf5fe, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
              title: const Text(
                'All Slots',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
              onTap: () {
                //pass 1 as a variable so that concerned data can be retrieved
                Navigator.of(context).pop();
                Navigator.popUntil(context, (route) => route.isFirst);
                slotChangeCubit!.emit(SlotChangeInitial());
                Navigator.pushNamed(context, ALL_SLOTS);
              },
            ),
            ListTile(
              leading: const Icon(IconData(0xf37f, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
              title: const Text(
                'Student Needs',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, NEEDS);
              },
            ),
            ListTile(
              leading: const Icon(IconData(0xe2eb, fontFamily: 'MaterialIcons'),
                  color: Colors.white),
              title: const Text(
                'Outreach',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, OUTREACH);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text(
                'About Us',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, ABOUTUS);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.white),
              ),
              onTap: () {
                BlocProvider.of<LoginCubit>(context).storeToken("").then(
                    (value) => BlocProvider.of<LoginCubit>(context).login());
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
