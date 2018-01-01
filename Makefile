arch ?= x86_64
kernel := build_$(arch)/kernel.bin
iso := build_$(arch)/os.iso

linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg
assembly_source_file := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_file := $(patsubst src/arch/$(arch)/%.asm, \
    build_$(arch)/arch/$(arch)/%.o, $(assembly_source_file))

.PHONY: all clean run iso

all: $(kernel)

clean:
	@rm -r build_$(arch)

run: $(iso)
	@qemu-system-x86_64 -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p build_$(arch)/isofiles/boot/grub
	@cp $(kernel) build_$(arch)/isofiles/boot/kernel.bin
	@cp $(grub_cfg) build_$(arch)/isofiles/boot/grub
	@grub-mkrescure -o $(iso) build_$(arch)/isofiles 2> /dev/null
	@rm -r build_$(arch)/isofiles

$(kernel): $(assembly_object_file) $(linker_script)
	@ld -n -T $(linker_script) -o $(kernel) $(assembly_object_file)

build_$(arch)/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -felf64 $< -o $@

