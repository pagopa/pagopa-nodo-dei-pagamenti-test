from flask import Flask, request, jsonify, send_file
from zipfile import ZipFile
import tempfile
import os
import threading
import subprocess
app = Flask(__name__)

logs_directory = '/test/allure/allure-result'
zip_file_path = '/test/allure/allure-result.zip'

def run_script(tags, folder):
    # execute script
    subprocess.Popen(["bash", "./startIntTest.sh", "true", tags, folder], stdin=subprocess.PIPE)

def run_stop_script():
    # execute script
    subprocess.Popen(["bash", "./stopIntTest.sh"], stdin=subprocess.PIPE)
	
@app.route('/starttest', methods=['POST'])
def start_test():
    
	#read body
	data = request.get_json()

	if 'tags' in data and 'folder' in data:
		tags = data['tags']
		folder = data['folder']
		
	    # execute tests
		script_thread = threading.Thread(target=run_script, args=(tags, folder))
		script_thread.start()
	
		return jsonify({"message": "test started"})
	else :
		return jsonify({"error": "missing required keys"}), 400

@app.route('/stoptest', methods=['GET'])
def stop_test():
	script_thread = threading.Thread(target=run_stop_script)
	script_thread.start()
	return jsonify({"message": "test stopped"})

def create_zip_file():
    with ZipFile(zip_file_path, 'w') as zipf:
        for root, _, files in os.walk(logs_directory):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, logs_directory)
                zipf.write(file_path, arcname=arcname)
                
@app.route('/log', methods=['GET'])
def get_logs():
	create_zip = request.args.get('create')
	print(f'queryparam: {create_zip}')
	if create_zip is None or create_zip == True:
		print('creating zip...')
		create_zip_file()
	if not os.path.exists(zip_file_path):
		print('zip does not exists')
		return jsonify({"message": "file not created"})
	print('log in attachment')
	return send_file(zip_file_path, as_attachment=True, download_name='logs.zip', etag=False)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8082)
