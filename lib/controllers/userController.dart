import 'package:get/get.dart';
import 'package:social_media/models/post.dart';

//for getting user-specific data
class UserController extends GetxController {
  RxMap<dynamic, dynamic> currentUserData = {}.obs;
  RxList currentUserPosts = [].obs;
  RxList currentUserTextPosts = [].obs;
  RxBool currentUserIsLoading = false.obs;
  RxList likes = [].obs;
  RxList isLikedByUser = [].obs;

  RxList quoteLikes = [].obs;
  RxList quoteIsLikedByUser = [].obs;

  //for user search functionality
  var isSearchLoading = false.obs;
  List users = [].obs;

  //stores current users followers and following

  List followers = [].obs;
  List following = [].obs;
}
