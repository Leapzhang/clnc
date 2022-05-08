echo '\u8bf7\u9009\u62e9\u9ed8\u8ba4\u6a21\u5f0f\x28\x51\x51\u7fa4\uff1a\x31\x35\x36\x34\x39\x37\x39\x38\x32\x29\x3a  \x31\x2e \u767e\u5ea6\u76f4\u8fde\x28\u9ed8\u8ba4\u7535\u4fe1\x2f\u8054\u901a\x29  \x32\x2e \u767e\u5ea6\u76f4\u8fde\uff08\u79fb\u52a8\uff09  \x33\x2e \u963f\u91cc\x55\x43\u76f4\u8fde  \x34\x2e \u738b\u5361\u76f4\u8fde\uff08\u8054\u901a\uff09  \x35\x2e \u9489\u9489\u76f4\u8fde\uff08\u7535\u4fe1\uff09  \x36\x2e \u5c71\u4e1c\u505c\u673a  \x37\x2e \u5317\u4eac\u505c\u673a'
read defMode
install_dir='/data/clnc'
rm -rf "$install_dir"
mkdir "$install_dir"
cd "$install_dir"
curl -o clnc.zip https://raw.githubusercontent.com/Leapzhang/clnc/main/clncScript/clnc1.0.2_4gwifi.zip || exec echo '下载clnc脚本失败'
curl -O https://raw.githubusercontent.com/Leapzhang/clnc/main/clncScript/busybox || exec echo '下载busybox程序失败'
chmod 0777 busybox
./busybox unzip clnc.zip
chmod -R 0777 "$install_dir"
case "$defMode" in
	2)
		mode='clnc_yd';;
	3)
		mode='clnc_uc';;
	4)
		mode='clnc_wk';;
	5)
		mode='clnc_dd';;
	6)
		mode='clnc_sd';;	
	7)
		mode='clnc_bj';;		
	*)
		mode='clnc_bd';;
esac
config=`cat config.ini`
cat >config.ini <<EOF
${config/modeName=\'clnc_bd\'/modeName=\'$mode\'}
EOF
./start.sh
echo "clnc脚本已安装在/data/clnc，启动执行/data/clnc/start.sh"
echo "是否设置开机自启[y/n]"
read isAutoStart
[ "$isAutoStart" = 'y' -o "$isAutoStart" = 'Y' ] && {
	curl -O https://gitee.com/leapzhang/clnc/raw/master/clncScript/autoStart.sh || exec echo '下载自启脚本失败'
	sh autoStart.sh | grep -q '添加' || sh autoStart.sh
	echo "$install_dir/start.sh" >/data/ZQ/clnc.sh
	echo '已设置脚本开机自启'
	echo "setprop service.adb.tcp.port 5555;start adbd" >/data/ZQ/adbd.sh
	echo '已设置adb服务开机自启'
}
