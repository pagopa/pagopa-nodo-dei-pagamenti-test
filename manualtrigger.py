from flask import Flask, request, jsonify, send_file
from zipfile import ZipFile
import tempfile
import os
import threading
import subprocess
import json
import shutil
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

def create_zip_file(directory):
    with ZipFile(zip_file_path, 'w') as zipf:
        for root, _, files in os.walk(directory):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, directory)
                zipf.write(file_path, arcname=arcname)
                
@app.route('/log', methods=['GET'])
def get_logs():
	create_zip = request.args.get('create')
	print(f'queryparam: {create_zip}')
	if create_zip is None or create_zip == True:
		print('creating zip...')
		create_zip_file(logs_directory)
	if not os.path.exists(zip_file_path):
		print('zip does not exists')
		return jsonify({"message": "file not created"})
	print('log in attachment')
	return send_file(zip_file_path, as_attachment=True, download_name='logs.zip', etag=False)

@app.route('/allure/restart', methods=['GET'])
def allure_restart():
	print("killing allure...")
	os.system("ps -aef | grep allure | grep -v grep | awk '{ print $2 }' | xargs kill -9")
	print("starting allure...")
	os.system("allure open /test/allure/allure-report -p 8081")
	return "ok"

@app.route('/allure/report', methods=['GET'])
def filter_allure_results():
    print("generatig filtered report...") 
    output_dir = '/test/allure/allure-result-filtered'
    status = request.args.get('status')
      
    if not os.path.exists(output_dir):
        print("output dir creating")
        os.makedirs(output_dir)
    else:
        print("output dir already exists, delete dir")
        shutil.rmtree(output_dir)
        os.makedirs(output_dir)
        print("output dir already exists, create dir")

    list_status = status.split(",")

    for desired_status in list_status:
        for filename in os.listdir(logs_directory):
            if filename.endswith(".json"):
                input_path = os.path.join(logs_directory, filename)

                with open(input_path, "r", encoding="utf-8") as file:
                    data = json.load(file)
                    print("data file loaded...")

                # Verifica lo stato del test nel file JSON
                test_status = data.get("status")

                if test_status.lower() == desired_status.lower():
                    output_path = os.path.join(output_dir, filename)
                    shutil.copyfile(input_path, output_path)

                    # Copia gli allegati nella stessa cartella dei file JSON
                    if "attachments" in data:
                        for attachment in data["attachments"]:
                            attachment_file = attachment.get("source")
                            if attachment_file:
                                attachment_path = os.path.join(output_dir, attachment_file)
                                os.makedirs(os.path.dirname(attachment_path), exist_ok=True)
                                shutil.copyfile(os.path.join(logs_directory, attachment_file), attachment_path)		
    create_zip_file(output_dir)
    return send_file(zip_file_path, as_attachment=True, download_name='logs.zip', etag=False)
          
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8082)
