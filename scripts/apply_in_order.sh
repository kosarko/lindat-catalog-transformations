#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
export SHELLOPTS

WD=$(dirname "$(readlink -e "$0")")
export SXPROC="$WD/../sxproc"
export XSLT_DIR="$WD/../xslt"

export proc=xsltproc
if [ -x "$SXPROC" ]; then
  # This is java -jar Saxon*.jar built with graalvm native image
  proc=sxproc
fi

KEEP=false
#default empty string
export PROVIDER_URI=

while getopts ":s:o:p:u:k" opt; do
  case ${opt} in
    s ) SRC_DIR=$(readlink -e "$OPTARG")
      ;;
    o ) OUTDIR=$(readlink -f "$OPTARG")
        export OUTDIR
      ;;
    p ) export PROVIDER="'$OPTARG'"
      ;;
    u ) export PROVIDER_URI="'$OPTARG'"
      ;;
    k ) KEEP=true
        export KEEP
      ;;
    \? ) echo "Usage: cmd -s SRC_DIR -o OUT_DIR -p PROVIDER -u PROVIDER_URI a.xsl b.xsl c.xsl"
         exit 2;
      ;;
  esac
done
shift $((OPTIND -1))

function build_pipe_part {
  # using $xslt $input and $params ie. these must be defined when this is called
  case ${proc} in
    xsltproc )
      echo "xsltproc not implemented" 1>&2
      exit 1
      #cmd="${cmd}xsltproc --stringparam provider_name \"$PROVIDER\" $xslt $input | "
      #cmd=$(echo "$cmd" | sed -e 's/ | $//' | sed -e 's/\(.*\)xsltproc/\1xsltproc -o $OUTDIR\/$id/')
      #xsltproc /home/kosarko/sources/oai-harvest-manager/edm2dspace.xsl $line | \
      #  xsltproc -o /tmp/solr_full/$id --stringparam provider_name CDK /home/kosarko/sources/oai-harvest-manager/dspace2solr.xsl -
      ;;
    sxproc )
      local params_string=""
      for key in "${!params[@]}"; do
        params_string="${params_string} $key=${params[$key]}"
      done
      echo "$SXPROC -xsl:$xslt -s:$input $params_string"
      #
      #find dspace/Patocka_digital/ -type f -name '*.xml' | while read line; do id=$(xmllint --xpath "//dcvalue[@element='pid']/text()" $line); src=$(echo "$line" | sed -e 's/dspace/oai_dc/');  ~/sources/lindat-repository-imports/scripts/wtf -xsl:/home/kosarko/sources/lindat-catalog-transformations/xslt/oai_dc2dspace.xsl -s:$src -o:./manually_tweaked/$line static_provider_name='Patocka digital' record_identifier="$id"  ;done
      #find dspace/Patocka_digital/ -type f -name '*.xml' | while read line; do id=$(xmllint --xpath "//dcvalue[@element='pid']/text()" $line); out=$(echo "$line" | sed -e 's/dspace/solr/');  ~/sources/lindat-repository-imports/scripts/wtf -xsl:/home/kosarko/sources/lindat-catalog-transformations/xslt/dspace2solr.xsl -s:./manually_tweaked/$line -o:./manually_tweaked/$out static_provider_name='Patocka digital' provider_name='Patocka digital' record_identifier="$id"  ;done
      ;;
  esac
}

function process_result {
  local line=$1
  local id
  id=$(basename "$line")
  local cmd=""
  # This is expanded on eval
  # shellcheck disable=SC2016
  local input='$line'
  declare -A params=( [provider_name]="$PROVIDER" [static_provider_name]="$PROVIDER" )
  if [ -n "$PROVIDER_URI" ]; then
          params[provider_uri]="$PROVIDER_URI"
  fi

  if [ -e "${line/%xml/txt}" ]; then
    params[record_identifier]=$(<${line/%xml/txt})
  else
    echo "warn: using fake record_identifier"
    params[record_identifier]="FAKE_ID_$id"
  fi

  for xsl in $TRANSFORMATIONS; do
    local xslt
    local pipe_part
    xslt=$(find "$XSLT_DIR" -type f -name "${xsl}*" | LC_ALL=C sort | head -n 1)
    if [ -z "$xslt" ]; then
	    echo "warn ${xsl}\* does not exist" >&2
	    exit 1
    fi
    # this is using $xslt $input and $params
    pipe_part=$(build_pipe_part)
    cmd="${cmd}${pipe_part} | "
    input="-"
  done
  cmd=$(echo "$cmd" | sed -e 's/ | $//' | sed -e "s#\(.*\)$proc#\1$proc \> $OUTDIR/$id#")
  eval "$cmd"
}

function extract_raw_single {
        local line=$1
        local bn
        bn=$(basename "$line")
        xmllint --push --xpath '//*[local-name()="record"]/*[local-name()="header"]/*[local-name()="identifier"]/text()' "$line" > "${bn/%xml/txt}"
        #not a good idea, fcks up namespaces
        #xmllint --push --xpath '//*[local-name()="metadata"]/node()' "$line" > "$bn"
        #$SXPROC -xsl:"$XSLT_DIR/extract_raw_single.xsl" -s:"$line" > "$bn"
        #prob faster
        xsltproc -o "$bn" "$XSLT_DIR/extract_raw_single.xsl" "$line"
}

export -f build_pipe_part process_result extract_raw_single

mkdir -p "$OUTDIR"

CPUS=$(nproc)
(( CPUS++ )) || true

if [[ "$1" =~ ^extract(\.xsl)?$ ]]; then
        mkdir -p "$OUTDIR"/split
        pushd "$OUTDIR"/split >/dev/null
        xslt="$XSLT_DIR/extract.xsl"
        find $SRC_DIR -type f -exec $SXPROC -xsl:$xslt -s:{} >/dev/null \;
        unset xslt
        popd >/dev/null
        shift
        SRC_DIR="$OUTDIR"/split
elif [[ "$1" =~ ^extract_raw_single(\.xsl)?$ ]]; then
        mkdir -p "$OUTDIR"/split
        pushd "$OUTDIR"/split >/dev/null
        find $SRC_DIR -type f -print0 | xargs -n 1 -I filename -P "$CPUS" --null  bash -c 'extract_raw_single filename' _ 
        popd >/dev/null
        shift
        SRC_DIR="$OUTDIR"/split
fi

# If this was an array it couldn't be exported
# shellcheck disable=SC2124
export TRANSFORMATIONS="$@"

#find ~/sources/oai-harvest-manager/test-workspace/results/edm/CDK/ -type f |  xargs -n 1 -I filename -P 0 bash -c 'process_result filename' _ 2>&1 | grep -i warn
find "$SRC_DIR" -type f -iname '*.xml' -print0 | xargs -n 1 -I filename -P "$CPUS" --null bash -c 'process_result filename' _ 2>&1 | \
 { grep -i warn || :; }

if ! $KEEP; then
    rm -rf "$OUTDIR"/split
fi
