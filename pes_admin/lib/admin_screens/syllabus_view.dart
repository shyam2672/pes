import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/driveactivity/v2.dart';
import 'package:pes_admin/cubit/login_cubit.dart';
import 'package:pes_admin/cubit/syllabus_cubit.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SyllabusView extends StatelessWidget {
  final String batch;

  SyllabusView({Key? key, required this.batch}) : super(key: key);

  LoginCubit? loginCubit;

  SyllabusCubit? syllabusCubit;

  PDFDocument? syllabusDoc;

  @override
  Widget build(BuildContext context) {
    syllabusCubit = BlocProvider.of<SyllabusCubit>(context);
    loginCubit = BlocProvider.of<LoginCubit>(context);
    syllabusCubit!.loadSyllabus(batch, loginCubit!.user.token);
    print("Build");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // centerTitle: true,
        title: Text(
          'Syllabus of Batch $batch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<SyllabusCubit, SyllabusState>(
        builder: (context, state) {
          print(state);
          if (state is SyllabusLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SyllabusLoaded) {
            print("Loading PDF at ${state.syllabusUrl}");
            return SfPdfViewer.network(
              state.syllabusUrl,
            );
          } else {
            print("Error");
            return Center(
              child: Text("Couldn't Load Document"),
            );
          }
        },
      ),
    );
  }
}
