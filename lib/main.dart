// AllConnect - File 1 + 2
// Splash + Conference layout + Live Chat, Emojis, Notepad, Wallet

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const AllConnectApp());

class AllConnectApp extends StatelessWidget {
  const AllConnectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const ConferenceScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network('logo.jpg', fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 20),
            const Text('All Connect',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Connect Everywhere, Connect Everyone',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({super.key});
  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  final String meetingId = 'AC-1234';
  final String meetingType = 'Church';
  int totalMinutes = 124;
  int walletBalance = 124;
  int timerSeconds = 0;

  bool micOn = true;
  bool camOn = true;
  bool screenShareOn = false;
  bool splitScreen = false;
  bool blurBackground = false;
  bool noiseFilter = false;

  bool isRecording = false;
  int recordingSeconds = 0;

  bool isLiveStreaming = false;
  int liveViewerCount = 0;

  int bottomTab = 0;
  final bibleController = TextEditingController();
  String bibleResult = "";
  final quranController = TextEditingController();
  String quranResult = "";

  // File 2 - chat, notes, emojis state
  final List<Map<String, String>> chatMessages = [
    {'user': 'System', 'msg': 'Welcome to All Connect'},
    {'user': 'Pastor James', 'msg': 'God bless you all'},
  ];
  final publicChatController = TextEditingController();
  final privateChatController = TextEditingController();
  String privateChatTarget = 'Everyone';

  final noteTitleController = TextEditingController();
  final noteContentController = TextEditingController();
  final List<Map<String, String>> savedNotes = [];

  final List<String> emojiList = [
    '\u2764\ufe0f',
    '\ud83d\ude02',
    '\ud83d\ude4f',
    '\ud83d\udc4f',
    '\ud83d\ude0d',
    '\ud83d\udd25',
  ];
  final List<String> stickerList = [
    'Amen',
    'Praying',
    'Hallelujah',
    'Welcome',
    'Thank You',
    'God Bless',
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 60), (t) {
      if (!mounted) return;
      setState(() {
        totalMinutes++;
        walletBalance++;
        if (isRecording) recordingSeconds++;
        if (isLiveStreaming) liveViewerCount++;
      });
    });
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        timerSeconds++;
        if (isRecording) recordingSeconds++;
      });
    });
  }

  @override
  void dispose() {
    publicChatController.dispose();
    privateChatController.dispose();
    noteTitleController.dispose();
    noteContentController.dispose();
    super.dispose();
  }

  void toggleRecord() {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) recordingSeconds = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isRecording
            ? 'Recording started - All notified'
            : 'Recording saved'),
        duration: const Duration(seconds: 2)));
  }

  void toggleLive() {
    setState(() {
      isLiveStreaming = !isLiveStreaming;
      liveViewerCount = isLiveStreaming ? 24 : 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isLiveStreaming
            ? 'Live started to YouTube + Facebook'
            : 'Live stopped'),
        duration: const Duration(seconds: 2)));
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 40, child: _topArea()),
            Expanded(flex: 60, child: _bottomArea()),
          ],
        ),
      ),
    );
  }

  Widget _topArea() {
    return Column(
      children: [
        _topBar(),
        Expanded(child: _videoGrid()),
        _toolbar(),
      ],
    );
  }

  Widget _topBar() {
    return Container(
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Row(children: [
            const Text('All Connect',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(width: 6),
            Text(meetingId,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const Spacer(),
            Text(_fmt(timerSeconds),
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(meetingType,
                  style: const TextStyle(fontSize: 10, color: Colors.black)),
            ),
            const SizedBox(width: 6),
            if (isRecording)
              Row(children: [
                const Icon(Icons.circle, color: Colors.red, size: 8),
                const SizedBox(width: 3),
                Text('REC ${_fmt(recordingSeconds)}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10)),
              ]),
            if (isLiveStreaming)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text('LIVE',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isRecording = false;
                  isLiveStreaming = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You left the meeting')));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Leave',
                    style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
          ]),
          const SizedBox(height: 2),
          Row(children: [
            Text(
                '$totalMinutes mins = $totalMinutes pts | Wallet N${walletBalance * 2}',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10)),
          ]),
        ],
      ),
    );
  }

  Widget _videoGrid() {
    final names = [
      'You',
      'Pastor James',
      'Student Aisha',
      'Sister Grace',
      'Bro John',
      'Sis Mary'
    ];
    final colors = [
      Colors.green.shade200,
      Colors.blue.shade200,
      Colors.orange.shade200,
      Colors.purple.shade200,
      Colors.teal.shade200,
      Colors.pink.shade200,
    ];
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 6,
        itemBuilder: (c, i) {
          return Container(
            decoration: BoxDecoration(
              color: colors[i],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(children: [
              Center(
                child: Text(names[i],
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                bottom: 3,
                right: 3,
                child: Row(children: [
                  Icon(i == 0 && !micOn ? Icons.mic_off : Icons.mic,
                      size: 12, color: Colors.white),
                  const SizedBox(width: 3),
                  Icon(
                      i == 0 && !camOn
                          ? Icons.videocam_off
                          : Icons.videocam,
                      size: 12,
                      color: Colors.white),
                ]),
              ),
              if (isRecording)
                const Positioned(
                  top: 3,
                  right: 3,
                  child: Icon(Icons.fiber_manual_record,
                      color: Colors.red, size: 12),
                ),
            ]),
          );
        },
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _tbtn(micOn ? Icons.mic : Icons.mic_off, 'Mic',
              () => setState(() => micOn = !micOn)),
          _tbtn(camOn ? Icons.videocam : Icons.videocam_off, 'Cam',
              () => setState(() => camOn = !camOn)),
          _tbtn(Icons.screen_share, 'Share',
              () => setState(() => screenShareOn = !screenShareOn)),
          _tbtn(Icons.grid_view, 'Split',
              () => setState(() => splitScreen = !splitScreen)),
          _tbtn(Icons.blur_on, 'Blur',
              () => setState(() => blurBackground = !blurBackground)),
          _tbtn(Icons.noise_control_off, 'Noise',
              () => setState(() => noiseFilter = !noiseFilter)),
          _tbtn(
              isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
              isRecording ? 'Stop' : 'Rec',
              toggleRecord),
          _tbtn(isLiveStreaming ? Icons.stop : Icons.podcasts,
              isLiveStreaming ? 'End' : 'Live', toggleLive),
        ]),
      ),
    );
  }

  Widget _tbtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(children: [
          Icon(icon, color: Colors.white, size: 18),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 9)),
        ]),
      ),
    );
  }

  Widget _bottomArea() {
    final tabs = [
      'Live Chat',
      'Emojis',
      'Bible',
      'Quran',
      'PDF',
      'Notepad',
      'Recording',
      'Live Stream',
      'Wallet',
    ];
    return Column(children: [
      Container(
        height: 36,
        color: Colors.grey.shade200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          itemBuilder: (c, i) => GestureDetector(
            onTap: () => setState(() => bottomTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: bottomTab == i
                        ? const Color(0xFF2E7D32)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(tabs[i],
                  style: TextStyle(
                      fontSize: 11,
                      color: bottomTab == i
                          ? const Color(0xFF2E7D32)
                          : Colors.black54,
                      fontWeight: bottomTab == i
                          ? FontWeight.bold
                          : FontWeight.normal)),
            ),
          ),
        ),
      ),
      Expanded(child: _buildTabContent()),
    ]);
  }

  Widget _buildTabContent() {
    switch (bottomTab) {
      case 0:
        return _buildLiveChat();
      case 1:
        return _buildEmojis();
      case 2:
        return _buildBible();
      case 3:
        return _buildQuran();
      case 4:
        return _buildPdf();
      case 5:
        return _buildNotepad();
      case 6:
        return _buildRecording();
      case 7:
        return _buildLiveStream();
      case 8:
        return _buildWallet();
      default:
        return const Center(child: Text('Tab'));
    }
  }

  Widget _buildPlaceholder(String name) {
    return Center(
      child: Text('$name content coming in File 3',
          style: const TextStyle(color: Colors.grey)),
    );
  }

  // ---------- Live Chat ----------
  Widget _buildLiveChat() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Chat privately to: ',
                  style: TextStyle(fontSize: 12)),
              DropdownButton<String>(
                value: privateChatTarget,
                items: const ['Everyone', 'Pastor James', 'Student Aisha', 'Sister Grace']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (v) => setState(() => privateChatTarget = v!),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                    '${chatMessages[i]['user']}: ${chatMessages[i]['msg']}',
                    style: const TextStyle(fontSize: 12)),
              ),
            ),
          ),
          TextField(
            controller: publicChatController,
            decoration: const InputDecoration(
              hintText: 'Type to everyone...',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) {
              if (v.trim().isEmpty) return;
              setState(() {
                chatMessages.add({'user': 'You', 'msg': v});
                publicChatController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  // ---------- Emojis ----------
  Widget _buildEmojis() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Emojis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Wrap(
            children: emojiList
                .map((e) => GestureDetector(
                      onTap: () => setState(() {
                        chatMessages.add({'user': 'You', 'msg': e});
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    ))
                .toList(),
          ),
          const Divider(),
          const Text('Stickers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Wrap(
            children: stickerList
                .map((s) => GestureDetector(
                      onTap: () => setState(() {
                        chatMessages.add({'user': 'You', 'msg': s});
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Chip(label: Text(s)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ---------- Notepad ----------
  Widget _buildNotepad() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: noteTitleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: noteContentController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: 'Write notes...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (noteTitleController.text.trim().isEmpty) return;
                    setState(() {
                      savedNotes.add({
                        'id': 'NOTE-${DateTime.now().millisecondsSinceEpoch}',
                        'meetingId': meetingId,
                        'title': noteTitleController.text,
                        'content': noteContentController.text,
                        'date': DateTime.now().toString().substring(0, 16),
                      });
                      noteTitleController.clear();
                      noteContentController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note saved')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Note'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: savedNotes.isEmpty
                ? const Center(
                    child: Text('No notes yet',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: savedNotes.length,
                    itemBuilder: (c, i) {
                      final n = savedNotes[i];
                      return ListTile(
                        dense: true,
                        title: Text(n['title']!),
                        subtitle: Text(
                            '${n['meetingId']} - ${n['content']}'),
                        trailing: Text(n['date']!.substring(5, 16),
                            style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- Wallet ----------
  Widget _buildWallet() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _walletRow('User ID', 'AC-USER-123'),
          _walletRow('Name', 'Amabioshiogwe'),
          _walletRow('Phone', '+234 800 000 0000'),
          _walletRow('Email', 'user@allconnect.app'),
          _walletRow('Role', 'Church Host'),
          _walletRow('NIN', 'Not verified'),
          const Divider(),
          _walletRow('Referral Code', 'AC-JOHN123'),
          _walletRow('Referred By', 'None'),
          _walletRow('Total Minutes', '$totalMinutes mins'),
          _walletRow(
              'Wallet Balance', '$walletBalance pts = N${walletBalance * 2}'),
          const Divider(),
          const Text('Points History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ListTile(
            dense: true,
            title: Text('$meetingId - $meetingType'),
            subtitle: Text('$totalMinutes mins = $totalMinutes pts'),
          ),
          const Divider(),
          const Text('Referrals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const ListTile(
            dense: true,
            title: Text('3 friends joined'),
            subtitle: Text('1500 pts earned'),
          ),
          const Divider(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.account_balance),
              label: const Text('Withdraw to Bank'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Withdrawal requested - N${walletBalance * 2}')),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _walletRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Expanded(
              child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildBible() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: bibleController,
                  decoration: const InputDecoration(
                    hintText: "e.g. John 3:16",
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                onPressed: () {
                  setState(() {
                    bibleResult = _bibleMock(bibleController.text);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                bibleResult.isEmpty ? _bibleMock("John 3:16") : bibleResult,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _bibleMock(String q) {
    if (q.trim().isEmpty) q = "John 3:16";
    return q + " (KJV)\n\nFor God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.";
  }

  Widget _buildQuran() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quranController,
                  decoration: const InputDecoration(
                    hintText: "e.g. Al-Fatiha",
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                onPressed: () {
                  setState(() {
                    quranResult = _quranMock();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                quranResult.isEmpty ? _quranMock() : quranResult,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _quranMock() {
    return "Al-Fatiha (The Opening)\n\nIn the name of God, The Most Gracious, The Dispenser of Grace.";
  }

  Widget _buildPdf() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File picker works on native builds")),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Pick PDF from phone files"),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.folder),
              label: const Text("View PDFs shared"),
            ),
          ),
          const Divider(),
          const Text("Shared PDFs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text("sermon_notes.pdf"),
                  subtitle: const Text("Shared by Pastor James - 2.4MB"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Viewer placeholder - Page 1 - Still on All Connect")),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text("bible_study_guide.pdf"),
                  subtitle: const Text("Shared by Sister Grace - 1.8MB"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Viewer placeholder - Page 1 - Still on All Connect")),
                    );
                  },
                ),
              ],
            ),
          ),
          const Text("PDF viewer works on native builds.", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecording() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecording ? Colors.red : const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: toggleRecord,
              icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
              label: Text(isRecording ? "Stop Recording" : "Start Recording"),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRecording ? Colors.red.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isRecording
                  ? "Recording: " + _fmt(recordingSeconds) + " - All participants notified - Privacy secured - Encrypted"
                  : "Not recording - tap Start Recording to begin",
              style: TextStyle(fontSize: 12, color: isRecording ? Colors.red.shade900 : Colors.black87),
            ),
          ),
          const Divider(),
          const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Record video+audio", style: TextStyle(fontSize: 12)),
            value: true,
            onChanged: (v) {},
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Audio only", style: TextStyle(fontSize: 12)),
            value: false,
            onChanged: (v) {},
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Cloud recording (All Connect cloud)", style: TextStyle(fontSize: 12)),
            value: true,
            onChanged: (v) {},
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Local (phone storage)", style: TextStyle(fontSize: 12)),
            value: false,
            onChanged: (v) {},
          ),
          const Divider(),
          const Text("My Recordings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              dense: true,
              title: const Text("REC-0001 - Church Service", style: TextStyle(fontSize: 12)),
              subtitle: const Text("AC-1234 - 45 mins - 120MB - 2025-01-15", style: TextStyle(fontSize: 11)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.download, size: 18), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.share, size: 18), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.delete, size: 18), onPressed: () {}),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              dense: true,
              title: const Text("REC-0002 - Bible Study", style: TextStyle(fontSize: 12)),
              subtitle: const Text("AC-1234 - 28 mins - 68MB - 2025-01-14", style: TextStyle(fontSize: 11)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.download, size: 18), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.share, size: 18), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.delete, size: 18), onPressed: () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text("Only host can start. All see RED REC indicator.", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const Text("Still earn points while recording.", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLiveStream() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLiveStreaming ? Colors.red : const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: toggleLive,
              icon: Icon(isLiveStreaming ? Icons.stop : Icons.podcasts),
              label: Text(isLiveStreaming ? "Stop Live" : "Go Live"),
            ),
          ),
          if (isLiveStreaming) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "LIVE " + liveViewerCount.toString() + " viewers - Streaming to: YouTube + Facebook",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
          const Divider(),
          const Text("Setup", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("YouTube Live", style: TextStyle(fontSize: 12)),
            value: true,
            onChanged: (v) {},
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Facebook Live", style: TextStyle(fontSize: 12)),
            value: true,
            onChanged: (v) {},
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Custom RTMP", style: TextStyle(fontSize: 12)),
            value: false,
            onChanged: (v) {},
          ),
          const SizedBox(height: 6),
          const TextField(
            decoration: InputDecoration(
              hintText: "rtmp://...",
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 6),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Stream Key",
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 6),
          const TextField(
            decoration: InputDecoration(
              hintText: "Stream Title - Sunday Service",
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text("Allow viewers to join All Connect from live?", style: TextStyle(fontSize: 11)),
            value: true,
            onChanged: (v) {},
          ),
          const Divider(),
          const Text(
            "Church: Copy RTMP from YouTube Studio > Go Live > paste Stream key here > Go Live. Your meeting streams to YouTube without leaving All Connect.",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text("Only host can Go Live. All see LIVE badge.", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const Text("Host earns double points when live.", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
