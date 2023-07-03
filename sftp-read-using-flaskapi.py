from flask import Flask, request
# ,render_template
import pysftp

app = Flask(__name__)

@app.route('/get_file', methods=['GET'])
def get_file():
   
    sftp_host = request.args.get('host')
    sftp_user = request.args.get('user')
    sftp_pass = request.args.get('password')
    sftp_remote_path = request.args.get('remote_path')

    
    with pysftp.Connection(host=sftp_host, username=sftp_user, password=sftp_pass) as sftp:
        
        with sftp.open(sftp_remote_path) as file:
            file_content = file.read()
    print(file_content)
    return file_content
# @app.route('/')
# def index():
#     return render_template('index.html')
if __name__ == '__main__':
    app.run(port=8000)
