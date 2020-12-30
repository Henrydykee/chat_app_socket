import 'package:chat_app_socket/model/user.dart';
import 'package:chat_app_socket/socket_utils.dart';

class G {
  static List<User> dummyUser;
  static User loggedinUser;
  static User toChatUser;
  static SocketUtils socketUtils;

  static void initDummyUsers() {
    User userA = User(id: 100, name: "Dykee", email: "test@gmail.com");
    User userB = User(id: 100, name: "Henry", email: "test@gmail.com");
    dummyUser = List();
    dummyUser.add(userA);
    dummyUser.add(userB);
  }

  static List<User> getUsersFor(User user) {
    List<User> filteredUsers = dummyUser
        .where((e) => (!e.name.toLowerCase().contains(user.name.toLowerCase())))
        .toList();
    return filteredUsers;
  }

  static initSocket() {
    if (null == socketUtils) {
      socketUtils = SocketUtils();
    }
  }
}
