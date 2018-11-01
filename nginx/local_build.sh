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
done


