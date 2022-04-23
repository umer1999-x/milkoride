import 'package:milkoride/controllers/add_product_controller.dart';
import 'package:milkoride/controllers/admin_controller.dart';
import 'package:milkoride/controllers/create_user_controller.dart';
import 'package:milkoride/controllers/edituser_controller.dart';
import 'package:milkoride/controllers/sign_up_controller.dart';
import 'package:milkoride/models/add_product_model.dart';

import '../controllers/cart_controller.dart';
import '../controllers/edit_product_controller.dart';
import '../controllers/login_controller.dart';

CartController cartController = CartController.instance;
LoginController loginController = LoginController.instance;
SignUpController signController = SignUpController.instance;
AdminController adminController = AdminController.instance;
EditController editController = EditController.instance;
CreateUserController createUserController = CreateUserController.instance;
AddProductController addProductController = AddProductController.instance;
EditProductController editProductController = EditProductController.instance;
