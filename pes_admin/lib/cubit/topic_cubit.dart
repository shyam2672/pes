import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pes_admin/data/models/topic.dart';
import 'package:pes_admin/data/repositories/main_server_repository.dart';

part 'topic_state.dart';

class TopicCubit extends Cubit<TopicState> {
  TopicCubit({required this.mainRepo}) : super(TopicInitial());
  List<Topic> topics = [];

  final MainRepository mainRepo;

  void loadTopics(String token) {
    print(topics);
    if (topics.isEmpty) {
      emit(TopicLoading());
      mainRepo.hasNetwork().then((Bool) {
        if (!Bool)
          emit(TopicFailure("No Internet"));
        else {
          mainRepo.getTopics(token).then((List resp) {
            if (resp[0] == true) {
              topics = resp[1];
              emit(TopicLoaded());
            } else
              emit(TopicFailure("Can't Load Topics"));
          });
        }
      });
    }
  }

  void deleteTopic(token, id) {
    print("ff");
    emit(TopicLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(TopicFailure('No internet'));
      else {
        mainRepo.delete_topic(token, id).then((resp) {
          print(resp);
          if (resp == "Deleted") {
            print("fffff");
            emit(TopicDeleted());
          } else
            emit(TopicNotDeleted());
        });
      }
    });
  }

  void addTopic(token, name,description) {
    print("ff");
    emit(TopicLoading());
    mainRepo.hasNetwork().then((Bool) {
      if (!Bool)
        emit(TopicFailure('No internet'));
      else {
        mainRepo.add_topic(token, name,description).then((resp) {
          print(resp);
          if (resp == "Added") {
            print("fffff");
            emit(TopicAdded());
          } else
            emit(TopicNotAdded());
        });
      }
    });
  }

  // void acceptoutreach(token, id) {
  //   print("ff");
  //   emit(OutreachLoading());
  //   mainRepo.hasNetwork().then((Bool) {
  //     if (!Bool)
  //       emit(OutreachFailure('No internet'));
  //     else {
  //       mainRepo.acceptoutreachslot(token, id).then((resp) {
  //         print("dsgdfhg hfghgh");
  //         print(resp);
  //         if (resp == "Accepted") {
  //           print("fffff");
  //           emit(OutreachAccepted());
  //         } else
  //           emit(OutreachNotAccepted());
  //       });
  //     }
  //   });
  // }
}
