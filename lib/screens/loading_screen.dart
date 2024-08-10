import 'dart:ui';
import 'package:ai_poem_app/common.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

    @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    double size = 50.0;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/default.png'), 
            fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/default.png'), 
                fit: BoxFit.contain),
          ),
          child: Center(
            child: SizedBox(
              width: size,
              height: size,
              child: SizedBox(
                width: size,
                height: size,
                child: RotationTransition(
                  turns: _animation,
                  child: CustomPaint(
                    painter: OppositeArcPainter(50, 0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Paint createPaint(Color color) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
}

class OppositeArcPainter extends CustomPainter {
  final double radius;
  double baseAngle;
  final Paint red = createPaint(Colors.blue);
  final Paint blue = createPaint(Colors.blue);
  final Paint backColor = createPaint(Colors.blue[200]!);

  OppositeArcPainter(this.radius, this.baseAngle);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    canvas.drawArc(rect, baseAngle + 1 * 3.14, 180, false, backColor);
    canvas.drawArc(rect, baseAngle, sweepAngle(), false, blue);
    canvas.drawArc(rect, baseAngle + 1 * 3.14, sweepAngle(), false, red);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double sweepAngle() => 0.5 * 2 / 3 * 3.14;
}

