#!/bin/bash
echo "entrypoint params: $debugEn $ram $bl"
python manualtriggerPRF.py & \
./startPerfTest.sh $debugEn $ram $bl
