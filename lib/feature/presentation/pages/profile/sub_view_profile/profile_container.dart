import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  // blurRadius: 8.0,
                  // spreadRadius: 1.0,
                ),
              ],
            ),
            padding: const EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        isDarkMode ? Colors.black : Colors.grey[300],
                    backgroundImage:
                        const AssetImage("assets/images/profile_image.png"),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 10),
                Text("Sushma Tamrakar",
                    style: normalStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Status',
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        )),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 30.0,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Text('IN',
                          textAlign: TextAlign.center,
                          style: smallStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
