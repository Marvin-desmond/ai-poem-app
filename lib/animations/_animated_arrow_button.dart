part of '../screens/first_screen.dart';

/// An arrow that fades out, then fades back in and slides down, ending in it's original position with full opacity.
class _AnimatedArrowButton extends StatelessWidget {
  _AnimatedArrowButton(
      {Key? key, required this.onTap, required this.semanticTitle})
      : super(key: key);

  final String semanticTitle;
  final VoidCallback onTap;

  final _fadeOutIn = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: .5),
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: .5),
  ]);

  final _slideDown = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: .5),
    TweenSequenceItem(tween: Tween(begin: -1, end: 1), weight: .5)
  ]);

  static String supplant(String value, Map<String, String> supplants) {
    return value.replaceAllMapped(RegExp(r'\{\w+\}'), (match) {
      final placeholder = match.group(0) ?? '';
      if (supplants.containsKey(placeholder)) {
        return supplants[placeholder]!;
      }
      return placeholder;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 500);
    return AppBtn.basic(
      semanticLabel: supplant(
        "Explore details about {title}.",
        {'{title}': semanticTitle},
      ),
      onPressed: onTap,
      child: SizedBox(
        height: 80,
        width: 50,
        child: Animate(
          effects: [
            CustomEffect(
                builder: _buildOpacityTween,
                duration: duration,
                curve: Curves.easeOut),
            CustomEffect(
                builder: _buildSlideTween,
                duration: duration,
                curve: Curves.easeOut),
          ],
          child: Transform.rotate(
            angle: pi * .5,
            child:
                const Icon(Icons.chevron_right, size: 42, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildOpacityTween(BuildContext _, double value, Widget child) {
    final opacity = _fadeOutIn.evaluate(AlwaysStoppedAnimation(value));
    return Opacity(opacity: opacity, child: child);
  }

  Widget _buildSlideTween(BuildContext _, double value, Widget child) {
    double yOffset = _slideDown.evaluate(AlwaysStoppedAnimation(value));
    return Align(alignment: Alignment(0, -1 + yOffset * 2), child: child);
  }
}
