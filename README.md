# cmbox

Bare-metal firmware for the STM32F401CCU6 (CMSIS, CMake, Ninja, OpenOCD).

## Dependencies

```sh
sudo apt install gcc-arm-none-eabi libnewlib-arm-none-eabi cmake ninja-build openocd gdb-multiarch
git submodule update --init --depth 1    # CMSIS
```

VS Code extensions: Remote - WSL, C/C++, CMake Tools, Cortex-Debug.

On WSL, attach the ST-Link with `usbipd attach --wsl --busid <id>`. If OpenOCD reports
`LIBUSB_ERROR_ACCESS`, run `sudo udevadm control --reload-rules && sudo udevadm trigger`.

## Usage

```sh
cmake --preset debug                          # configure
cmake --build --preset debug                  # build
cmake --build --preset debug --target flash   # flash
```

Use `release` instead of `debug` for an optimized build.

Debug from the command line:

```sh
openocd -f openocd.cfg
gdb-multiarch build/debug/cmbox.elf -ex "target extended-remote :3333" -ex "monitor reset halt" -ex "load"
```

In VS Code (opened from WSL with `code .`):

- `Ctrl+Shift+B` builds
- *Run Task → flash* flashes
- `F5` builds, flashes and debugs
