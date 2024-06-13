ROOTFS_DIR = rootfs
ROOTFS_BIN_DIR = ${ROOTFS_DIR}/bin
ROOTFS_LIB_DIR = ${ROOTFS_DIR}/lib
ROOTFS_LIB64_DIR = ${ROOTFS_DIR}/lib64

SOURCE_FILES = $(wildcard src/*.c)
TARGET = ${ROOTFS_BIN_DIR}/init
FS_IMAGE = rootfs.cpio

SYSTEM_LIBS = /lib/x86_64-linux-gnu/libc.so.6
SYSTEM_LIBS64 = /lib64/ld-linux-x86-64.so.2
SYSTEM_KERNEL = /boot/vmlinuz-$(shell uname -r)

build: ${SOURCE_FILES}
	mkdir -p ${ROOTFS_DIR}/bin ${ROOTFS_DIR}/lib ${ROOTFS_DIR}/lib64
	gcc -o ${TARGET} ${SOURCE_FILES}
	chmod +x ${TARGET}
	cp ${SYSTEM_LIBS} ${ROOTFS_LIB_DIR}/
	cp ${SYSTEM_LIBS64} ${ROOTFS_LIB64_DIR}/
	cd ${ROOTFS_DIR} && find . | cpio -o --format=newc > ../${FS_IMAGE}

run: build
	sudo qemu-system-x86_64 -kernel ${SYSTEM_KERNEL} -initrd ${FS_IMAGE} -append "root=/dev/ram rdinit=/bin/init" -m 512

clean:
	rm -rf ${ROOTFS_DIR} ${TARGET} ${FS_IMAGE}
	
