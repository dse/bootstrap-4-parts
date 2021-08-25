#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
shopt -s lastpipe

MAIN () {
    rm -frv scss || true
    rm -frv css || true
    mkdir scss
    mkdir css

    declare -a components
    cut -f2 -d\" <<EOF | mapfile -t components
@import "root";
@import "reboot";
@import "type";
@import "images";
@import "code";
@import "grid";
@import "tables";
@import "forms";
@import "buttons";
@import "transitions";
@import "dropdown";
@import "button-group";
@import "input-group";
@import "custom-forms";
@import "nav";
@import "navbar";
@import "card";
@import "breadcrumb";
@import "pagination";
@import "badge";
@import "jumbotron";
@import "alert";
@import "progress";
@import "media";
@import "list-group";
@import "close";
@import "toasts";
@import "modal";
@import "tooltip";
@import "popover";
@import "carousel";
@import "spinners";
@import "utilities";
@import "print";
EOF

    declare -i counter=0
    for component in "${components[@]}" ; do
        counter+=1
        xxx="$(printf "%03d" "${counter}")"
        sassfile="scss/${xxx}-${component}.scss"
        cssfile="css/${xxx}-${component}.css"
        >&2 echo "${component} - ${sassfile} ${cssfile}"

        cat <<EOF >"${sassfile}"
@charset 'utf-8';
@import "functions";
@import "variables";
@import "mixins";
@import "${component}";
EOF
        sassc -t expanded -I node_modules/bootstrap/scss "${sassfile}" "${cssfile}"
    done
}

###############################################################################
MAIN "$@"
