#!/bin/sh

OPENAL_SRC="${HOME}/git/coreland/openal-ada/"

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

info()
{
  echo "info: $1" 1>&2
}

#
# Copy 'supported'
#

cp "${OPENAL_SRC}/SUPPORTED" "meta/supported" || fatal "could not copy ${OPENAL_SRC}/SUPPORTED"

#
# Make procedure map
#

info "building procedure map"

cat >> src/m_proc_map.ud.tmp <<EOF
(table procedure_map
  (t-row (item "OpenAL C API") (item "Ada equivalent"))
EOF

(
for spec in ${OPENAL_SRC}/openal-*.ads
do
  info "processing $spec"
  ./make-proc_map.lua "$spec" || fatal "could not create proc map for $spec"
done
) | sort -k 3 >> src/m_proc_map.ud.tmp

echo ")" >> src/m_proc_map.ud.tmp

mv src/m_proc_map.ud.tmp src/m_proc_map.ud || fatal "could not replace m_proc_map.ud"
