#!/bin/sh

set -e

base_dir=$(cd `dirname $0` && pwd)
output_dir=$base_dir/output
tmp_dir=$base_dir/.tmp
third_dir=$base_dir/third

nginx_prefix=".."
versions=(
    '1.8.0'
)
depends_libs=(
    pcre-8.38
    zlib-1.2.11
    openssl-1.0.2p
)
with_modules=(
    http_ssl_module
    http_flv_module
    http_mp4_module
)

rm -rf $output_dir
mkdir $output_dir

for ver in ${versions[*]}; do
	rm -rf $tmp_dir
    	mkdir $tmp_dir
	for dep_lib in ${depends_libs[*]}; do
		tar zxf ${third_dir}/$dep_lib.tar.gz -C ${tmp_dir}
	done
	tar zxf ${base_dir}/$ver/nginx-$ver.tar.gz -C ${tmp_dir}
	build_dir=$tmp_dir/build
	mkdir $build_dir
	cd ${tmp_dir}/nginx-$ver
	compile_log="$tmp_dir/compile.log"
	if [[ -f $compile_log ]]; then
   		 rm $compile_log
	fi
	echo "Comiling nginx....."
	cat > $tmp_dir/build_nginx.sh <<SCRIPT
		./configure \
		 --prefix=$nginx_prefix \
		 --builddir=$build_dir \
		 --user=work \
		 --group=work \
		 --with-pcre=${tmp_dir}/pcre-8.38 \
		 --with-zlib=${tmp_dir}/zlib-1.2.11 \
		 --with-http_ssl_module \
		 --with-openssl=${tmp_dir}/openssl-1.0.2p \
		 --with-http_flv_module \
		 --with-http_mp4_module \
		 --with-cc=/usr/bin/gcc
	make
	make install
SCRIPT
	sh ${tmp_dir}/build_nginx.sh > $compile_log

	cp -r ${tmp_dir}/sbin $output_dir/
	mkdir $output_dir/conf
	cp ${base_dir}/conf/* $output_dir/conf/
	mkdir $output_dir/logs
	touch $output_dir/logs/error.log
	touch $output_dir/logs/access.log
	mkdir $output_dir/var
	touch $output_dir/var/nginx.pid
done


