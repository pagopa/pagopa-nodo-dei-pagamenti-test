from flask import Flask, request, jsonify
import os
import threading
import subprocess
app = Flask(__name__)

def run_script(debugEnabled, rampa, blacklist):
    # execute script
    subprocess.Popen(["bash", "./startPerfTest.sh", debugEnabled, rampa, blacklist], stdin=subprocess.PIPE)
	
@app.route('/starttest', methods=['POST'])
def start_test():
    
	#read body
	data = request.get_json()

	if 'debugEnabled' in data and 'rampa' in data and 'blacklist' in data:
		debugEnabled = data['debugEnabled']
		rampa = data['rampa']
		blacklist = data['blacklist']
		
	    # execute tests
		script_thread = threading.Thread(target=run_script, args=(debugEnabled, rampa, blacklist))
		script_thread.start()
	
		return jsonify({"message": "test started"})
	else :
		return jsonify({"error": "missing required keys"}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8082)
