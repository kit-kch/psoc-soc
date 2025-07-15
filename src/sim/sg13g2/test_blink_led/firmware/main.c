#include <neorv32.h>

#define IOMUX_REG_DIR *(volatile uint32_t*)0xffd10000
#define PAD20 20
#define GPIO20 PAD20

int main() {

  // Pins are GPIO by default. Configure as output
  IOMUX_REG_DIR = (0b11 << GPIO20);

  // Init port to 0
  neorv32_gpio_port_set(0);


  neorv32_gpio_pin_set(20, 1);
  while (1) {
    neorv32_gpio_pin_toggle(21);
  }

  // this should never be reached
  return 0;
}