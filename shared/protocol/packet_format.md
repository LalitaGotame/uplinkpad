# Uplink Pad — Input Packet Format (v1)

Phase 2 skeleton. One UDP datagram = one JSON object = one frame of
controller input, sent phone -> PC. There is no ack, no handshake, and
no encryption yet — that's later phases (5: pairing/auth, 9: hardening).

## Transport

- UDP, not TCP — a dropped or late packet should be discarded, not
  retransmitted or allowed to block newer input (see project brief).
- Default port: **9000**. Must match on both ends
  (`mobile/lib/config/network_config.dart` and `pc-client/udp_listener.py`).
- One packet per UDP datagram — UDP preserves message boundaries, so no
  length-prefixing or framing is needed.
- Encoding: UTF-8 JSON text.

## Schema

```json
{
  "seq": 42,
  "buttons": {
    "a": false,
    "b": false,
    "x": false,
    "y": false,
    "up": false,
    "down": false,
    "left": false,
    "right": false
  },
  "stick": { "x": 0.0, "y": 0.0 }
}
```

| Field           | Type            | Notes                                                                 |
|-----------------|-----------------|------------------------------------------------------------------------|
| `seq`           | integer         | Increments by 1 per packet sent, starting at 0. Used by the receiver to detect drops/reordering — never used to request retransmission. |
| `buttons.*`     | bool            | Fixed set of 8 keys, always all present. `up`/`down`/`left`/`right` are the D-pad (mutually exclusive — at most one is `true`); `a`/`b`/`x`/`y` are the face buttons (independent). |
| `stick.x`       | float, `-1..1`  | Normalized horizontal deflection. `-1` = full left, `1` = full right. |
| `stick.y`       | float, `-1..1`  | Normalized vertical deflection, **screen convention: positive = down** (matches raw touch-drag delta), `-1` = full up. |

Field order is not guaranteed and not significant — parse by key, not
position.

## Receiver behavior (Phase 2 skeleton)

The Phase 2 PC listener just decodes and prints each packet. Sequence
gaps are noted but not acted on yet — actually dropping stale packets
based on `seq` becomes relevant once packets drive a virtual controller
in Phase 3.
