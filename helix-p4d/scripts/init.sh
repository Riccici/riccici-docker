#!/bin/bash

# Setup directories
echo "Setting up directories..."
mkdir -p "$P4ROOT"
mkdir -p "$P4DEPOTS"
mkdir -p "$P4CKP"

# Restore checkpoint if symlink latest exists
if [ -L "$P4CKP/latest" ]; then
    echo "Restoring checkpoint..."
	restore.sh
	rm "$P4CKP/latest"
else
	echo "Create empty or start existing server..."
	setup.sh
fi

# Set key environment variables
p4 configure set $P4NAME#server.depot.root=$P4DEPOTS
p4 configure set $P4NAME#journalPrefix=$P4CKP/$JNL_PREFIX

# Start Perforce Server
p4dctl start -t p4d "$NAME"

p4 login <<EOF
$P4PASSWD
EOF

echo "Perforce Server starting..."
until p4 info -s 2> /dev/null; do sleep 1; done
echo "Perforce Server is running."

graceful_shutdown() {
    echo "Perforce Server stopping..."
    p4dctl stop -t p4d "$NAME"
    until ! p4 info -s 2> /dev/null; do sleep 1; done
    echo "Perforce Server stopped."
    sleep 1
    exit 0
}

trap graceful_shutdown HUP INT QUIT TERM

tail -f $P4ROOT/logs/log & wait
