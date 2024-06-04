import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/setting_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    final user = ref.watch(userProvider);

    double balance = user.totalSpent;
    double bonus = user.hasMadePayment && user.totalSpent > 500 ? 50 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.watch(themeNotifierProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "https://miro.medium.com/v2/resize:fit:1400/1*oRpNYT1pE4yJntC7qAdiYQ.png"),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                user.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 155,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "Bonus: \$$bonus",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 155,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            "Balance: \$$balance",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SettingWidget(optionsText: "Language"),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffE22323),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside, color: const Color(0xffE22323))),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 27.5),
                      child: Text(
                        "Delete Account",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                          color: theme.dividerColor,
                          strokeAlign: BorderSide.strokeAlignOutside
                        )),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 27.5),
                      child: Row(
                        children: [
                          Text(
                            "Log Out",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.exit_to_app,
                            color: theme.iconTheme.color,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
