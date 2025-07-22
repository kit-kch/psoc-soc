#include <neorv32.h>
#include <stdbool.h>

// IOMUX Registers
#define IOMUX_REG_DIR *(volatile uint32_t*)0xffd10000
#define IOMUX_REG_FUNC *(volatile uint32_t*)0xffd10004

#define PAD08 8
#define PAD09 9
#define PAD20 20
#define PAD21 21

#define GPIO20 PAD20
#define GPIO21 PAD21
#define PSOC_LED2    GPIO20
#define PSOC_LED3    GPIO21

#define PIN_UART0_TX  PAD08
#define PIN_UART0_RX  PAD09
#define FUNC_UART0    ((1 << PIN_UART0_TX) | (1 << PIN_UART0_RX))

static int memtest(void* start, void* end)
{
    // Testing whether we can set / clear all bits in 32 bit writes
    volatile uint32_t* ptr = (volatile uint32_t*)start;
    while ((void*)ptr < end)
    {
        *ptr = 0xFFFFFFFF;
        if (*ptr != 0xFFFFFFFF)
            return -1;
        *ptr = 0;
        if (*ptr != 0)
            return -2;
        ptr += 100;
    }

    // Testing whether we can write all locations independently
    ptr = (volatile uint32_t*)start;
    uint32_t i = 0;
    while ((void*)ptr < end)
    {
        *ptr = i++;
        ptr++;
    }
    ptr = (volatile uint32_t*)start;
    i = 0;
    while ((void*)ptr < end)
    {
        if (*ptr != i++)
            return -3;
        ptr++;
    }

    // Test 1,2,4 byte reads and writes
    ptr = (volatile uint32_t*)start;
    while ((void*)ptr < end)
    {
        // clear it
        *ptr = 0;
        if (*ptr != 0)
            return -4;

        volatile uint8_t* ptr8 = (volatile uint8_t*)ptr;
        volatile uint16_t* ptr16 = (volatile uint16_t*)ptr;

        // Single byte 0 write, 1 byte, 2 byte, 4 byte read
        ptr8[0] = 0xFF;
        if (ptr8[0] != 0xFF)
            return -5;
        if (ptr8[1] != 0)
            return -6;
        if (ptr8[2] != 0)
            return -7;
        if (ptr8[3] != 0)
            return -8;
        if (ptr16[0] != 0xFF)
            return -9;
        if (ptr16[1] != 0)
            return -10;
        if (ptr[0] != 0xFF)
            return -11;

        // Single byte 1 write, 1 byte, 2 byte, 4 byte read
        ptr8[0] = 0;
        if (ptr8[0] != 0x00)
            return -12;

        ptr8[1] = 0xFF;
        if (ptr8[0] != 0)
            return -13;
        if (ptr8[1] != 0xFF)
            return -14;
        if (ptr8[2] != 0)
            return -15;
        if (ptr8[3] != 0)
            return -16;
        if (ptr16[0] != 0xFF00)
            return -17;
        if (ptr16[1] != 0)
            return -18;
        if (ptr[0] != 0xFF00)
            return -19;

        // Single byte 2 write, 1 byte, 2 byte, 4 byte read
        ptr8[1] = 0;
        if (ptr8[1] != 0x00)
            return -20;

        ptr8[2] = 0xFF;
        if (ptr8[0] != 0)
            return -21;
        if (ptr8[1] != 0)
            return -22;
        if (ptr8[2] != 0xFF)
            return -23;
        if (ptr8[3] != 0)
            return -24;
        if (ptr16[0] != 0)
            return -25;
        if (ptr16[1] != 0xFF)
            return -26;
        if (ptr[0] != 0xFF0000)
            return -27;

        // Single byte 3 write, 1 byte, 2 byte, 4 byte read
        ptr8[2] = 0;
        if (ptr8[2] != 0x00)
            return -27;

        ptr8[3] = 0xFF;
        if (ptr8[0] != 0)
            return -28;
        if (ptr8[1] != 0)
            return -29;
        if (ptr8[2] != 0)
            return -30;
        if (ptr8[3] != 0xFF)
            return -31;
        if (ptr16[0] != 0)
            return -32;
        if (ptr16[1] != 0xFF00)
            return -33;
        if (ptr[0] != 0xFF000000)
            return -34;

        ptr[0] = 0;
        // Two byte 0 write, 1 byte, 2 byte, 4 byte read
        ptr16[0] = 0xFFFF;
        if (ptr8[0] != 0xFF)
            return -35;
        if (ptr8[1] != 0xFF)
            return -36;
        if (ptr8[2] != 0)
            return -37;
        if (ptr8[3] != 0)
            return -38;
        if (ptr16[0] != 0xFFFF)
            return -39;
        if (ptr16[1] != 0)
            return -40;
        if (ptr[0] != 0xFFFF)
            return -41;

        // Two byte 1 write, 1 byte, 2 byte, 4 byte read
        ptr16[0] = 0;
        if (ptr16[0] != 0x00)
            return -42;

        ptr16[1] = 0xFFFF;
        if (ptr8[0] != 0)
            return -43;
        if (ptr8[1] != 0)
            return -44;
        if (ptr8[2] != 0xFF)
            return -45;
        if (ptr8[3] != 0xFF)
            return -46;
        if (ptr16[0] != 0)
            return -47;
        if (ptr16[1] != 0xFFFF)
            return -48;
        if (ptr[0] != 0xFFFF0000)
            return -49;

        // Four byte write, 1 byte, 2 byte, 4 byte read
        ptr[0] = 0;
        if (ptr[0] != 0x00)
            return -50;

        ptr[0] = 0xFFFFFFFF;
        if (ptr8[0] != 0xFF)
            return -51;
        if (ptr8[1] != 0xFF)
            return -52;
        if (ptr8[2] != 0xFF)
            return -53;
        if (ptr8[3] != 0xFF)
            return -54;
        if (ptr16[0] != 0xFFFF)
            return -55;
        if (ptr16[1] != 0xFFFF)
            return -56;
        if (ptr[0] != 0xFFFFFFFF)
            return -57;


        ptr += 100;
    }
    return 0;
}

int main()
{
    IOMUX_REG_DIR = (1 << PSOC_LED2) | (1 << PSOC_LED3);
    neorv32_gpio_port_set(0);

    uint32_t dmem = neorv32_sysinfo_get_dmemsize();
    void* dmem_start = (void*)0x80000000;
    void* dmem_end = dmem_start + dmem;
    // Stack grows down from SRAM end. Leave it alone
    void* dmem_test_end = dmem_end - 256;

    neorv32_gpio_pin_set(PSOC_LED2, 1);
    int result = memtest(dmem_start, dmem_test_end);
    if (result == 0)
        neorv32_gpio_pin_set(PSOC_LED3, 1);

    // Do this after setting the LED output so we don't have to simulate it
    IOMUX_REG_FUNC = FUNC_UART0;
    neorv32_uart0_setup(115200, 0);
    neorv32_uart0_printf("Memory Size: %d (0x%p to 0x%p)\n", dmem, dmem_start, dmem_end);
    neorv32_uart0_printf("Tested from: 0x%p to 0x%p\n", dmem_start, dmem_test_end);
    neorv32_uart0_printf("Test Result: %d\n", result);
    while (true) {}
    return 0;
}
