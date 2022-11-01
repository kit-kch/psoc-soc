## Compiling the Toolchains

### Compiling the RiscV Compilers for /tools/psoc/rv32i-ilp32-toolchain

```bash
git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
git checkout 2022.08.26
git submodule update
git submodule init
./configure --prefix=/home/nq5949/psoc/rv32i-ilp32-toolchain --with-arch=rv32i --with-abi=ilp32
make -j128
cp -Rv /home/nq5949/psoc/rv32i-ilp32-toolchain /tools/psoc/rv32i-ilp32-toolchain/ install
```


### Compiling OpenOCD for /tools/psoc/openocd

```bash
git clone https://git.code.sf.net/p/openocd/code openocd-code
cd openocd-code
git checkout v0.11.0
./bootstrap
./configure --prefix=/
make -j24
make DESTDIR=/tools/psoc/openocd install
```

## Old information to move into makefiles

### Software
```bash
export PATH=$PATH:/tools/psoc/rv32i-ilp32-toolchain/bin
cd sw/example/hello_world
make exe
```

```bash
export PATH=$PATH:/tools/psoc/rv32i-ilp32-toolchain/bin

git clone https://github.com/stnolting/neorv32.git

git clone git@gitlab.itiv.kit.edu:psoc-admin/psoc_fpga.git
cd psoc_fpga
git checkout neorv32-test
cd ../

git clone git@gitlab.itiv.kit.edu:undla/freertos-neorv32.git neorv-player
```

### Bootloader
```
cd sw/bootloader
make exe
make bootloader
# Copy neorv32_bootloader_image.vhd to psoc_fpga sources
```

### Using New XIP Bootloader
* Open moserial
* Port Settings
  * `/dev/ttyUSB0`
  * Baudrate 19200
  * Data Bits 8
  * Stopp Bits 1
  * Parity None
  * No HW or SW handshake
  * Mode: Read / Write
  * No Echo
* Connect
* Line End: No End
* Programm FPGA with fpga_220520_6eda8f2faad70.bit
  * Contains XIP bootloader
  * Can store program from UART to SPI Flash
  * Can execture from SPI flash
  * ICache enabled, IMem disabled
* Center Button on Zedboard is Reset Button!
* Press any key + Enter to enter boot loader menu
* Press u+enter to upload
* Wait till you see "Awaiting neorv32..."
* The file upload in moserial does not work. In a terminal, do this: `cat neorv32_exe.bin > /dev/ttyUSB0`
* Press e + enter
