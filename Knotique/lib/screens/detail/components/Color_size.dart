import 'package:crochet/constants.dart';
import 'package:crochet/models/product.dart';
import 'package:flutter/material.dart';

class ColorSize extends StatefulWidget {
  const ColorSize({
    super.key,
    required this.products,
  });

  final Products products;

  @override
  State<ColorSize> createState() => _ColorSizeState();
}

class _ColorSizeState extends State<ColorSize> {
  int selectedColorIndex = 0;

  final List<Color> colors = [
    Color(0xFF356C95),
    Color.fromARGB(255, 233, 164, 75),
    Color.fromARGB(255, 125, 112, 112),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Color"),
              Row(
                children: List.generate(
                  colors.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: ColorDot(
                      color: colors[index],
                      isSelected: selectedColorIndex == index,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: kTextColor),
              children: [
                TextSpan(text: "Size\n"),
                TextSpan(
                  text: "${widget.products.size} cm",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorDot({
    super.key,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kDefaultPaddin / 4,
        right: kDefaultPaddin / 2,
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}