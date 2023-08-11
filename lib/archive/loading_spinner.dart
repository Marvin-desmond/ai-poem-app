import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue[100],
          child: const LoadingPieSpinner()),
    ));
  }
}

class LoadingPieSpinner extends StatefulWidget {
  final double size;
  final Color color;

  const LoadingPieSpinner(
      {super.key, this.size = 50.0, this.color = Colors.blue});

  @override
  _LoadingPieSpinnerState createState() => _LoadingPieSpinnerState();
}

class _LoadingPieSpinnerState extends State<LoadingPieSpinner>
    with SingleTickerProviderStateMixin {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    Color color = widget.color;

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: RotationTransition(
                  turns: _animation,
                  child: CustomPaint(
                    painter: ArcPainter(color: color.withOpacity(0.1)),
                  ),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: RotationTransition(
                  turns: _animation,
                  child: CustomPaint(
                    painter: ArcPainter(
                        color: color.withOpacity(0.4), reverse: true),
                  ),
                ),
              ),
            ],
          ),
          Stack(children: [
            const OppositePieSpinner(),
          ])
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final Paint _paint;
  final bool reverse;

  ArcPainter({Color? color, this.reverse = false})
      : _paint = Paint()
          ..color = color ?? Colors.transparent
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    double startAngle = reverse ? -0.5 : 0.0;
    startAngle = -startAngle;
    double sweepAngle = reverse ? -0.75 : 0.75;

    canvas.drawArc(
        rect, startAngle * 2.0 * 3.14, sweepAngle * 2.0 * 3.14, false, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OppositePieSpinner extends StatefulWidget {
  final double size;
  final Color color;

  const OppositePieSpinner(
      {super.key, this.size = 50.0, this.color = Colors.blue});

  @override
  _OppositePieSpinnerState createState() => _OppositePieSpinnerState();
}

class _OppositePieSpinnerState extends State<OppositePieSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    Color color = widget.color;

    return SizedBox(
      width: size,
      height: size,
      child: SizedBox(
        width: size,
        height: size,
        child: RotationTransition(
          turns: _animation,
          child: CustomPaint(
            painter: OppositeArcPainter(20, 0),
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
    ..strokeWidth = 5;
}

class OppositeArcPainter extends CustomPainter {
  final double radius;
  double baseAngle;
  final Paint red = createPaint(Colors.red);
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
    // canvas.drawArc(rect, baseAngle + 4 / 3 * 3.14, sweepAngle(), false, green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double sweepAngle() => 0.5 * 2 / 3 * 3.14;
}
