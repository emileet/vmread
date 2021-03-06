obj-m += vmread.o
vmread-objs := kmem.o
MCFLAGS += -O3
ccflags-y += ${MCFLAGS}
CC += ${MCFLAGS}
KDIR := /lib/modules/$(shell uname -r)/build
ifndef OUT_DIR
	KOUTPUT := $(PWD)/build/vmread_kmod
else
	KOUTPUT := $(OUT_DIR)/vmread_kmod
endif

KOUTPUT_MAKEFILE := $(KOUTPUT)/Makefile

all: $(KOUTPUT_MAKEFILE)
	@echo "$(KOUTPUT)"

	make -C $(KDIR) M=$(KOUTPUT) src=$(PWD) modules
	cp $(KOUTPUT)/vmread.ko $(KOUTPUT)/../vmread.ko

$(KOUTPUT):
	mkdir -p "$@"

$(KOUTPUT_MAKEFILE): $(KOUTPUT)
	touch "$@"

clean:
	make -C $(KDIR) M=$(KOUTPUT) src=$(PWD) clean
	$(shell rm $(KOUTPUT_MAKEFILE))
	rmdir $(KOUTPUT)
