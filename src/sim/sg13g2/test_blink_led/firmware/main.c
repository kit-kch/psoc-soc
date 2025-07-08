#include <neorv32.h>

#include "../../../../../ext/psoc_demo_sw/common/psoc.h"

int main() {

  // Pins are GPIO by default
  // Configure as output
  IOMUX_REG_DIR = (0b11 << 20);

  // Init port to 0
  neorv32_gpio_port_set(0);


  neorv32_gpio_pin_set(20, 1);
  while (1) {
    neorv32_gpio_pin_toggle(21);
  }

  // this should never be reached
  return 0;
}