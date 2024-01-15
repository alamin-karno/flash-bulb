import 'package:audioplayers/audioplayers.dart';
import 'package:flash_bulb/core/core.dart';
import 'package:flash_bulb/features/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torch_light/torch_light.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLightON = false;

  Ticker? _ticker;

  final audioPlayer = AudioPlayer();

  late SpringSimulation _springSimX;
  late SpringSimulation _springSimY;
  final _springDescription = const SpringDescription(
    mass: 1.0,
    stiffness: 500.0,
    damping: 15.0,
  );

  Offset anchorOffset = Offset.zero;
  Offset thumbOffset = const Offset(0, 100.0);

  void _onPanStart(details) => endSpring();

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      thumbOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    startSpring();

    setState(() {
      if (thumbOffset.dy >= 0.0) {
        isLightON ? torchLightOFF() : torchLightON();
        isLightON = !isLightON;
        playAudio();
      }
    });
  }

  void startSpring() {
    _springSimX = SpringSimulation(
      _springDescription,
      thumbOffset.dx,
      anchorOffset.dx,
      0,
    );

    _springSimY = SpringSimulation(
      _springDescription,
      thumbOffset.dy,
      100,
      100,
    );

    _ticker ??= createTicker(_onTick);
    _ticker!.start();
  }

  void endSpring() {
    if (_ticker != null) {
      _ticker!.stop();
    }
  }

  void _onTick(Duration elapsedTime) {
    final elapsedSecondFraction = elapsedTime.inMilliseconds / 1000.0;
    setState(() {
      thumbOffset = Offset(_springSimX.x(elapsedSecondFraction),
          _springSimY.x(elapsedSecondFraction));
    });

    if (_springSimY.isDone(elapsedSecondFraction) &&
        _springSimX.isDone(elapsedSecondFraction)) {
      endSpring();
    }
  }

  Future<void> torchLightON() async {
    try {
      await TorchLight.enableTorch();
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> torchLightOFF() async {
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void playAudio() async {
    if (kDebugMode) {
      print("music played");
    }

    await audioPlayer.play(AssetSource(AppAudios.clickMP3));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightON
          ? AppColors.lightONBackground
          : AppColors.lightOFFBackground,
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 400,
              height: 700,
              color: isLightON
                  ? AppColors.lightONBackground
                  : AppColors.lightOFFBackground,
            ),
            Positioned(
              top: 100,
              child: Text(
                'Flash Bulb'.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: isLightON
                      ? Colors.black.withOpacity(0.6)
                      : AppColors.grey,
                ),
              ),
            ),
            Positioned(
              top: 250,
              child: Image.asset(
                isLightON ? AppImages.icBulbON : AppImages.icBulbOFF,
                height: 100,
              ),
            ),
            Positioned(
              top: 345,
              child: CustomPaint(
                painter: RopeWidget(
                  ropeColor: isLightON ? AppColors.purple : AppColors.grey,
                  springOffset: thumbOffset,
                  anchorOffset: anchorOffset,
                ),
              ),
            ),
            Positioned(
              top: 335,
              child: Transform.translate(
                offset: thumbOffset,
                child: Icon(
                  Icons.circle,
                  size: 14,
                  color: isLightON ? AppColors.purple : AppColors.grey,
                ),
              ),
            ),
            const CopyRightTextWidget(),
          ],
        ),
      ),
    );
  }
}
