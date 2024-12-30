import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project/models/user_model.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/auth/login.dart';
import 'package:project/screens/inner_screens/orders/orders_screen.dart';
import 'package:project/screens/inner_screens/viewed_recently.dart';
import 'package:project/screens/inner_screens/wishlist.dart';
import 'package:project/screens/loading_manager.dart';
import 'package:project/services/assets_manager.dart';
import 'package:project/services/my_app_methods.dart';
import 'package:project/widgets/app_name_text.dart';
import 'package:project/widgets/subtitle_text.dart';
import 'package:project/widgets/title_text.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;

  bool _isLoading = true;
  UserModel? userModel;
  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await UserProvider().fetchUserInfo();
    } catch (e) {
      if (!mounted) return;
      await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "an Error has been occured $e",
          fct: () {});
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(
            fontSize: 25,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: user == null ? true : false,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: TitlesTextWidget(
                    label: 'Please login to have ultimate access'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            userModel == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.background,
                                width: 3),
                            image: DecorationImage(
                              image: NetworkImage(userModel?.userImage ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitlesTextWidget(
                                label: userModel?.userName ?? 'UserName'),
                            SubtitleTextWidget(
                                label: userModel?.userEmail ?? 'emailAdress'),
                          ],
                        )
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitlesTextWidget(
                    label: 'General',
                    fontSize: 25,
                  ),
                  userModel == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          imagePath: AssetsManager.orderSvg,
                          text: 'All orders',
                          function: () {
                            Navigator.pushNamed(
                                context, OrdersScreenFree.routeName);
                          },
                        ),
                  userModel == null
                      ? const SizedBox.shrink()
                      : CustomListTile(
                          imagePath: AssetsManager.wishlistSvg,
                          text: 'Wishlist',
                          function: () async {
                            await Navigator.pushNamed(
                                context, WishListScreen.routeName);
                          },
                        ),
                  CustomListTile(
                    imagePath: AssetsManager.recent,
                    text: 'Viewed recently',
                    function: () async {
                      await Navigator.pushNamed(
                          context, ViewedRecentlyScreen.routeName);
                    },
                  ),
                  CustomListTile(
                    imagePath: AssetsManager.address,
                    text: 'Address',
                    function: () {},
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const TitlesTextWidget(
                    label: 'Settings',
                    fontSize: 25,
                  ),
                  SwitchListTile(
                    secondary: Image.asset(
                      AssetsManager.theme,
                      height: 30,
                    ),
                    title: Text(themeProvider.getIsDarkTheme
                        ? 'Dark mode'
                        : 'Light mode'),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular((30)),
                    ),
                  ),
                  icon: Icon(user == null ? Icons.login : Icons.logout),
                  label: Text(user == null ? 'Login' : 'Logout'),
                  // onPressed: () async {
                  //   await MyAppMethods.showErrorORWarningDialog(
                  //       context: context,
                  //       subtitle: "Are you sure?",
                  //       fct: () {},
                  //       isError: false);
                  // },
                  onPressed: () async {
                    if (user == null) {
                      await Navigator.pushNamed(context, LoginScreen.routName);
                    } else {
                      await MyAppMethods.showErrorORWarningDialog(
                        context: context,
                        subtitle: "Are you sure",
                        fct: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          await Navigator.pushNamed(
                              context, LoginScreen.routName);
                        },
                        isError: false,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.function});

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image.asset(
        imagePath,
        height: 40,
      ),
      title: SubtitleTextWidget(label: text, fontSize: 20),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
