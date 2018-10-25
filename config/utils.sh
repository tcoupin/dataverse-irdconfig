updateJVMOption () {
    key=$1
    value=$2
    option=$(asadmin list-jvm-options | grep \\-D${key}=)
    if [[ "$option" != "" ]]
    then
        asadmin delete-jvm-options "$(escapeString $option)"
    fi
    asadmin create-jvm-options "-D${key}=$(escapeString ${value})"
}

escapeString () {
    echo $1 | sed 's#:#\\:#g'
}