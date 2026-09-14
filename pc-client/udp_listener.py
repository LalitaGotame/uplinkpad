"""
Uplink Pad — Phase 2 UDP skeleton.

Listens for input packets from the Flutter app and prints them to the
console. No ViGEm/vgamepad integration yet (that's Phase 3) — this
script only proves packets are arriving from the phone intact.

Wire format: shared/protocol/packet_format.md. Stdlib only, no
dependencies required for this phase.

Usage:
    python udp_listener.py

Then set NetworkConfig.pcIpAddress in the Flutter app
(mobile/lib/config/network_config.dart) to this machine's LAN IP
(`ipconfig`, look for "IPv4 Address" under your Wi-Fi adapter).
"""

import json
import socket

HOST = "0.0.0.0"  # listen on all local interfaces
PORT = 9000  # must match NetworkConfig.pcPort in the Flutter app

BUTTON_ORDER = ("up", "down", "left", "right", "a", "b", "x", "y")


def format_packet(packet: dict) -> str:
    buttons = packet.get("buttons", {})
    pressed = [name for name in BUTTON_ORDER if buttons.get(name)]
    stick = packet.get("stick", {})
    stick_x = stick.get("x", 0.0)
    stick_y = stick.get("y", 0.0)
    return (
        f"seq={packet.get('seq')!s:<6} "
        f"buttons={','.join(pressed) if pressed else '-':<20} "
        f"stick=({stick_x:+.2f}, {stick_y:+.2f})"
    )


def main() -> None:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((HOST, PORT))
    print(f"Listening for Uplink Pad packets on UDP {HOST}:{PORT}")
    print("Press Ctrl+C to stop.\n")

    last_seq = None
    try:
        while True:
            data, addr = sock.recvfrom(4096)

            try:
                packet = json.loads(data.decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError) as exc:
                print(f"[{addr[0]}:{addr[1]}] malformed packet ({exc}): {data!r}")
                continue

            seq = packet.get("seq")
            gap_note = ""
            if isinstance(seq, int) and isinstance(last_seq, int) and seq != last_seq + 1:
                gap_note = f"  <- gap, expected seq={last_seq + 1}"
            if isinstance(seq, int):
                last_seq = seq

            print(f"[{addr[0]}:{addr[1]}] {format_packet(packet)}{gap_note}")
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        sock.close()


if __name__ == "__main__":
    main()
