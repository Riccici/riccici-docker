
if [ ! -z "$TYPEMAP_URL" ]; then
    wget $TYPEMAP_URL -q -O - | p4 typemap -i
else
    echo "warnning: No typemap source specified, please set TYPEMAP_URL environment variable!!!!!!"
fi