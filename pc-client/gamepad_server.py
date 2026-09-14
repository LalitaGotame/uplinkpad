"""
Uplink Pad -- Phase 3: UDP receiver that drives a virtual Xbox 360
controller via ViGEmBus (through the `vgamepad` wrapper).

Requires:
  - ViGEmBus driver installed (see docs/PROJECT_BRIEF.md).
  - `pip install -r requirements.txt`.

This creates one virtual controller for as long as the script runs.
Test it with Windows' built-in panel before trying a real game:
  Win+R -> joy.cpl -> select the Xbox 360 controller -> Properties ->
  Test tab -> press buttons / move the stick on the phone and watch
  it react there.

Wire format: shared/protocol/packet_format.md.
"""

import json
import socket
import sys

try:
    import vgamepad as vg
except ImportError:
    print(
        "vgamepad not installed. Run: pip install -r requirements.txt",
        file=sys.stderr,
    )
    raise

HOST = "0.0.0.0"  # listen on all local interfaces
PORT = 9000  # must match NetworkConfig.pcPort in the Flutter app

# Packet button id (shared/protocol/packet_format.md) -> vgamepad XUSB flag.
BUTTON_MAP = {
    "a": vg.XUSB_BUTTON.XUSB_GAMEPAD_A,
    "b": vg.XUSB_BUTTON.XUSB_GAMEPAD_B,
    "x": vg.XUSB_BUTTON.XUSB_GAMEPAD_X,
    "y": vg.XUSB_BUTTON.XUSB_GAMEPAD_Y,
    "up": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_UP,
    "down": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_DOWN,
    "left": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_LEFT,
    "right": vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_RIGHT,
}


def clamp(value: float, low: float = -1.0, high: float = 1.0) -> float:
    return max(low, min(high, value))


def apply_packet(gamepad: "vg.VX360Gamepad", packet: dict) -> None:
    buttons = packet.get("buttons", {})
    for name, flag in BUTTON_MAP.items():
        if buttons.get(name):
            gamepad.press_button(button=flag)
        else:
            gamepad.release_button(button=flag)

    stick = packet.get("stick", {})
    stick_x = clamp(float(stick.get("x", 0.0)))
    # Packet convention is screen-style (+y = down, per
    # shared/protocol/packet_format.md); XInput's convention is
    # +y = up, so invert before handing it to vgamepad.
    stick_y = clamp(-float(stick.get("y", 0.0)))
    gamepad.left_joystick_float(x_value_float=stick_x, y_value_float=stick_y)

    gamepad.update()


def main() -> None:
    gamepad = vg.VX360Gamepad()
    print("Virtual Xbox 360 controller created.")
    print("Open Windows' 'Set up USB game controllers' panel (Win+R -> joy.cpl)")
    print("and confirm button presses / stick movement register there")
    print("before trying a real game.\n")

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
            # Drop stale/out-of-order packets: UDP can reorder them,
            # and applying an old frame after a newer one already
            # landed would make input rubber-band. A large backwards
            # jump is treated as sequence wraparound, not staleness.
            if isinstance(seq, int) and isinstance(last_seq, int):
                if seq <= last_seq and (last_seq - seq) < 2**31:
                    print(f"[{addr[0]}:{addr[1]}] dropping stale seq={seq} (last={last_seq})")
                    continue
            if isinstance(seq, int):
                last_seq = seq

            apply_packet(gamepad, packet)
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        sock.close()


if __name__ == "__main__":
    main()
