import sys
import pysftp
from ftplib import FTP

def read_file_content_sftp(host, username, password, remote_file_path):
    cnopts = pysftp.CnOpts()
    cnopts.hostkeys = None

    try:
        with pysftp.Connection(host, username=username, password=password, cnopts=cnopts) as sftp:
            with sftp.open(remote_file_path, 'r') as file:
                file_content = file.read().decode('utf-8')
                print(f"{file_content}")

    except pysftp.AuthenticationException:
        print("Error: Authentication failed. Please check your credentials.")
    except pysftp.ConnectionException as conn_err:
        print(f"Error: Unable to establish SFTP connection: {str(conn_err)}")
    except Exception as e:
        print(f"Error: {str(e)}")

def send_file_content_sftp(host, username, password, local_file_path, remote_file_path):
    cnopts = pysftp.CnOpts()
    cnopts.hostkeys = None

    try:
        with pysftp.Connection(host, username=username, password=password, cnopts=cnopts) as sftp:
            sftp.put(local_file_path, remote_file_path)

        print(f"File {local_file_path} uploaded successfully to {host}:{remote_file_path}")

    except pysftp.AuthenticationException:
        print("Error: Authentication failed. Please check your credentials.")
    except pysftp.ConnectionException as conn_err:
        print(f"Error: Unable to establish SFTP connection: {str(conn_err)}")
    except Exception as e:
        print(f"Error: {str(e)}")

def read_file_content_ftp(host, username, password, remote_file_path):
    try:
        with FTP(host) as ftp:
            ftp.login(user=username, passwd=password)
            file_content = []
            ftp.retrlines(f'RETR {remote_file_path}', lambda line: file_content.append(line))
            print('\n'.join(file_content))

    except Exception as e:
        print(f"Error: {str(e)}")

def send_file_content_ftp(host, username, password, local_file_path, remote_file_path):
    try:
        with FTP(host) as ftp:
            ftp.login(user=username, passwd=password)
            with open(local_file_path, 'rb') as file:
                ftp.storbinary(f'STOR {remote_file_path}', file)

        print(f"File {local_file_path} uploaded successfully to {host}:{remote_file_path}")

    except Exception as e:
        print(f"Error: {str(e)}")



protocol = sys.argv[1]
operation = sys.argv[2]
host = sys.argv[3]
username = sys.argv[4]
password = sys.argv[5]

if protocol == 'sftp':
    if operation == 'read':
        if len(sys.argv) < 6:
            print("Error: Remote file path is missing for SFTP read operation.")
            sys.exit(1)
        remote_file_path = sys.argv[6]
        read_file_content_sftp(host, username, password, remote_file_path)
    elif operation == 'send':
        if len(sys.argv) < 7:
            print("Error: Local or remote file path is missing for SFTP send operation.")
            sys.exit(1)
        local_file_path = sys.argv[6]
        remote_file_path = sys.argv[7]
        send_file_content_sftp(host, username, password, local_file_path, remote_file_path)
    else:
        print("Error: Invalid operation. Please specify 'read' or 'send' for SFTP.")
elif protocol == 'ftp':
    if operation == 'read':
        if len(sys.argv) < 6:
            print("Error: Remote file path is missing for FTP read operation.")
            sys.exit(1)
        remote_file_path = sys.argv[6]
        read_file_content_ftp(host, username, password, remote_file_path)
    elif operation == 'send':
        if len(sys.argv) < 7:
            print("Error: Local or remote file path is missing for FTP send operation.")
            sys.exit(1)
        local_file_path = sys.argv[6]
        remote_file_path = sys.argv[7]
        send_file_content_ftp(host, username, password, local_file_path, remote_file_path)
    else:
        print("Error: Invalid operation. Please specify 'read' or 'send' for FTP.")
else:
    print("Error: Invalid protocol. Please specify 'sftp' or 'ftp'.")

