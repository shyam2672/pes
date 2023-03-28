import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pes_admin/admin_screens/home.dart';
import 'package:pes_admin/constants/strings.dart';
import 'package:pes_admin/cubit/login_cubit.dart';

bool admin_dark_theme = true;

class SideDrawer extends StatefulWidget {
  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: admin_dark_theme ? Colors.black : Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            height: 200,
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'Admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
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
            ),
            decoration: BoxDecoration(
              color: admin_dark_theme ? Colors.black : Colors.white,
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     IconData(0xe44f, fontFamily: 'MaterialIcons'),
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     'Notifications',
          //     style:
          //         TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushNamed(context, APP_NOTIFICATIONS);
          //   },
          // ),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    IconData(0xf5fe, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  )
                : Icon(
                    IconData(0xf5fe, fontFamily: 'MaterialIcons'),
                    color: Colors.black,
                  ),
            title: admin_dark_theme
                ? const Text(
                    'Active Slots',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : Text(
                    'Active Slots',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ALL_SLOTS);
            },
          ),
          ListTile(
              leading: admin_dark_theme
                  ? const Icon(
                      IconData(0xf02ea, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                    )
                  : const Icon(
                      IconData(0xf02ea, fontFamily: 'MaterialIcons'),
                      color: Colors.black,
                    ),
              title: admin_dark_theme
                  ? const Text(
                      'Volunteer Slots',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white),
                    )
                  : const Text(
                      'Volunteer Slots',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, VOLUNTEER_SLOTS);
              }),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    IconData(0xf0db, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  )
                : const Icon(
                    IconData(0xf0db, fontFamily: 'MaterialIcons'),
                    color: Colors.black,
                  ), //IconData(0xf5fe, fontFamily: 'MaterialIcons')),
            title: admin_dark_theme
                ? const Text(
                    'All Batches',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : const Text(
                    'All Batches',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ALL_BATCHES);
            },
          ),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    Icons.fact_check,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.fact_check,
                    color: Colors.black,
                  ),
            title: admin_dark_theme
                ? const Text(
                    'Volunteers',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : const Text(
                    'Volunteers',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, ATTENDANCE_SCREEN);
            },
          ),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    IconData(0xe058, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  )
                : const Icon(
                    IconData(0xe058, fontFamily: 'MaterialIcons'),
                    color: Colors.black,
                  ),
            title: admin_dark_theme
                ? const Text(
                    'Join Applications',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : const Text(
                    'Join Applications',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.pop(context);
              Navigator.popUntil(
                  context, (route) => route.settings.name == HOME);
              Navigator.pushNamed(context, JOIN_APPLICATIONS);
            },
          ),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    IconData(0xefae, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  )
                : const Icon(
                    IconData(0xefae, fontFamily: 'MaterialIcons'),
                    color: Colors.black,
                  ),
            title: admin_dark_theme
                ? const Text(
                    'Leave Applications',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : const Text(
                    'Leave Applications',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LEAVE_APPLICATIONS);
            },
          ),
          ListTile(
            leading: admin_dark_theme
                ? const Icon(
                    IconData(0xf37f, fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                  )
                : const Icon(
                    IconData(0xf37f, fontFamily: 'MaterialIcons'),
                    color: Colors.black,
                  ),
            title: admin_dark_theme
                ? const Text(
                    'Student Needs',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  )
                : const Text(
                    'Student Needs',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, NEEDS);
            },
          ),
          // ListTile(
          //   leading: admin_dark_theme
          //       ? const Icon(
          //           Icons.light_mode,
          //           color: Colors.white,
          //         )
          //       : const Icon(
          //           Icons.dark_mode,
          //           color: Colors.black,
          //         ),
          //   title: admin_dark_theme
          //       ? const Text(
          //           'Light Theme',
          //           style: TextStyle(
          //               fontWeight: FontWeight.normal, color: Colors.white),
          //         )
          //       : const Text(
          //           'Dark Theme',
          //           style: TextStyle(
          //               fontWeight: FontWeight.normal, color: Colors.black),
          //         ),
          //   onTap: () {
          //     setState(() {
          //       admin_dark_theme = admin_dark_theme ? false : true;
          //       appBarColor = admin_dark_theme ? Colors.black : Colors.white;
          //     });
          //   },
          // ),
        ],
      ),
    ));
  }
}
