#! /usr/bin/env bash
case "$(lsb_release -c | cut -f 2)" in
    xenial|trusty|precise)
        switch=$(dpkg -s shellcheck | grep -i version | cut -f 2 -d ' ' | grep '0.4' && echo '-x')
        bash -c "shellcheck ${switch} bin/build.sh"
        ;;
    CentOS)
        shellcheck -x  bin/build.sh
        ;;
    *)
        echo "Unknown distribution"
        exit 1
        ;;
esac
