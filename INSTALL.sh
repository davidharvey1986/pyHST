#!/bin/bash
#  Date : 21/6/2017
#  Author : David Harvey
#
#  INSTALL.sh
#  This script is to be run when installing the code.
#  Notes about stsci tools.
#  There seem to be bugs in the code that need patching
#  This could be updated in the future by space telescope however
#  not just yet.
#  
#  Therefore notes are as follow:
#  Requires
#     - pyfits version 3.1.6
#     - numpy version 1.11.0
#     - a patch for stsci/tools/fileutil
#     - a patch for stwcs/distortion/multil.py
#
#  This code here will
#    1. Set up a virtual environment in which to install all the code. This
#       will prevent old pyfits and old numpy being installed globally
#    2. Once set up it will install all code and dependencies in the virtual
#       environment.
#    3. Once finished the user source the setup.shell script. This will
#       activate the shell. All paths incluing PYTHONPATH will be removed.
#       The user will be in an isoated environment so that they can reduce
#       the data they want within that shell wihtout affecting the rest of
#       the computer.
#    4. So once run, the user will need to download data into a file within
#       the virutal environment and then starting using it.

#  INPUT : the name of the environment
#  EXAMPLE
#              ./INSTALL.sh ../hst_reduction_pipeline
#
#              source PATH/TO/hst_reduction_pipeline/shell.setup

#First we need virtualenv package
#So lock in the PWD first
idl_binary=`which idl`
idl_binary_path=`dirname $idl_binary`
sex_binary=`which sex`
sex_binary_path=`dirname $sex_binary`
CODE_DIR=${PWD}
virtual_env=${1}
pip install virtualenv
#You cant create a virtual environment of a package that already exists
if [ -d "${virtual_env}" ]; then
   echo ${virtual_env}' directory already exists, do not clobber'
   exit
fi
virtualenv -p /usr/bin/python2.7 ${virtual_env}
#Check if the virtual environment exists
if [ ! -d "${virtual_env}" ]; then
   echo ${virtual_env}' didnt creat'
   exit
fi
#go in to the virtual environement and log where we are
cd ${virtual_env}
ROOT_DIR=${PWD}
#Go in to the binaries and start installing
cd ${ROOT_DIR}/bin
unset PYTHONPATH
export PATH='${ROOT_DIR}'/bin:'${ROOT_DIR}'/lib/python2.7/site-packages/pyHST-0.0.1-py2.7.egg/pyHST/calacs:$(getconf PATH)
#ACtivate the virtual environment
source activate
#This should be nothing
echo $PYTHONPATH
#This should point towards the pip and python in the virtual environment
which pip
which python
#Install ALL packages as there are none here and the computer knows
#nothing about glbal packages
./pip install ipython
./pip install numpy==1.11.0
./pip install stsci.distutils
./pip install stscipython
./pip install pyfits==3.1.6
./pip install matplotlib
./pip install PySide
cd ${ROOT_DIR}
mkdir pyHST
#Get the code and install the pyHST
cp -fr ${CODE_DIR}/* pyHST
cd pyHST
python setup.py install
cd ${ROOT_DIR}
cp ${ROOT_DIR}/lib/python2.7/site-packages/pyHST-0.0.1-py2.7.egg/pyHST/stsci_patches/fileutil.py ${ROOT_DIR}/lib/python2.7/site-packages/stsci/tools/
cp ${ROOT_DIR}/lib/python2.7/site-packages/pyHST-0.0.1-py2.7.egg/pyHST/stsci_patches/mutil.py ${ROOT_DIR}/lib/python2.7/site-packages/stwcs/distortion/mutil.py
#Send out the notifications for the user to source the correct shell.
echo -en "\033[36m"
echo 'Please do the following to set up and go to the shell.'
echo -en "\033[31m"
echo 'source '${ROOT_DIR}'/shell.setup'
echo -en "\033[36m"
echo 'If you would like to go back to your normal shell please run'
echo -en "\033[31m"
echo 'source  '${ROOT_DIR}'/shell.deactivate'
echo -en "\033[0m"
echo 'export PATH='${ROOT_DIR}'/bin:'${ROOT_DIR}'/lib/python2.7/site-packages/pyHST-0.0.1-py2.7.egg/pyHST/calacs:$(getconf PATH)' > shell.setup
IDL_PATH=`ls -d ${ROOT_DIR}/lib/python2.7/site-packages/pyHST*/pyHST/bin/idl_cti_cor/`
echo 'export IDL_PATH='${IDL_PATH} >> shell.setup
echo 'source '${ROOT_DIR}'/bin/activate' >> shell.setup
echo 'unset PYTHONPATH' >> shell.setup
echo 'cd '${ROOT_DIR} >> shell.setup
echo 'export PATH=${PATH}:'${idl_binary_path}:${sex_binary_path} >> shell.setup
echo 'deactivate' > shell.deactivate
echo 'source ~/.bash_login' >> shell.deactivate
#Special for installing matplotlib
mkdir ${ROOT_DIR}/.matplotlib
echo "backend: TkAgg" >> ${ROOT_DIR}/.matplotlib/matplotlibrc
echo "MATPLOTLIBRC="${ROOT_DIR}"/.matplotlib" >> shell.setup