#!/bin/sh
# This scripts generates gpr files and creates symbolic links
# Expected inputs: component, destdir, python-includes
# component one of (gmp, iconv, readline, syslog, python)

name="$1"
destdir="$2"
python_includes="$3"
soversion="$4"
python3_linking="\"$5\""

case "$name" in
	"gmp")	
		component=GMP
		component_upper=GMP
		component_lower="gmp"
		linker_opts='"-lgmp"'
		;;
	"iconv")	
		component=Iconv
		component_upper=ICONV
		component_lower="iconv"
		linker_opts='"-liconv"'
		;;
	"readline")
		component=Readline
		component_upper=READLINE
		component_lower="readline"
		linker_opts='"-lreadline"'
		;;
	"syslog")
		component=Syslog
		component_upper=SYSLOG
		component_lower="syslog"
		linker_opts=
		;;
	"python3")
		name=python3
		component=Python
		component_upper=PYTHON
		component_lower="python3"
		linker_opts="${python3_linking}"
		;;
	"zlib")
		component=Zlib
		component_upper=ZLIB
		component_lower="zlib"
		linker_opts="-lz"
		;;
	*)
		echo "Illegal component $component"
		exit 1
		;;
esac

dname=$(dirname "$0")
filesdir=$(cd "$dname" && pwd -P)
target="gnatcoll_${component_lower}.gpr"
major="${soversion%.[0-9]}"

case "$name" in
	python|python3)
		pyhandle="s|%%PYTHON_ON%%||; s|%%PYTHON_INCLUDE%%|${python_includes}|"	
		;;
	*)
		pyhandle="/%%PYTHON_ON%%/d"
		;;
esac

case "$name" in
	"iconv")
		iconvhandle="s|%%ICONV_ON%%||"
		;;
	*)
		iconvhandle="/%%ICONV_ON%%/d"
		;;
esac
	
sed \
 -e "s|%%COMPONENT%%|${component}|"\
 -e "s|%%COMPONENT_U%%|${component_upper}|"\
 -e "s|%%COMPONENT_L%%|${component_lower}|"\
 -e "s|%%NAME%%|${name}|"\
 -e "s|%%LINKER_OPTS%%|${linker_opts}|"\
 -e "${pyhandle}"\
 -e "${iconvhandle}"\
 "${filesdir}/gnatcoll_template.gpr" > "${destdir}/share/gpr/${target}"

ln -s "libgnatcoll_${name}.so.${major}" "${destdir}/lib/libgnatcoll_${name}.so"
ln -s "libgnatcoll_${name}.so.${soversion}" "${destdir}/lib/libgnatcoll_${name}.so.${major}"
ln -s "../libgnatcoll_${name}.so.${soversion}" \
	"${destdir}/lib/gnatcoll_${component_lower}.relocatable/libgnatcoll_${name}.so"
ln -s "../libgnatcoll_${name}.so.${soversion}" \
	"${destdir}/lib/gnatcoll_${component_lower}.relocatable/libgnatcoll_${name}.so.${major}"
ln -s "../libgnatcoll_${name}.so.${soversion}" \
	"${destdir}/lib/gnatcoll_${component_lower}.relocatable/libgnatcoll_${name}.so.${soversion}"
