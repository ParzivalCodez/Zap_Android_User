import '../models/Admin.dart';

void registrationHandler(name, phone, usermail, context) {
  var user = Admin(name, phone, usermail);
  user.createAccount(context);
}
