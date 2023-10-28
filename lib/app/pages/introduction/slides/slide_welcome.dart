part of '../introduction_view.dart';

class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        transform: const GradientRotation(45.0),
        colors: [himitsuPurpleLight, himitsuBlueLight],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  FlutterI18n.translate(context, 'introduction.welcome.title'),
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: TextSize.extraLarge * 2, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  // trackVisibility: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            FlutterI18n.translate(context, 'introduction.welcome.content'),
                            style: TextStyle(fontSize: TextSize.medium, color: Colors.grey.shade200),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
