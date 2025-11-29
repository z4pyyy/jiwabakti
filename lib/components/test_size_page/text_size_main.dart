import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TextSizeMain extends StatefulWidget {
  const TextSizeMain({Key? key}) : super(key: key);

  @override
  State<TextSizeMain> createState() => TextSizeMainState();
}

class TextSizeMainState extends State<TextSizeMain> {

  double _currentSliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 20 * _currentSliderValue,
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
                      fontSize: 16 * _currentSliderValue,
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
                activeColor: Color(0xFFD24C00),
                inactiveColor: Color(0xFFD24C00).withOpacity(0.3),
                thumbColor: Colors.white,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              TextButton(
                onPressed: _currentSliderValue == 1.0
                    ? null
                    : (){
                        setState(() {
                        _currentSliderValue = 1.0;
                      });
                },
                child: Text("Tetap semula ke tetapan asal", style: TextStyle(color: _currentSliderValue == 1.0 ? Colors.grey : Color(0xFFD24C00)),),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
