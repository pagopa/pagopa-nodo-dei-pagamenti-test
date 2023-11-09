from flask import Flask, request, jsonify
import os
import threading
import subprocess
app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8082)
