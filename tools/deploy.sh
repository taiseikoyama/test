#!/bin/bash
current=`pwd`
current=${current%/*}
eval "cp pre-commit ${current}/.git/hooks/"
