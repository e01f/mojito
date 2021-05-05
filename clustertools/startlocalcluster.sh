#!/bin/bash
#
# start n parallel synth runs on this machine
#
NUMPROCS=16

POPSIZE=100
POOL_SIZE=100
PROBLEM_NUMBER=103

SYNTH_DIR="C:\\BA\\mojito"
RUN_DIR="run1"

RESULT_BASE_DIR="C:\\BA\\mojito-tests-$RUN_DIR"
RESULT_PREFIX="OP"
RESULT_DATABASE_FILE="$RESULT_BASE_DIR/result.db"

POOL_DATABASE_FILE="$RESULT_BASE_DIR/pooled.db"
POOL_DIRLIST_FILE="$RESULT_BASE_DIR/pool.dirs"

# make the target dirs
mkdir -p "$RESULT_BASE_DIR"

# clear pool file
echo "" > $POOL_DIRLIST_FILE

cd SYNTH_DIR

for i in $(seq 1 $NUMPROCS);
do
	LAST_STATE_FILE=`ls -1 "$RESULT_BASE_DIR/$RESULT_PREFIX-localhost-$i/state"* 2> /dev/null | tail -n1`
	echo "Starting process $i ($LAST_STATE_FILE)..."
	if [ "$LAST_STATE_FILE" = "" ]; then  
		./synth.py $PROBLEM_NUMBER $POPSIZE "$RESULT_BASE_DIR/$RESULT_PREFIX-localhost-$i" "$POOL_DATABASE_FILE" 2> /dev/null 1> /dev/null &
	else
		./synth.py $PROBLEM_NUMBER $POPSIZE "$RESULT_BASE_DIR/$RESULT_PREFIX-localhost-$i" "$POOL_DATABASE_FILE" "$LAST_STATE_FILE" 2> /dev/null 1> /dev/null &
	fi
    echo "$RESULT_BASE_DIR/$RESULT_PREFIX-localhost-$i" >> $POOL_DIRLIST_FILE
done

echo "Startup complete. Wait for pool..."

./pooler.py $PROBLEM_NUMBER "$POOL_DIRLIST_FILE" "$POOL_DATABASE_FILE" "$POOL_SIZE"

# To stop, use the following:
#  1. taskkill /IM python.exe /F
#  2. taskkill /IM hspice.com /F
#     (this works best if hspice.EXE -C was used to start client/server mode so the server isn't killed)

echo "Pooling complete."

echo "Aggregation..."

./aggregator.py $PROBLEM_NUMBER "$POOL_DIRLIST_FILE" "$RESULT_DATABASE_FILE"