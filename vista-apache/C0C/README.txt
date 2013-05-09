CCR Package version 1.2

License: Apache 2
http://www.apache.org/licenses/LICENSE-2.0

The purpose of the CCR package is to provide support for exporting and eventually importing patient information from/to VistA in XML documents conforming to the Continuity of Care Record (CCR - ASTM) and Continuity of Care Document (CCD - HL7) standards.

This version of the CCR package provides:

EXPORT^C0CCCR
A command line interface to export a single patient's CCR to a host directory by specifying the patient by name.

EXPORT^C0CCCD
A command line interface to export a single patient's CCD to a host directory by specifying the patient by name. As an alternative to generating the CCD directly, an XSLT transformation is available to translate a CCR into a level 2 CCD. This tranformation has been tested and produces a CCD with all currently supported sections of the CCR. The EXPORT^C0CCCD only extracts the PROBLEMS section into a CCD.

XPAT^C0CCCR(DFN,OUTDIR,OUTFILE)
A command line and program interface to export a single patient's CCR using the IEN of the patient in the ^DPT file (DFN).
OUTDIR specifies an existing directory on the Host system into which the CCR XML document will be written. If OUTDIR is null (""), the output directory name will be taken from ^TMP("C0CCCR","ODIR").
OUFILE specifies the host file name of the CCR XML document that will be written for this patient. If OUTFILE is null ("") the document name will default to PAT_x_CCR_V1.xml where x is the DFN of the patient.

CCRRPC(CCRGRTN,DFN,CCRPARMS,CCRPART)
An RPC and program interface to return in return array CCRGRTN (passed by reference) a single patient's CCR.
DFN is the patient's IEN
CCRPART is what portion of the CCR should be returned. If "CCR" is specified, the entire CCR will be returned. If "PROBLEMS", "VITALS", or "MEDICATIONS" is specified, only that section of the CCR will be returned.
CCRPARMS ARE PARAMETERS THAT AFFECT THE EXTRACTION
IN THE FORM "PARM1:VALUE1^PARM2:VALUE2"
EXAMPLE: "LABLIMIT:T-60" TO LIMIT LAB EXTRACTION TO THE LAST 60 DAYS
SEE C0CPARMS FOR A COMPLETE LIST OF SUPPORTED PARAMETERS

ANALYZE^C0CRIMA(BGNDFN,DFNCNT,CCRPARMS)
A command line and program interface to analyze the data from multiple patients into categories that can be batch extracted.
BGNDFN is the beginning DFN to be analyzed. If BGNDFN is null ("") its value will be taken from ^TMP("C0CRIM","RESUME"). If this variable does not exist, the routine will start with the first IEN in the patient file ^DPT. ^TMP("C0CRIM","RESUME") is updated to the "next" patient to be analyzed on successful completion.
DFNCNT is the count of how many patient records will be analyzed in this execution.
For example ANALYZE^C0CRIMA(1000,1000) would start at patient DFN 1000 and analyzes 1000 patient records. ANALYZE^C0CRIMA("",1000) would then analyze the next 1000 patients. When the end of the patient file is reached, the routine terminates with a message that RESET^C0CRIMA would need to be called to restart the analysis.

The categories into which the records are analyzed consist of attribute strings. The attributes represent characteristics of the variables that can be extracted for a given patient into the CCR or the CCD. This version supports the following attributes:
VITALS : the patient has variables for the VITALS section of the CCR/CCD
PROBLEMS : the patient has variables for the PROBLEMS section of the CCR/CCD
MEDS : the patient has variables for the MEDICATIONS section of the CCR/CCD
HEADER : the patient has variables for the HEADER section of the CCR/CCD. All patients are marked with the HEADER attribute in this version.
NOTEXTRACTED : the CCR or CCD has not yet been produced/extracted for this patient. All patient records are marked with the NOTEXTRACTED attribute in this version for batch control processing (not implemented in this version).

ANAZYZE^C0CRIMA calls the variable extraction routines that would be used to produce a CCR or a CCD and saves the results to ^TMP("C0CRIM",DFN) for each patient. In addition, the attribute string for each patient is saved in ^TMP("C0CRIM","ATTR")

Categories are created as they first occur based on each unique combination of attributes that is encountered. They are named after the attribute table that is used for the analysis. This version supports only the attribute table .RIMTBL. and the categories are named "RIMTBL_x". An example set of categories from a demo systems is:

GTM>D CLIST^C0CRIMA
(RIMTBL_1:105) ^NOTEXTRACTED^HEADER^^^PROBLEMS^^^^^VITALS^^^^^MEDS
(RIMTBL_2:596) ^NOTEXTRACTED^HEADER^^^^^^^^VITALS
(RIMTBL_3:44) ^NOTEXTRACTED^HEADER^^^PROBLEMS^^^^^VITALS
(RIMTBL_4:821) ^NOTEXTRACTED^HEADER
(RIMTBL_5:18) ^NOTEXTRACTED^HEADER^^^^^^^^VITALS^^^^^MEDS
(RIMTBL_6:14) ^NOTEXTRACTED^HEADER^^^PROBLEMS
(RIMTBL_7:15) ^NOTEXTRACTED^HEADER^^^^^^^^^^^^^MEDS
(RIMTBL_8:5) ^NOTEXTRACTED^HEADER^^^PROBLEMS^^^^^^^^^^MEDS

for RIMTBL_1 in this example, 105 is the record count of patients who have this combination of attributes. The list of patients for each category is also maintained for batch extraction.

CLIST^C0CRIMA
A command line interface to show a summary of the categories, record counts, and attributes that have been analyzed so far. It produces the listing in the example above from information stored in ^TMP("C0CRIM","CATS","RIMTBL"). It is intended for future versions that attribute tables be supported in addition to the default "RIMTBL".

CPAT^C0CRIMA(CPATCAT)
A command line interface which shows the DFN numbers of the patients represented by the category CPATCAT. DFNs are listed 10 per line. For example:

GTM>D CPAT^C0CRIMA("RIMTBL_1")
1 3 8 25 42 69 123 140 146 149
151 168 204 205 217 218 224 228 229 231
236 237 240 253 260 267 271 301 347 350
366 379 384 391 407 418 419 420 428 433
442 520 569 600 620 692 706 715 722 723
724 728 730 744 745 746 747 748 749 750
751 752 753 754 755 756 757 758 759 760
761 762 763 764 765 766 767 768 769 770
771 772 773 774 775 776 777 778 779 780
100000 100001 100002 100003 100004 100005 100006 100007 100008 100009
100010 100011 100012 100013 100014

These are the 105 patient records included in category "RIMTBL_1" from the above example.

DPATV^C0CRIMA(DFN,"SECTION")
A command line interface to display the values of variables for a patient. "SECTION" can be any of the CCR sections. ie "ALERTS","RESULTS","MEDS". If SECTION is ommitted, all sections will be shown. An example:

GTM>D DPATV^C0CRIMA(2,"PROBLEMS")
1 1^PROBLEMCODEVALUE^V18.0
2 1^PROBLEMCODINGVERSION^
3 1^PROBLEMCONDITION^P
4 1^PROBLEMDATEMOD^2005-07-19T00:00:00-05:00
5 1^PROBLEMDATEOFONSET^1700--T00:00:00-05:00
6 1^PROBLEMDESCRIPTION^Family History of Diabetes Mellitus (ICD-9-CM V18.0)
7 1^PROBLEMDTREC^1701--T00:00:00-05:00
8 1^PROBLEMHASCMT^
9 1^PROBLEMIEN^8
10 1^PROBLEMINACT^1700--T00:00:00-05:00

DCCR^C0CCCR(DFN)
This will display the XML of a CCR that has been generated for a patient. It is run after generating the CCR with XPAT^C0CCCR or XCPAT^C0CRIMA.

XCPAT^C0CRIMA(CPATCAT)
A command line interface to extract a batch of patient CCR documents that are associated with the category CPATCAT. For example,

XCPAT^C0CRIMA("RIMTBL_1") to extract the CCR documents for the 105 patients in the above example.

RESET^C0CRIMA
A command line interface to kill all ANALYZE^C0CRIMA results stored so far so that the analysis can be done again. It kills ^TMP("C0CRIM","RESUME") and all extraction variables that have been saved in ^TMP("C0CRIM")

NOTES:
This version of the package is a prototype, and does not yet make use of the standard VistA features that are appropriate for it to use.

^TMP("C0CCCR","ODIR") must be set manually to the output directory on the Host System. It is intended that this be maintainable in a parameter file.

CCRRPC^C0CCCR and CCDRPC^C0CCCD are intended to be RPC interfaces to the package but there is no entry for them in the RPC table and the RPC method of access has not been tested.

Most of the command line interface functions in the package are intended to also be made available as RPC calls. This will provide the ability to invoke and control batch extraction and analysis via RPCs

The "RIM" variables and attributes that are now being stored in ^TMP("C0CRIM") are intended to be maintained in a standard FILEMAN global, and to take advantage of FILEMAN indexing for efficient batch analysis and processing.

It is intended that menu interfaces be provided in addition to command line interfaces for all package functions.
