package com.shtreb.socket_io;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodChannel;
import io.socket.emitter.Emitter;

public class SocketListener implements Emitter.Listener {

    private final MethodChannel _methodChannel;
    private final String _socketId;
    private final String _event;
    private final String _callback;

    public SocketListener(MethodChannel methodChannel, String socketId, String event, String callback) {
        _methodChannel = methodChannel;
        _socketId = socketId;
        _event = event;
        _callback = callback;
    }

    public String getCallback() {
        return _callback;
    }

    @Override
    public void call(Object... args) {
        if (args != null && _methodChannel != null && !Utils.isNullOrEmpty(_event)
                && !Utils.isNullOrEmpty(_callback)) {
            String data = "";
            if (args.length > 0) {
                data = (args[0] != null ? args[0].toString() : "");
            }
            final String finalData = data;
            final Handler _handler = new Handler(Looper.getMainLooper());
            _handler.post(new Runnable() {
                @Override
                public void run() {
                    _methodChannel.invokeMethod(_socketId + "|" + _event + "|" + _callback, finalData);
                }
            });
        }
    }
}
