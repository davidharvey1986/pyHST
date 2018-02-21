HST REDUCTION PIPELINE
----------------------

Author :  David Harvey
Date : 25/11/2016


Purpose :
	HST reduction that is more advanced that the 'on the fly'
	data reduction used directly on Hubble.

	This code produces weak lensing, drizzled, quality data
	from the original raw files.

Method :
       1. The first part is corrects all the raw files for 
       Charge Transfer Inefficiency (CTE, https://arxiv.org/abs/1401.1151)
       2. The second part is that all the CTE files are flat fielded using
       the calacs script from STSCI
       3a. Once flat-fielded the files (FLTs) are divided into subsets according
       to their HST FILTER (e.g. F814W, F606W etc...).
       3b. The problem is that the FLTs might be from different epochs, and 
       observation runs, so they rotated and offset from one another. So one
       must align the FLTs before we drizzle them to make the final image.
       To do this first, each set of expsoures is divided into their corresponding
       data sets which is given by the first 6 characters of the file name.
       These are drizzled together using astrodrizzle.
       4. Then, each drizzled image from the datasets associated with the filter
       are compared to one another and tweaked so they are aligned. To do
       this the drizzled images are source extracted and then the sources 
       of each image are aligned.
       5. The solution to the alignment is then applied to the each FLT
       within that hst dataset.
       6. Now with all aligned flts we drizzle together for a final image

       FOR MORE INFORMATION OF THE ALIGNMENT STAGE PLEASE SEE ALIGNING_IMAGES.TXT

INPUTS:
	1. Downloaded data from MAST, including the original RAW files 
	and the associated calibration files (although any missing ones
	will be downloaded by the pipeline)
	2. Note that this code will assume that all the data in the current
	working direction are to be drizzled together. 
	So make sure you have only the images you want to be drizzled together 
	in the directory you execute the code.	
	3. The name of the output file you want to call the drizzled image.
OUTPUTS:
	1. A science file named ${INPUT_NAME}_${FILTER}_drz_sci.fits
	2. A weight file named ${INPUT_NAME}_${FILTER}_drz_wht.fits

OPTIONAL OUTPUTS:
	1. Individual exposures of each FLT (for PSF estimation)
	   Named singles/${EXPOSURE_NAME}_drz_sci.fits
	
	
	
      
NOTES :
      Assumes use of idl, if gdl please change in the src/bin/cte_correct_vidl.sh and GDL_PATH instead of IDL_PATH
      Assumes use of standard clang GCC installer
      
TO DO:
   Add sextractor path to the install script
   Add MATPLOTLIBRC with a backend of TkAgg to the install script
   Add target checker to make sure i drizzle the same object together
   Add jref_path to all the scripts so i can point to the same cluster and not redownload all the same files
   Add plt.ion ( i think this will solve the problem of not appearing plots)
   Add the launch date on the run arctic.sh