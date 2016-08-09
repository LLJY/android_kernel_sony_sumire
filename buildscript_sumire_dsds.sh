make mrproper

export USE_CCACHE=1
export CCACHE_DIR=~/.ccache-linaro

export ARCH=arm64
export PATH=../mdalexca-aarch64-linux-android-4.9-kernel-linaro/bin:$PATH
export CROSS_COMPILE=aarch64-linux-android-
make sumire-dsds-RyTek_defconfig |& tee log_dsds.txt
make -j$(grep -c ^processor /proc/cpuinfo) |& tee -a log_dsds.txt

echo "checking for compiled kernel..."
if [ -f arch/arm64/boot/Image.gz-dtb ]
then

	echo "DONE"
	rm -f ../final_files/boot_E6683.img

	../final_files/mkqcdtbootimg --kernel arch/arm64/boot/Image.gz-dtb --ramdisk ../final_files/newrd.gz --cmdline "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 boot_cpus=0-5 dwc3_msm.prop_chg_detect=Y coherent_pool=2M dwc3_msm.hvdcp_max_current=1500 androidboot.selinux=permissive enforcing=0" --base 0x00000000 --pagesize 4096 --ramdisk_offset 0x02000000 --tags_offset 0x01E00000 --output ../final_files/boot_E6683.img

	make mrproper

	cd ../final_files/

	if [ -e boot_E6683.img ]
	then
		cp boot_E6683.img boot.img
		zip RyTek_Kernel.zip boot.img
		rm -f boot.img
	fi
fi
