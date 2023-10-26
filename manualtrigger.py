from flask import Flask, request, jsonify
import os
import threading
import subprocess
app = Flask(__name__)

def run_script(tags, folder):
	# set environment variables
    os.environ["tags"] = tags
    os.environ["folder"] = folder

    # Pass environment to child process
    env = os.environ.copy()
    print('setting tags '+ tags)
    print('setting folder '+ folder)
    
    print('----------------------------------------------------')
    
    for key, value in env.items():
        print(f"{key}: {value}")

    print('----------------------------------------------------')
    
    # execute script
    subprocess.Popen(["sh", "./startIntTest.sh"], stdin=subprocess.PIPE, env=env)
	
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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8081)
