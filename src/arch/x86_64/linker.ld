ENTRY(start)

SECTIONS {
    . = 1M;

    .boot :
    {
        /* ensure that multiboot header is at the beginning so that GRUB can find it */
        *(.multiboot_header)
    }

    .text :
    {
        *(.text)
    }
}
