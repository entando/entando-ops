#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Returns the appropriate Java JDBC Driver class a given DBMS vendor
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