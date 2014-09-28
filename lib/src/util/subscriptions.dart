part of seesaw.util;

class Subscriptions {
    final Map<Object, StreamSubscription> _map = new Map();
    
    void add(StreamSubscription subscr, Object key) {
        if(_map.containsKey(key)) {
            throw new Exception("Subscription with key '${key}' already exist");
        }
        _map[key] = subscr;
    }
    
    void cancel(Object key) {
        if(!_map.containsKey(key)) {
            throw new Exception("Subscription with key '${key}' does not exist");
        }
        _map[key].cancel();
        _map.remove(key);
    }
    
    void cancelAll() {
        _map.forEach((key, subscr) => subscr.cancel());
        _map.clear();
    }
}