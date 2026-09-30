import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/health/models/exercise.dart';

void showExerciseDetailSheet(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => ExerciseDetailSheet(exercise: exercise),
  );
}

class ExerciseDetailSheet extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailSheet({super.key, required this.exercise});

  @override
  State<ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

/// Where the tutorial player currently is. YouTube reports failures through
/// the controller rather than by throwing, so the phase is tracked explicitly
/// to keep a dead or un-embeddable video from rendering as an unexplained black
/// box.
enum _PlayerPhase { idle, loading, ready, failed }

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  _PlayerPhase _phase = _PlayerPhase.idle;
  YoutubePlayerController? playerController;

  void startVideo() {
    // A second tap while the player is already coming up would create another
    // controller and leak the first one.
    if (_phase == _PlayerPhase.loading || _phase == _PlayerPhase.ready) return;

    setState(() => _phase = _PlayerPhase.loading);

    final controller = YoutubePlayerController(
      initialVideoId: widget.exercise.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    controller.addListener(_onPlayerStateChanged);
    setState(() => playerController = controller);
  }

  void _onPlayerStateChanged() {
    if (!mounted) return;
    final controller = playerController;
    if (controller == null) return;

    final value = controller.value;
    if (_phase != _PlayerPhase.failed && value.hasError) {
      setState(() => _phase = _PlayerPhase.failed);
      return;
    }
    if (_phase == _PlayerPhase.loading && value.isReady) {
      setState(() => _phase = _PlayerPhase.ready);
    }
  }

  /// Sends the user to the real YouTube player, which is the escape hatch when
  /// a video cannot be embedded or fails to load.
  Future<void> _openOnYouTube() async {
    final uri = Uri.https('www.youtube.com', '/watch', {
      'v': widget.exercise.youtubeId,
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open YouTube on this device.'),
        ),
      );
    }
  }

  void _retryVideo() {
    _disposePlayer();
    setState(() => _phase = _PlayerPhase.idle);
    startVideo();
  }

  void _disposePlayer() {
    final controller = playerController;
    if (controller == null) return;
    controller.removeListener(_onPlayerStateChanged);
    playerController = null;
    controller.dispose();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: pageBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            children: [
              buildDragHandleAndClose(),
              const SizedBox(height: 14),
              buildTitleRow(),
              const SizedBox(height: 4),
              Text(
                widget.exercise.category,
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              buildStatRow(),
              const SizedBox(height: 16),
              buildAboutSection(),
              const SizedBox(height: 16),
              buildBenefitsSection(),
              const SizedBox(height: 24),
              buildVideoSection(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDragHandleAndClose() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: cardBorderColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: chipBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitleRow() {
    final isBeginner = widget.exercise.level.toLowerCase().contains("beg");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.exercise.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isBeginner ? greenBackground : chipBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.exercise.level,
            style: GoogleFonts.poppins(
              color: isBeginner ? greenAccent : accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStatRow() {
    return Row(
      children: [
        Expanded(
          child: buildStatCard(
            icon: Icons.access_time_rounded,
            iconColor: accentColor,
            label: "Duration",
            value: widget.exercise.duration,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildStatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: pinkAccent,
            label: "Calories",
            value: widget.exercise.calories,
          ),
        ),
      ],
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ABOUT THIS ROUTINE",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.exercise.about,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: textColor.withValues(alpha: 0.85),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBenefitsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KEY BENEFITS",
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.exercise.benefits.map((benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    benefit,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget buildWatchTutorialButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: startVideo,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_filled_rounded, size: 22),
            const SizedBox(width: 8),
            Text(
              "Watch Video Tutorial",
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Swaps between the start button, the loading box, the player, and the
/// fallback card depending on how far the tutorial got.
Widget buildVideoSection() {
  switch (_phase) {
    case _PlayerPhase.idle:
      return buildWatchTutorialButton();
    case _PlayerPhase.loading:
      return _buildVideoPlaceholder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.6,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Loading video...",
              style: GoogleFonts.poppins(
                color: textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    case _PlayerPhase.failed:
      return _buildVideoUnavailableCard();
    case _PlayerPhase.ready:
      final controller = playerController;
      if (controller == null) return buildWatchTutorialButton();
      // YoutubePlayer lays out its own AspectRatio internally, so it is only
      // clipped here — wrapping it in another AspectRatio would nest two and
      // collapse the player height.
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: accentColor,
        ),
      );
  }
}

/// Fixed 16:9 placeholder used while the real player is still loading, so the
/// sheet does not jump in size once the video appears.
Widget _buildVideoPlaceholder({required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: child,
      ),
    ),
  );
}

Widget _buildVideoUnavailableCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: cardBorderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 20,
              color: pinkAccent,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Video unavailable",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "YouTube would not play this tutorial here. You can still watch it on YouTube.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _openOnYouTube,
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Open in YouTube",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: _retryVideo,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Retry",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}