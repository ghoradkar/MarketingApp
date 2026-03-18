import 'dart:async';

extension DebounceExt<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    late StreamController<T> controller;
    late StreamSubscription<T> sub;

    void onData(T data) {
      timer?.cancel();
      timer = Timer(duration, () => controller.add(data));
    }

    void onDone() {
      timer?.cancel();
      controller.close();
    }

    controller = StreamController<T>(
      onListen: () {
        sub = listen(onData, onError: controller.addError, onDone: onDone);
      },
      onPause: () => sub.pause(),
      onResume: () => sub.resume(),
      onCancel: () async { timer?.cancel(); await sub.cancel(); },
    );

    return controller.stream;
  }
}
