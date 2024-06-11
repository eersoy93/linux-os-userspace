build: init.c
	mkdir -p rootfs/bin rootfs/lib rootfs/lib64
	gcc -o rootfs/bin/init init.c
	chmod +x rootfs/bin/init
	cp /lib/x86_64-linux-gnu/libc.so.6 rootfs/lib/
	cp /lib64/ld-linux-x86-64.so.2 rootfs/lib64/
	cd rootfs && find . | cpio -o --format=newc > ../rootfs.cpio

run: build
	sudo qemu-system-x86_64 -kernel /boot/vmlinuz-$(shell uname -r) -initrd ./rootfs.cpio -append "root=/dev/ram rdinit=/bin/init" -m 512

clean:
	rm -rf rootfs rootfs.cpio
	
