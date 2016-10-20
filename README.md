# sas-ccs-loadin
SAS code to assign Clinical Classification Software (CCS) values based on ICD-9-CM

Version 0.1

This repository includes a simple SAS program (single_level_ccs_assign.sas) to use the single-level Clinical Classification Software (CCS) provided by the Agency for Healthcare Research and Quality's (AHRQ) Healthcare Cost and Utilization Project (HCUP). The single-level CCS codes are available on the HCUP website (https://www.hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp).  

Rationale: HCUP provides code to load the multi-level CCS version, but does not provide much guidance on single-level. 

This SAS code does two things:

  1) Loads in the "$DXREF 2015.csv" and "$PRREF 2015.csv" single-level CCS data into a SAS dataset and then converts it to a format
  
  2) Creates a new variable(s) corresponding to the CCS for each ICD-9-CM diagnosis and procedure code in your data. 

The User must set the paths of the $DXREF 2015.csv and $PRREF 2015.csv file and the input data where noted in the code.  Users must also adjust the names of the input data diagnosis and procedure codes, and the desired name of the CCS codes as necessary.  

A sample synthetic data file (fakeclaims.sas7bdat) with 100 records of inpatient data is included for testing. The file contains 36 variables including 10 ICD-9-CM discharge diagnosis codes, and 6 ICD-9-CM procedure codes for each record, and 1 additional admission diagnosis ICD-9-CM codes. The file is a 100 record sample pulled from the DE-SynPUF (de-identified synthetic public use file) inpatient sample 04 from CMS, and contains not HIPAA identifiers (because it is fake).

Future versions of this program may include converting the program to a SAS macro. 
