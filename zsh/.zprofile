if command -v ksshaskpass > /dev/null; then
    export SSH_ASKPASS=/usr/bin/ksshaskpass
fi

# Prefer using the askpass program over prompting in the terminal.
export SSH_ASKPASS_REQUIRE=prefer

