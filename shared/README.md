# shared

Wire protocol shared between `mobile/` and `pc-client/`.

- [`protocol/packet_format.md`](protocol/packet_format.md) — the UDP
  JSON packet schema (button/axis ids, sequence numbers). Both sides
  implement this schema independently (Dart in `mobile/`, Python in
  `pc-client/`) — there's no shared code here yet, just the spec both
  implementations must match.
