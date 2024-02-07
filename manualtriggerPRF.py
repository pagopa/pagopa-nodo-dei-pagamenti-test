from flask import Flask, request, jsonify
import os
import threading
import subprocess
app = Flask(__name__)

def run_script(debugEnabled, rampa, blacklist):
    # execute script
    print('starting startPerfTest')
    subprocess.Popen(["bash", "./startPerfTest.sh", debugEnabled, rampa, blacklist], stdin=subprocess.PIPE)

def run_stop_script():
    # execute script
    print('stopping test...')
    subprocess.Popen(["bash", "./stopPerfTest.sh"], stdin=subprocess.PIPE)
	
@app.route('/starttest', methods=['POST'])
def start_test():
    print('start test START')
    
    #read body
    data = request.get_json()

    if 'debugEnabled' in data and 'rampa' in data and 'blacklist' in data:
        debugEnabled = data['debugEnabled']
        rampa = data['rampa']
        blacklist = data['blacklist']

        # execute tests
        script_thread = threading.Thread(target=run_script, args=(debugEnabled, rampa, blacklist))
        script_thread.start()
        print('start test END')
        return jsonify({"message": "test started"})
    else :
        print('start test error START')
        return jsonify({"error": "missing required keys"}), 400

@app.route('/stoptest', methods=['GET'])
def stop_test():
    print('stop test START')
    script_thread = threading.Thread(target=run_stop_script)
    script_thread.start()
    print('stop test END')
    return jsonify({"message": "test stopped"})
	
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8082)

