import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class TextSizeMain extends StatefulWidget {
  const TextSizeMain({Key? key}) : super(key: key);

  @override
  State<TextSizeMain> createState() => TextSizeMainState();
}

class TextSizeMainState extends State<TextSizeMain> {

  double _currentSliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    _currentSliderValue = user.textSizeScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textTitleSize1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(
                      fontSize: user.textSizeScale * themeOptions.textSize2,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Slider(
                value: _currentSliderValue,
                min: 0.8,
                max: 1.6,
                divisions: 8,
                activeColor: themeOptions.primaryColor,
                inactiveColor: themeOptions.primaryColorLight,
                thumbColor: themeOptions.backgroundColor,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    user.textSizeScale = value;
                  });
                },
              ),
              TextButton(
                onPressed: _currentSliderValue == 1.0
                    ? null
                    : (){
                        setState(() {
                        _currentSliderValue = 1.0;
                        user.textSizeScale = 1.0;
                      });
                },
                child: Text(
                  "Tetap semula ke tetapan asal",
                  style: TextStyle(
                    color: _currentSliderValue == 1.0
                        ? themeOptions.secondaryColor
                        : themeOptions.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
