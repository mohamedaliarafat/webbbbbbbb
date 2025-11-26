import 'dart:async';

import 'package:flutter/material.dart';


class CallScreen extends StatefulWidget {
  final String callId;
  final String chatId;
  final bool isIncoming;
  final String callType;

  const CallScreen({
    Key? key,
    required this.callId,
    required this.chatId,
    this.isIncoming = false,
    required this.callType,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = false;
  Duration _callDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeCall();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration += Duration(seconds: 1);
      });
    });
  }

  void _initializeCall() {
    if (!widget.isIncoming) {
      // Start outgoing call logic
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Caller Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Caller Name
                  Text(
                    'محمد أحمد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  // Call Status
                  Text(
                    widget.isIncoming ? 'مكالمة واردة' : 'يتم الاتصال...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  // Call Duration
                  if (_callDuration.inSeconds > 0)
                    Text(
                      _formatDuration(_callDuration),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            // Call Controls
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Button
                  _CallControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    backgroundColor: Colors.grey[700]!,
                    iconColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),

                  // Speaker Button
                  _CallControlButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    backgroundColor: Colors.grey[700]!,
                    iconColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isSpeakerOn = !_isSpeakerOn;
                      });
                    },
                  ),

                  // Video Button (for video calls)
                  if (widget.callType == 'video')
                    _CallControlButton(
                      icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                      backgroundColor: Colors.grey[700]!,
                      iconColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isVideoOn = !_isVideoOn;
                        });
                      },
                    ),

                  // End Call Button
                  _CallControlButton(
                    icon: Icons.call_end,
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    onPressed: () {
                      _endCall();
                    },
                  ),
                ],
              ),
            ),

            // Additional Controls for Incoming Call
            if (widget.isIncoming)
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reject Call
                    _CallControlButton(
                      icon: Icons.call_end,
                      backgroundColor: Colors.red,
                      iconColor: Colors.white,
                      onPressed: () {
                        _rejectCall();
                      },
                    ),

                    // Accept Call
                    _CallControlButton(
                      icon: Icons.call,
                      backgroundColor: Colors.green,
                      iconColor: Colors.white,
                      onPressed: () {
                        _acceptCall();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _endCall() {
    _timer?.cancel();
    Navigator.pop(context);
    // Add call end logic here
  }

  void _acceptCall() {
    setState(() {
      // Change call status to active
    });
    // Add call accept logic here
  }

  void _rejectCall() {
    _timer?.cancel();
    Navigator.pop(context);
    // Add call reject logic here
  }
}

class _CallControlButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const _CallControlButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: backgroundColor,
      child: IconButton(
        icon: Icon(icon),
        color: iconColor,
        iconSize: 24,
        onPressed: onPressed,
      ),
    );
  }
}