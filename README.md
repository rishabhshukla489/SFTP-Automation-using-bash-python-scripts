# SFTP-Automation-using-bash-python-scripts
Created bash, flask api and python script to automate sftp transfer in dell boomi to reduce cost of sftp connections by invoking the scripts from data process shape.
<br>
#For Boomi usage:
<br>
The script needs to be store in boomiserver and specify the name of file along with path in the script.
<br>1 Add a set property shape to define dynamic document property as given below.
<br>2 Add a custom scripting data process shape and invoke this script using groovy scripts provided in the files.
<br>3 The data process shape will output the read data as document in the integration flow and throw an exception in case of error which can be handled seperately.
<br>The bash script is developed to provide read and write operation for file transfer protocols : FTP and SFTP.
<br>This uses a single bash script that has 6 functions as follows :
<br>SFTP:
<br>read_file_content_sftp() : For sftp read operation using only password authentication.
<br>send_file_content_sftp() : For sftp send operation using only password authentication.
<br>read_file_content_sftp_key() : For sftp read operation on servers relying on key based authentication with additional password authentication in case the server requires both form of authentication or in case the server falls back to password authentication when key based authentication fails.
<br>send_file_content_sftp_key() :  For sftp send operation on servers relying on key based authentication with additional password authentication in case the server requires both form of authentication or in case the server falls back to password authentication when key based authentication fails.
<br>FTP: 
<br>read_file_content_ftp() : For ftp read operation using only password authentication.
<br>send_file_content_ftp() : For ftp send operation using only password authentication.

<br>

<br>For script we need to provide arguments in form of dynamic document property as follows:
<br>FTP : 
<br>DDP_PROTOCOL : ftp
<br>DDP_OP : read/send
<br>DDP_HOST : IP address of host / hostname
<br>DDP_USERNAME : username 
<br>DDP_PASSWORD : password (specified as hidden in process property and set in set property shape for this dynamic document property) 
<br>DDP_REMOTEPATH : (for read operation) complete path of file to be read including the filename appended at the last or (for send operation) complete path of the directory for sending the data 
<br>
<br>DDP_FILENAME: (only for send operation using ftp) filename along with the extension of format of the data to be sent 

<br>SFTP : 
<br>DDP_PROTOCOL : sftp
<br>DDP_OP : read/send
<br>DDP_HOST : IP address of host / hostname
<br>DDP_USERNAME : username 
<br>DDP_AUTH : password(for password authentication) / key (for key authentication)
<br>DDP_PASSWORD(for both password and key authentication) : password (specified as hidden in process property and set in set property shape for this dynamic document property) 
<br>DDP_KEYPATH (only for key authentication) : filepath of the private key saved on boomi server given server already has the public key in the required format (private key format depends on the sftp server eg: ssh-rsa for rsa based authentication and linux based clients or eg: ssh-ed25519 for windows client)
<br>DDP_REMOTEPATH : (for read operation) complete path of file to be read including the filename appended at the last or (for send operation) complete path of the directory for sending the data 
<br>DDP_FILENAME (only for send operation using sftp) : filename along with the extension of format of the data to be sent 
