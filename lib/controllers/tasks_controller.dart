
import 'package:get/get.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:tasky/models/user_task.dart';
import '../repository/abs_crud_repository.dart';

class TasksController extends GetxController {
  final crudRepository = Get.find<CrudRepository>();

  // Stream de firestore
  Rx<List<UserTask>> todoList = Rx<List<UserTask>>([]);

  List<UserTask> get todos => todoList.value;

  @override
  void onInit() async {
    String uid = Get.find<AuthController>().authUser.value!.uid;
    todoList.bindStream(crudRepository.todoStream(uid));
    super.onInit();
  }

  void close() async{
    todoList.close();
  }

}
