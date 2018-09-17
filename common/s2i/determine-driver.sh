#!/usr/bin/env bash
case "$1" in
    derby )
        echo "org.apache.derby.jdbc.EmbeddedDriver"
    ;;
    postgresql )
        echo "org.postgresql.Driver"
    ;;
    mysql )
        echo "com.mysql.jdbc.Driver"
    ;;
    oracle )
        echo "oracle.jdbc.driver.OracleDriver"
    ;;
esac