// Import library yang dibutuhkan
import 'package:flutter/material.dart';
import 'dart:async';

// Fungsi main yang menjalankan aplikasi Flutter
void main() {
  runApp(const MyApp());
}

// Kelas MyApp merupakan stateless widget utama yang akan dijalankan oleh aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Menonaktifkan banner debug di aplikasi
      debugShowCheckedModeBanner: false,
      title: "Timer App",
      // Home screen aplikasi
      home: TimerApp(),
    );
  }
}

// Kelas TimerApp merupakan stateful widget yang mengatur logika timer dan tampilan aplikasi
class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

// Kelas _TimerAppState merupakan state dari TimerApp yang berisi logika dan tampilan
class _TimerAppState extends State<TimerApp> {
  // Variabel untuk menyimpan nilai jam, menit, detik
  late int hours;
  late int minutes;
  late int seconds;
  // Variabel untuk mengecek apakah timer sedang berjalan
  late bool isRunning;
  // Variabel untuk mengecek apakah timer sedang di-pause
  late bool isPaused;
  // Variabel untuk mengecek apakah waktu sudah habis
  late bool isTimeOver;
  // Controller untuk input jam, menit, detik
  late TextEditingController hourController;
  late TextEditingController minuteController;
  late TextEditingController secondController;
  // Timer untuk mengatur penghitungan waktu
  late Timer timer;

  // Metode initState() dipanggil saat widget pertama kali diinisialisasi
  @override
  void initState() {
    super.initState();
    // Menginisialisasi semua variabel ke nilai awal
    hours = 0;
    minutes = 0;
    seconds = 0;
    isRunning = false;
    isPaused = false;
    isTimeOver = false;
    // Menginisialisasi controller untuk input jam, menit, detik
    hourController = TextEditingController();
    minuteController = TextEditingController();
    secondController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Timer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 225, 244, 253),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bagian input untuk jam, menit, detik
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Input jam
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: hourController..text = hours.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      onChanged: (value) {
                        setState(() {
                          hours = int.tryParse(value) ?? 0;
                          hours = hours.clamp(0, 23);
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "HH",
                      ),
                    ),
                  ),
                  // Tombol untuk menambah atau mengurangi jam
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (hours < 24) {
                              hours++;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_up),
                        iconSize: 15,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (hours < 24) {
                              hours--;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 15,
                        splashColor: Colors.transparent,
                      ),
                    ],
                  ),
                  const Text(
                    " : ",
                    style: TextStyle(fontSize: 30),
                  ),
                  // Input menit
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: minuteController..text = minutes.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      onChanged: (value) {
                        setState(() {
                          minutes = int.tryParse(value) ?? 0;
                          minutes = minutes.clamp(0, 59);
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "MM",
                      ),
                    ),
                  ),
                  // Tombol untuk menambah atau mengurangi menit
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (minutes < 59) {
                              minutes++;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_up),
                        iconSize: 15,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (minutes > 0) {
                              minutes--;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 15,
                      ),
                    ],
                  ),
                  const Text(
                    " : ",
                    style: TextStyle(fontSize: 30),
                  ),
                  // Input detik
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: secondController..text = seconds.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      onChanged: (value) {
                        setState(() {
                          seconds = int.tryParse(value) ?? 0;
                          seconds = seconds.clamp(0, 59);
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "SS",
                      ),
                    ),
                  ),
                  // Tombol untuk menambah atau mengurangi detik
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (seconds < 59) {
                              seconds++;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_up),
                        iconSize: 15,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (seconds > 0) {
                              seconds--;
                            }
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              // Tombol untuk memulai, menjeda, atau menghentikan timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!isRunning) {
                        startTimer();
                      } else {
                        pauseTimer();
                      }
                    },
                    icon: Icon(
                      isRunning ? Icons.pause_circle : Icons.play_circle,
                    ),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      stopTimer();
                    },
                    icon: const Icon(Icons.stop_circle),
                    iconSize: 40,
                  ),
                ],
              ),
              // Teks untuk menampilkan pesan "Waktu Habis!" saat timer selesai
              Visibility(
                visible: isTimeOver,
                child: const Text(
                  "Waktu Habis!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                height: 250,
              ),
              const Text(
                "Ulul 'Azmi_222410102068",
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Metode untuk memulai timer
  void startTimer() {
    setState(() {
      isRunning = true;
      isPaused = false;
      isTimeOver = false;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            if (hours > 0) {
              hours--;
              minutes = 59;
              seconds = 59;
            } else {
              stopTimer();
            }
          }
        }
        if (hours == 0 && minutes == 0 && seconds == 0) {
          stopTimer();
          isTimeOver = true;
        }
      });
    });
  }

  // Metode untuk menjeda timer
  void pauseTimer() {
    setState(() {
      isRunning = false;
      isPaused = true;
    });
    if (isPaused) {
      timer.cancel();
    } else {
      startTimer();
    }
  }

  // Metode untuk menghentikan timer
  void stopTimer() {
    setState(() {
      isRunning = false;
      isPaused = false;
      isTimeOver = false;
      hours = 0;
      minutes = 0;
      seconds = 0;
      hourController.clear();
      minuteController.clear();
      secondController.clear();
    });
    timer.cancel();
  }

  // Metode dispose() dipanggil saat widget dihapus
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
  }
}
