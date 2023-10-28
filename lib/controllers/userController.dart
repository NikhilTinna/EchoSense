import 'package:get/get.dart';
import 'package:social_media/models/post.dart';

class UserController extends GetxController {
  RxList currentUserPosts = [].obs;
  RxBool currentUserIsLoading = false.obs;
}
