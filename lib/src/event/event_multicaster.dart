part of seesaw.event;

/**
 * Manager of event streams. Tracks listeners and passes out events to the listeners.
 */
class EventMulticaster {
    Map<int, _Channel> _channels = new Map<int, _Channel>();
    
    void fire(Event evt) {
        var channel = _channels[evt.id];
        if(channel != null && channel.enabled) {
            channel.controller.add(evt);
        }
    }
    
    void fireLazy(int eventId, Event createEvent()) {
        var channel = _channels[eventId];
        if(channel != null && channel.enabled) {
            channel.controller.add(createEvent());
        }
    }
    
    bool isEventEnabled(int eventId) {
        if(_channels == null) {
            return false;
        }
        
        var channel = _channels[eventId];
        
        if(channel == null) {
            return false;
        }
        
        return channel.enabled;
    }
    
    Stream<Event> getEventStream(int eventId) {
        var channel = _channels[eventId];
        if(channel == null) {
            var controller = new StreamController<Event>(
                    onCancel: () => _onCancel(eventId),
                    onListen: () => _onListen(eventId),
                    onPause:  () => _onPause(eventId),
                    onResume: () => _onResume(eventId),
                    sync: true
            ); 
            
            var stream = controller.stream.asBroadcastStream();            
            channel = new _Channel(eventId, controller, stream);
            _channels[eventId] = channel;
        } 
        
        return channel.stream;
    }
    
    void _onListen(int eventId) {
        _channels[eventId].enabled = true;
    }
    
    void _onPause(int eventId) {
        _channels[eventId].enabled = false;
    }
    
    void _onResume(int eventId) {
        _channels[eventId].enabled = true;
    }
    
    void _onCancel(int eventId) {
        // TODO: delete?
        _channels[eventId].enabled = false;
    }
}

/** A stream for a particular event type */
class _Channel {
    final int eventId;
    final StreamController<Event> controller;
    final Stream<Event> stream;    
    bool enabled = false;
    
    _Channel(this.eventId, this.controller, this.stream);
}