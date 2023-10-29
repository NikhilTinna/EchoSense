import 'package:get/get.dart';
import 'package:social_media/models/post.dart';

class UserController extends GetxController {
  RxMap<dynamic, dynamic> currentUserData = {}.obs;
  RxList currentUserPosts = [].obs;
  RxList currentUserTextPosts = [].obs;
  RxBool currentUserIsLoading = false.obs;
  RxList likes = [].obs;
  RxList isLikedByUser = [].obs;
}
