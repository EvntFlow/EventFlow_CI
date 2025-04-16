#!/bin/bash -e

for (( i=1; i<=$#; i++)); do
case ${!i} in
    --frontend)
    i=$((i+1))
    KEY_FRONTEND=1
    ;;
    --backend)
    i=$((i+1))
    KEY_BACKEND=1
    ;;
    --ci)
    i=$((i+1))
    KEY_CI=1
    ;;
    --all)
    i=$((i+1))
    KEY_FRONTEND=1
    KEY_BACKEND=1
    KEY_CI=1
    ;;
    *)
            # unknown option
    echo "Unknown option: ${!i}"
    exit 1
    ;;
esac
done

mkdir -p $HOME/.ssh

if [[ "$BACKEND" == 1 ]]; then
    echo "$EF_BACKEND" > $HOME/.ssh/ef_backend

    echo "
        Host backend.eventflow
            Hostname github.com
            IdentityFile=$HOME/.ssh/ef_backend
            User git
    " >> $HOME/.ssh/config
fi

if [[ "$FRONTEND" == 1 ]]; then
    echo "$EF_FRONTEND" > $HOME/.ssh/ef_frontend

    echo "
        Host frontend.eventflow
            Hostname github.com
            IdentityFile=$HOME/.ssh/ef_frontend
            User git
    " >> $HOME/.ssh/config
fi

if [[ "$CI" == 1 ]]; then
    echo "$EF_CI" > $HOME/.ssh/ef_ci

    echo "
        Host ci.eventflow
            Hostname github.com
            IdentityFile=$HOME/.ssh/ef_ci
            User git
    " >> $HOME/.ssh/config
fi

chmod 0600 $HOME/.ssh/ef*
