#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
export SHELLOPTS

WD=$(dirname "$(readlink -e "$0")")
export XSLT_DIR="$WD/../xslt"

while getopts ":s:o:p:" opt; do
	case ${opt} in
		s ) SRC_DIR=$(readlink -e "$OPTARG")
			;;
		o ) export OUTDIR=$(readlink -f "$OPTARG")
			;;
		p ) export PROVIDER="'$OPTARG'"
			;;
		\? ) echo "Usage: cmd -s SRC_DIR -o OUT_DIR -p PROVIDER a.xsl b.xsl c.xsl"
			;;
	esac
done
shift $((OPTIND -1))

export TRANSFORMATIONS="$@"

function process_result {
	local line=$1
	local id=`basename $line`
	local cmd=""
	local input='$line'
	for xsl in $TRANSFORMATIONS; do
		local xslt=$(find $XSLT_DIR -type f -name "${xsl}*" | head -n 1)
		cmd="${cmd}xsltproc --stringparam provider_name "$PROVIDER" $xslt $input | "
		input="-"
	done
	cmd=$(echo "$cmd" | sed -e 's/ | $//' | sed -e 's/\(.*\)xsltproc/\1xsltproc -o $OUTDIR\/$id/')
	eval "$cmd"
	#xsltproc /home/kosarko/sources/oai-harvest-manager/edm2dspace.xsl $line | \
	#	xsltproc -o /tmp/solr_full/$id --stringparam provider_name CDK /home/kosarko/sources/oai-harvest-manager/dspace2solr.xsl -
}

export -f process_result

mkdir -p "$OUTDIR"

#find ~/sources/oai-harvest-manager/test-workspace/results/edm/CDK/ -type f |  xargs -n 1 -I filename -P 0 bash -c 'process_result filename' _ 2>&1 | grep -i warn
find "$SRC_DIR" -type f | xargs -n 1 -I filename -P 0 bash -c 'process_result filename' _ 2>&1 | grep -i warn


#
#find dspace/Patocka_digital/ -type f -name '*.xml' | while read line; do id=$(xmllint --xpath "//dcvalue[@element='pid']/text()" $line); src=$(echo "$line" | sed -e 's/dspace/oai_dc/');  ~/sources/lindat-repository-imports/scripts/wtf -xsl:/home/kosarko/sources/lindat-catalog-transformations/xslt/oai_dc2dspace.xsl -s:$src -o:./manually_tweaked/$line static_provider_name='Patocka digital' record_identifier="$id"  ;done
#find dspace/Patocka_digital/ -type f -name '*.xml' | while read line; do id=$(xmllint --xpath "//dcvalue[@element='pid']/text()" $line); out=$(echo "$line" | sed -e 's/dspace/solr/');  ~/sources/lindat-repository-imports/scripts/wtf -xsl:/home/kosarko/sources/lindat-catalog-transformations/xslt/dspace2solr.xsl -s:./manually_tweaked/$line -o:./manually_tweaked/$out static_provider_name='Patocka digital' provider_name='Patocka digital' record_identifier="$id"  ;done
