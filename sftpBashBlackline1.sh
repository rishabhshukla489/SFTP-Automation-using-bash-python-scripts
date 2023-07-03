#!/bin/bash

read_file_content_sftp() {
    local host=$1
    local username=$2
    local password=$3
    local remote_file_path=$4

    local local_file_path="temp_file.txt"
    {
        echo "get \"$remote_file_path\" \"$local_file_path\""
        echo "quit"
    } | sshpass -p "$password" sftp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$username@$host" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi

    cat "$local_file_path"
    rm "$local_file_path"
}

read_file_content_sftp_key() {
    local host=$1
    local username=$2
    local password=$3
    local key_path=$4
    local remote_file_path=$5

    local local_file_path="temp_file.txt"
    {
        echo "get \"$remote_file_path\" \"$local_file_path\""
        echo "quit"
    } | sshpass -p "$password" sftp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$key_path" "$username@$host" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi

    cat "$local_file_path"
    rm "$local_file_path"
}

send_file_content_sftp() {
    local host=$1
    local username=$2
    local password=$3
    local local_file_path=$4
    local remote_file_path=$5

    {
        echo "put \"$local_file_path\" \"$remote_file_path\""
        echo "quit"
    } | sshpass -p "$password" sftp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$username@$host" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi
}

send_file_content_sftp_key() {
    local host=$1
    local username=$2
    local password=$3
    local key_path=$4
    local local_file_path=$5
    local remote_file_path=$6

    {
        echo "put \"$local_file_path\" \"$remote_file_path\""
        echo "quit"
    } | sshpass -p "$password" sftp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$key_path" "$username@$host" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi
}

read_file_content_ftp() {
    local host=$1
    local username=$2
    local password=$3
    local remote_file_path=$4

    curl --user "$username:$password" --silent --show-error "ftp://$host/$remote_file_path"

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi
}

send_file_content_ftp() {
    local host=$1
    local username=$2
    local password=$3
    local local_file_path=$4
    local remote_file_path=$5

    curl --user "$username:$password" --upload-file "$local_file_path" "ftp://$host/$remote_file_path" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "Error: Connection disconnect or server connection issue occurred."
        exit 1
    fi
}

protocol=$1
operation=$2
host=$3
username=$4
auth_method=$5

if [ "$protocol" == "sftp" ]; then
    if [ "$operation" == "read" ]; then
        if [ "$auth_method" == "key" ]; then
            if [ "$#" -lt 8 ]; then
                echo "Error: Key path or remote file path is missing for SFTP read operation with key authentication."
                exit 1
            fi
            password=$6
            key_path=$7
            remote_file_path=$8
            read_file_content_sftp_key "$host" "$username" "$password" "$key_path" "$remote_file_path"
        else
            if [ "$#" -lt 7 ]; then
                echo "Error: Remote file path is missing for SFTP read operation with password authentication."
                exit 1
            fi
            password=$6
            remote_file_path=$7
            read_file_content_sftp "$host" "$username" "$password" "$remote_file_path"
        fi
    elif [ "$operation" == "send" ]; then
        if [ "$auth_method" == "key" ]; then
            if [ "$#" -lt 9 ]; then
                echo "Error: Key path, local or remote file path is missing for SFTP send operation with key authentication."
                exit 1
            fi
            password=$6
            key_path=$7
            local_file_path=$8
            remote_file_path=$9
            send_file_content_sftp_key "$host" "$username" "$password" "$key_path" "$local_file_path" "$remote_file_path"
        else
            if [ "$#" -lt 8 ]; then
                echo "Error: Local or remote file path is missing for SFTP send operation with password authentication."
                exit 1
            fi
            password=$6
            local_file_path=$7
            remote_file_path=$8
            send_file_content_sftp "$host" "$username" "$password" "$local_file_path" "$remote_file_path"
        fi
    else
        echo "Error: Invalid operation. Please specify 'read' or 'send' for SFTP."
    fi
elif [ "$protocol" == "ftp" ]; then
    if [ "$operation" == "read" ]; then
        if [ "$#" -lt 6 ]; then
            echo "Error: Remote file path is missing for FTP read operation."
            exit 1
        fi
        remote_file_path=$6
        read_file_content_ftp "$host" "$username" "$auth_method" "$remote_file_path"
    elif [ "$operation" == "send" ]; then
        if [ "$#" -lt 7 ]; then
            echo "Error: Local or remote file path is missing for FTP send operation."
            exit 1
        fi
        local_file_path=$6
        remote_file_path=$7
        send_file_content_ftp "$host" "$username" "$auth_method" "$local_file_path" "$remote_file_path"
    else
        echo "Error: Invalid operation. Please specify 'read' or 'send' for FTP."
    fi
else
    echo "Error: Invalid protocol. Please specify 'sftp' or 'ftp'."
fi

