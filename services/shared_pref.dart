import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userIdkey= "USERKEY";
  static String userNamekey= "USERNAMEKEY";
  static String userEmailkey= "USEREMAILKEY";



  Future<bool> saveUserId(String getUserId)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userIdkey, getUserId);
  }

  Future<bool> saveUserName(String getUserName)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userNamekey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail)async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userEmailkey, getUserEmail);
  }

  Future<String?> getUserId()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userIdkey);
  }

  Future<String?> getUserName()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userNamekey);
  }

  Future<String?> getUserEmail()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userEmailkey);
  }

  saveUserImage(String downloadUrl) {}

}