#!/bin/bash
#
# This is job project1_test1_1
#

#
## Start of header for backend 'local'.
#

set -e
set -u

ENVIRONMENT_DIR='.'

#
# Variables declared in MOLGENIS Compute headers/footers always start with an MC_ prefix.
#
declare MC_jobScript="test1_1.sh"
declare MC_jobScriptSTDERR="test1_1.err"
declare MC_jobScriptSTDOUT="test1_1.out"
declare MC_failedFile="molgenis.pipeline.failed"


declare MC_singleSeperatorLine=$(head -c 120 /dev/zero | tr '\0' '-')
declare MC_doubleSeperatorLine=$(head -c 120 /dev/zero | tr '\0' '=')
declare MC_tmpFolder='tmpFolder'
declare MC_tmpFile='tmpFile'
declare MC_tmpFolderCreated=0

#
##
### Header functions.
##
#

function errorExitAndCleanUp() {
	local _signal="${1}"
	local _problematicLine="${2}"
	local _exitStatus="${3:-$?}"
	local _executionHost="$(hostname)"
	local _format='INFO: Last 50 lines or less of %s:\n'
	local _errorMessage="FATAL: Trapped ${_signal} signal in ${MC_jobScript} running on ${_executionHost}. Exit status code was ${_exitStatus}."
	if [ "${_signal}" == 'ERR' ]; then
		_errorMessage="FATAL: Trapped ${_signal} signal on line ${_problematicLine} in ${MC_jobScript} running on ${_executionHost}. Exit status code was ${_exitStatus}."
	fi
	_errorMessage=${4:-"${_errorMessage}"} # Optionally use custom error message as 4th argument.
	echo "${_errorMessage}"
	echo "${MC_doubleSeperatorLine}"                 > "${MC_failedFile}"
	echo "${_errorMessage}"                         >> "${MC_failedFile}"
	if [ -f "${MC_jobScriptSTDERR}" ]; then
		echo "${MC_singleSeperatorLine}"            >> "${MC_failedFile}"
		printf "${_format}" "${MC_jobScriptSTDERR}" >> "${MC_failedFile}"
		echo "${MC_singleSeperatorLine}"            >> "${MC_failedFile}"
		tail -50 "${MC_jobScriptSTDERR}"            >> "${MC_failedFile}"
	fi
	if [ -f "${MC_jobScriptSTDOUT}" ]; then
		echo "${MC_singleSeperatorLine}"            >> "${MC_failedFile}"
		printf "${_format}" "${MC_jobScriptSTDOUT}" >> "${MC_failedFile}"
		echo "${MC_singleSeperatorLine}"            >> "${MC_failedFile}"
		tail -50 "${MC_jobScriptSTDOUT}"            >> "${MC_failedFile}"
	fi
	echo "${MC_doubleSeperatorLine}"                >> "${MC_failedFile}"
}

#
# Create tmp dir per script/job.
# To be called with with either a file or folder as first and only argument.
# Defines two globally set variables:
#  1. MC_tmpFolder: a tmp dir for this job/script. When function is called multiple times MC_tmpFolder will always be the same.
#  2. MC_tmpFile:   when the first argument was a folder, MC_tmpFile == MC_tmpFolder
#                   when the first argument was a file, MC_tmpFile will be a path to a tmp file inside MC_tmpFolder.
#
function makeTmpDir {
	#
	# Compile paths.
	#
	local _originalPath="${1}"
	local _myMD5="$(md5sum ${MC_jobScript} | cut -d ' ' -f 1)"
	local _tmpSubFolder="tmp_${MC_jobScript}_${_myMD5}"
	local _dir
	local _base
	if [[ -d "${_originalPath}" ]]; then
		_dir="${_originalPath}"
		_base=''
	else
		_base=$(basename "${_originalPath}")
		_dir=$(dirname "${_originalPath}")
	fi
	MC_tmpFolder="${_dir}/${_tmpSubFolder}/"
	MC_tmpFile="${MC_tmpFolder}/${_base}"
	echo "DEBUG ${MC_jobScript}::makeTmpDir: dir='${_dir}';base='${_base}';MC_tmpFile='${MC_tmpFile}'"
	#
	# Cleanup the previously created tmpFolder first if this script was resubmitted.
	#
	if [[ ${MC_tmpFolderCreated} -eq 0 && -d "${MC_tmpFolder}" ]]; then
		rm -rf "${MC_tmpFolder}"
	fi
	#
	# (Re-)create tmpFolder.
	#
	mkdir -p "${MC_tmpFolder}"
	MC_tmpFolderCreated=1
}

trap 'errorExitAndCleanUp HUP  NA $?' HUP
trap 'errorExitAndCleanUp INT  NA $?' INT
trap 'errorExitAndCleanUp QUIT NA $?' QUIT
trap 'errorExitAndCleanUp TERM NA $?' TERM
trap 'errorExitAndCleanUp EXIT NA $?' EXIT
trap 'errorExitAndCleanUp ERR  $LINENO $?' ERR

touch "${MC_jobScript}.started"

#
## End of header for backend 'local'
#



#
## Generated header
#

# Assign values to the parameters in this script

# Set taskId, which is the job name of this task
taskId="test1_1"

# Make compute.properties available
rundir="TEST_PROPERTY(project.basedir)/target/test/benchmark/run/testFoldOnTwoStrings"
runid="testFoldOnTwoStrings"
workflow="src/main/resources/workflows/foreachtest/workflow.csv"
parameters="src/main/resources/workflows/foreachtest/parameters.csv,src/main/resources/workflows/foreachtest/parameters1.csv"
user="TEST_PROPERTY(user.name)"
database="none"
backend="localhost"
port="80"
interval="2000"
path="."


# Connect parameters to environment
project="project1"
dir="dir2"
sample[0]="sample2"
sample[1]="sample3"
chr[0]="1"
chr[1]="2"
chr[2]="3"

# Validate that each 'value' parameter has only identical values in its list
# We do that to protect you against parameter values that might not be correctly set at runtime.
if [[ ! $(IFS=$'\n' sort -u <<< "${project[*]}" | wc -l | sed -e 's/^[[:space:]]*//') = 1 ]]; then echo "Error in Step 'test1': input parameter 'project' is an array with different values. Maybe 'project' is a runtime parameter with 'more variable' values than what was folded on generation-time?" >&2; exit 1; fi
if [[ ! $(IFS=$'\n' sort -u <<< "${dir[*]}" | wc -l | sed -e 's/^[[:space:]]*//') = 1 ]]; then echo "Error in Step 'test1': input parameter 'dir' is an array with different values. Maybe 'dir' is a runtime parameter with 'more variable' values than what was folded on generation-time?" >&2; exit 1; fi

#
## Start of your protocol template
#

#!/bin/sh
#string project
#string dir
#list sample
#list chr


for s in "${sample[@]}"
do
    echo $s
    for c in "${chr[@]}"
    do
         echo $c
    done
done

#
## End of your protocol template
#

# Save output in environment file: '$ENVIRONMENT_DIR/test1_1.env' with the output vars of this step

echo "" >> $ENVIRONMENT_DIR/test1_1.env
chmod 755 $ENVIRONMENT_DIR/test1_1.env


#
## Start of footer for backend 'local'.
#

if [ -d "${MC_tmpFolder:-}" ]; then
	echo -n "INFO: Removing MC_tmpFolder ${MC_tmpFolder} ..."
	rm -rf "${MC_tmpFolder}"
	echo 'done.'
fi

tS=${SECONDS:-0}
tM=$((SECONDS / 60 ))
tH=$((SECONDS / 3600))
echo "On $(date +"%Y-%m-%d %T") ${MC_jobScript} finished successfully after ${tM} minutes." >> molgenis.bookkeeping.log
printf '%s:\t%d seconds\t%d minutes\t%d hours\n' "${MC_jobScript}" "${tS}" "${tM}" "${tH}" >> molgenis.bookkeeping.walltime

mv "${MC_jobScript}".{started,finished}

trap - EXIT
exit 0

