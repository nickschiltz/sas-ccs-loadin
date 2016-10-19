
*============================================================================
*  TITLE: SINGLE-LEVEL CCS LOAD PROGRAM, VERSION 0.1
*
*  AUTHOR: NICHOLAS K. SCHILTZ
*  EMAIL: NKS8 at CASE dot EDU
*
*  DATE: OCTOBER 19, 2016
*  FILE: single_level_ccs_assign.sas
*
*  The purpose of this program is to assign a clinical classification
*  		software (CCS) single-level code for each ICD-9-CM diagnosis and
*		procedure code in a claims or similar type data.
*		The program loads in the formats from the file
*		provided on the HCUP website. It then creates a 
*		format file of these CCS codes. The final step is to apply the 
*		formats to your data.
*		
*===========================================================================;

*Step 1: Set path of the $dxref.csv file downloaded from HCUP website;
	*https://www.hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp#download ;
Filename indx "SET YOUR FILE PATH HERE\$DXREF 2015.csv" ;
Filename inpr "SET YOUR FILE PATH HERE\$PRREF 2015.csv" ;

*Step 2a: Run this code below to bring in the Diagnosis CCS codes into a dataset;
data ccsdx_in;
      infile indx dsd dlm=',' end = eof firstobs=3 missover;
         input start : $char5.
              label : $char4.
              ccs_lab : $char70.
              Value2 : $char70.
              Label2 : $char4.
              Value3 : $char70.
              ;
      retain hlo "   ";
      fmtname = "$dxccs" ;
      type = "C";
      output;

      if eof then do ;
         start = "   " ;
         label = "-99" ;
         hlo = "o";
         output ;
      end ;
	  drop Value2 Label2 Value3 ccs_lab;
run;

*Step 2b: Run this code below to bring in the Procedure CCS codes into a dataset;
data ccspr_in;
      infile inpr dsd dlm=',' end = eof firstobs=3 missover;
         input start : $char5.
              label : $char4.
              ccs_lab : $char70.
              Value2 : $char70.
              ;
      retain hlo "   ";
      fmtname = "$prccs" ;
      type = "C";
      output;

      if eof then do ;
         start = "   " ;
         label = "-99" ;
         hlo = "o";
         output ;
      end ;
	  drop Value2 ccs_lab;
run;

*Step 2c: stack the pr and dx ccs formats together;
data ccs_in;
	set ccsdx_in ccspr_in;
run;

*Step 3: Run this code to put the above data into SAS Format;
proc format cntlin = ccs_in ;
run;

*Step 4: Set the location and file name of the data set you wish to assign ccs codes to;
libname in "SET YOUR PATH HERE";
data test;
      Set in.FAKEDATA; *change to the name of your SAS dataset;
	  array diag[*] DX1-DX25; *change to name of your ICD-9 diagnosis variables and number;
	  array pro[*] PR1-PR15; *change to name of your ICD-9 procedure variables and number;
	  array ccd[*] 3 dxccs1-dxccs25; *set the names of your Diagnosis CCS variables;
	  array ccp[*] 3 prccs1-prccs15; *set the names of your Procedure CCS variables;
	  do i = 1 to dim(diag);
	  	ccd[i] = put(diag[i],$dxccs.);
		if ccd[i] = 0 then ccd[i] = . ;
	  end;
	  do j = 1 to dim(pro);
	  	ccp[j] = put(pro[j],$prccs.);
		if ccp[j] = 0 then ccp[j] = . ;
	  end;	  	
	  drop i j;
run;

*optional: check contents of new data and print some records;
proc contents data=test order=varnum;
run;
proc print data=test (obs=10);
run;
proc freq data=test;
	table dxccs1-dxccs25 prccs1-prccs15;
run;


*======== END PROGRAM =======;


************************************************************************************
*
* NOTE: The above program just assigns the numeric CCS code for each diagnosis code. 
*  To get the labels for each number, use the formats below which are pulled
*	from the HCUP at this link:
*	https://www.hcup-us.ahrq.gov/db/tools/Dx_Pr_Grps_Formats.TXT.
*
* example:
* 	proc freq data=test order=freq;
*		table dxccs1;
*		format dxccs1 flgdxccs.;
*	run;
************************************************************************************;


proc format;
	Value FLGDXCCS
        . = '   .: Missing'
       .A = '   A: Invalid diagnosis'
       .C = '   C: Inconsistent'
       .Z = '   Z: Overall'
        1 = '   1: Tuberculosis'
        2 = '   2: Septicemia (except in labor)'
        3 = '   3: Bacterial infection; unspecified site'
        4 = '   4: Mycoses'
        5 = '   5: HIV infection'
        6 = '   6: Hepatitis'
        7 = '   7: Viral infection'
        8 = '   8: Other infections; including parasitic'
        9 = '   9: Sexually transmitted infections (not HIV or hepatitis)'
       10 = '  10: Immunizations and screening for infectious disease'
       11 = '  11: Cancer of head and neck'
       12 = '  12: Cancer of esophagus'
       13 = '  13: Cancer of stomach'
       14 = '  14: Cancer of colon'
       15 = '  15: Cancer of rectum and anus'
       16 = '  16: Cancer of liver and intrahepatic bile duct'
       17 = '  17: Cancer of pancreas'
       18 = '  18: Cancer of other GI organs; peritoneum'
       19 = '  19: Cancer of bronchus; lung'
       20 = '  20: Cancer; other respiratory and intrathoracic'
       21 = '  21: Cancer of bone and connective tissue'
       22 = '  22: Melanomas of skin'
       23 = '  23: Other non-epithelial cancer of skin'
       24 = '  24: Cancer of breast'
       25 = '  25: Cancer of uterus'
       26 = '  26: Cancer of cervix'
       27 = '  27: Cancer of ovary'
       28 = '  28: Cancer of other female genital organs'
       29 = '  29: Cancer of prostate'
       30 = '  30: Cancer of testis'
       31 = '  31: Cancer of other male genital organs'
       32 = '  32: Cancer of bladder'
       33 = '  33: Cancer of kidney and renal pelvis'
       34 = '  34: Cancer of other urinary organs'
       35 = '  35: Cancer of brain and nervous system'
       36 = '  36: Cancer of thyroid'
       37 = '  37: Hodgkin`s disease'
       38 = '  38: Non-Hodgkin`s lymphoma'
       39 = '  39: Leukemias'
       40 = '  40: Multiple myeloma'
       41 = '  41: Cancer; other and unspecified primary'
       42 = '  42: Secondary malignancies'
       43 = '  43: Malignant neoplasm without specification of site'
       44 = '  44: Neoplasms of unspecified nature or uncertain behavior'
       45 = '  45: Maintenance chemotherapy; radiotherapy'
       46 = '  46: Benign neoplasm of uterus'
       47 = '  47: Other and unspecified benign neoplasm'
       48 = '  48: Thyroid disorders'
       49 = '  49: Diabetes mellitus without complication'
       50 = '  50: Diabetes mellitus with complications'
       51 = '  51: Other endocrine disorders'
       52 = '  52: Nutritional deficiencies'
       53 = '  53: Disorders of lipid metabolism'
       54 = '  54: Gout and other crystal arthropathies'
       55 = '  55: Fluid and electrolyte disorders'
       56 = '  56: Cystic fibrosis'
       57 = '  57: Immunity disorders'
       58 = '  58: Other nutritional; endocrine; and metabolic disorders'
       59 = '  59: Deficiency and other anemia'
       60 = '  60: Acute posthemorrhagic anemia'
       61 = '  61: Sickle cell anemia'
       62 = '  62: Coagulation and hemorrhagic disorders'
       63 = '  63: Diseases of white blood cells'
       64 = '  64: Other hematologic conditions'
       65 = '  65: Mental retardation'
       66 = '  66: Alcohol-related mental disorders'
       67 = '  67: Substance-related mental disorders'
       68 = '  68: Senility and organic mental disorders'
       69 = '  69: Affective disorders'
       70 = '  70: Schizophrenia and related disorders'
       71 = '  71: Other psychoses'
       72 = '  72: Anxiety; somatoform; dissociative; and personality disorders'
       73 = '  73: Preadult disorders'
       74 = '  74: Other mental conditions'
       75 = '  75: Personal history of mental disorder; mental and behavioral problems; observation and screening for mental condition'
       76 = '  76: Meningitis (except that caused by tuberculosis or sexually transmitted disease)'
       77 = '  77: Encephalitis (except that caused by tuberculosis or sexually transmitted disease)'
       78 = '  78: Other CNS infection and poliomyelitis'
       79 = '  79: Parkinson`s disease'
       80 = '  80: Multiple sclerosis'
       81 = '  81: Other hereditary and degenerative nervous system conditions'
       82 = '  82: Paralysis'
       83 = '  83: Epilepsy; convulsions'
       84 = '  84: Headache; including migraine'
       85 = '  85: Coma; stupor; and brain damage'
       86 = '  86: Cataract'
       87 = '  87: Retinal detachments; defects; vascular occlusion; and retinopathy'
       88 = '  88: Glaucoma'
       89 = '  89: Blindness and vision defects'
       90 = '  90: Inflammation; infection of eye (except that caused by tuberculosis or sexually transmitteddisease)'
       91 = '  91: Other eye disorders'
       92 = '  92: Otitis media and related conditions'
       93 = '  93: Conditions associated with dizziness or vertigo'
       94 = '  94: Other ear and sense organ disorders'
       95 = '  95: Other nervous system disorders'
       96 = '  96: Heart valve disorders'
       97 = '  97: Peri-; endo-; and myocarditis; cardiomyopathy (except that caused by tuberculosis or sexually transmitted disease)'
       98 = '  98: Essential hypertension'
       99 = '  99: Hypertension with complications and secondary hypertension'
      100 = ' 100: Acute myocardial infarction'
      101 = ' 101: Coronary atherosclerosis and other heart disease'
      102 = ' 102: Nonspecific chest pain'
      103 = ' 103: Pulmonary heart disease'
      104 = ' 104: Other and ill-defined heart disease'
      105 = ' 105: Conduction disorders'
      106 = ' 106: Cardiac dysrhythmias'
      107 = ' 107: Cardiac arrest and ventricular fibrillation'
      108 = ' 108: Congestive heart failure; nonhypertensive'
      109 = ' 109: Acute cerebrovascular disease'
      110 = ' 110: Occlusion or stenosis of precerebral arteries'
      111 = ' 111: Other and ill-defined cerebrovascular disease'
      112 = ' 112: Transient cerebral ischemia'
      113 = ' 113: Late effects of cerebrovascular disease'
      114 = ' 114: Peripheral and visceral atherosclerosis'
      115 = ' 115: Aortic; peripheral; and visceral artery aneurysms'
      116 = ' 116: Aortic and peripheral arterial embolism or thrombosis'
      117 = ' 117: Other circulatory disease'
      118 = ' 118: Phlebitis; thrombophlebitis and thromboembolism'
      119 = ' 119: Varicose veins of lower extremity'
      120 = ' 120: Hemorrhoids'
      121 = ' 121: Other diseases of veins and lymphatics'
      122 = ' 122: Pneumonia (except that caused by tuberculosis or sexually transmitted disease)'
      123 = ' 123: Influenza'
      124 = ' 124: Acute and chronic tonsillitis'
      125 = ' 125: Acute bronchitis'
      126 = ' 126: Other upper respiratory infections'
      127 = ' 127: Chronic obstructive pulmonary disease and bronchiectasis'
      128 = ' 128: Asthma'
      129 = ' 129: Aspiration pneumonitis; food/vomitus'
      130 = ' 130: Pleurisy; pneumothorax; pulmonary collapse'
      131 = ' 131: Respiratory failure; insufficiency; arrest (adult)'
      132 = ' 132: Lung disease due to external agents'
      133 = ' 133: Other lower respiratory disease'
      134 = ' 134: Other upper respiratory disease'
      135 = ' 135: Intestinal infection'
      136 = ' 136: Disorders of teeth and jaw'
      137 = ' 137: Diseases of mouth; excluding dental'
      138 = ' 138: Esophageal disorders'
      139 = ' 139: Gastroduodenal ulcer (except hemorrhage)'
      140 = ' 140: Gastritis and duodenitis'
      141 = ' 141: Other disorders of stomach and duodenum'
      142 = ' 142: Appendicitis and other appendiceal conditions'
      143 = ' 143: Abdominal hernia'
      144 = ' 144: Regional enteritis and ulcerative colitis'
      145 = ' 145: Intestinal obstruction without hernia'
      146 = ' 146: Diverticulosis and diverticulitis'
      147 = ' 147: Anal and rectal conditions'
      148 = ' 148: Peritonitis and intestinal abscess'
      149 = ' 149: Biliary tract disease'
      150 = ' 150: Liver disease; alcohol-related'
      151 = ' 151: Other liver diseases'
      152 = ' 152: Pancreatic disorders (not diabetes)'
      153 = ' 153: Gastrointestinal hemorrhage'
      154 = ' 154: Noninfectious gastroenteritis'
      155 = ' 155: Other gastrointestinal disorders'
      156 = ' 156: Nephritis; nephrosis; renal sclerosis'
      157 = ' 157: Acute and unspecified renal failure'
      158 = ' 158: Chronic kidney disease'
      159 = ' 159: Urinary tract infections'
      160 = ' 160: Calculus of urinary tract'
      161 = ' 161: Other diseases of kidney and ureters'
      162 = ' 162: Other diseases of bladder and urethra'
      163 = ' 163: Genitourinary symptoms and ill-defined conditions'
      164 = ' 164: Hyperplasia of prostate'
      165 = ' 165: Inflammatory conditions of male genital organs'
      166 = ' 166: Other male genital disorders'
      167 = ' 167: Nonmalignant breast conditions'
      168 = ' 168: Inflammatory diseases of female pelvic organs'
      169 = ' 169: Endometriosis'
      170 = ' 170: Prolapse of female genital organs'
      171 = ' 171: Menstrual disorders'
      172 = ' 172: Ovarian cyst'
      173 = ' 173: Menopausal disorders'
      174 = ' 174: Female infertility'
      175 = ' 175: Other female genital disorders'
      176 = ' 176: Contraceptive and procreative management'
      177 = ' 177: Spontaneous abortion'
      178 = ' 178: Induced abortion'
      179 = ' 179: Postabortion complications'
      180 = ' 180: Ectopic pregnancy'
      181 = ' 181: Other complications of pregnancy'
      182 = ' 182: Hemorrhage during pregnancy; abruptio placenta; placenta previa'
      183 = ' 183: Hypertension complicating pregnancy; childbirth and the puerperium'
      184 = ' 184: Early or threatened labor'
      185 = ' 185: Prolonged pregnancy'
      186 = ' 186: Diabetes or abnormal glucose tolerance complicating pregnancy; childbirth; or the puerperium'
      187 = ' 187: Malposition; malpresentation'
      188 = ' 188: Fetopelvic disproportion; obstruction'
      189 = ' 189: Previous C-section'
      190 = ' 190: Fetal distress and abnormal forces of labor'
      191 = ' 191: Polyhydramnios and other problems of amniotic cavity'
      192 = ' 192: Umbilical cord complication'
      193 = ' 193: OB-related trauma to perineum and vulva'
      194 = ' 194: Forceps delivery'
      195 = ' 195: Other complications of birth; puerperium affecting management of mother'
      196 = ' 196: Normal pregnancy and/or delivery'
      197 = ' 197: Skin and subcutaneous tissue infections'
      198 = ' 198: Other inflammatory condition of skin'
      199 = ' 199: Chronic ulcer of skin'
      200 = ' 200: Other skin disorders'
      201 = ' 201: Infective arthritis and osteomyelitis (except that caused by tuberculosis or sexually transmitted disease)'
      202 = ' 202: Rheumatoid arthritis and related disease'
      203 = ' 203: Osteoarthritis'
      204 = ' 204: Other non-traumatic joint disorders'
      205 = ' 205: Spondylosis; intervertebral disc disorders; other back problems'
      206 = ' 206: Osteoporosis'
      207 = ' 207: Pathological fracture'
      208 = ' 208: Acquired foot deformities'
      209 = ' 209: Other acquired deformities'
      210 = ' 210: Systemic lupus erythematosus and connective tissue disorders'
      211 = ' 211: Other connective tissue disease'
      212 = ' 212: Other bone disease and musculoskeletal deformities'
      213 = ' 213: Cardiac and circulatory congenital anomalies'
      214 = ' 214: Digestive congenital anomalies'
      215 = ' 215: Genitourinary congenital anomalies'
      216 = ' 216: Nervous system congenital anomalies'
      217 = ' 217: Other congenital anomalies'
      218 = ' 218: Liveborn'
      219 = ' 219: Short gestation; low birth weight; and fetal growth retardation'
      220 = ' 220: Intrauterine hypoxia and birth asphyxia'
      221 = ' 221: Respiratory distress syndrome'
      222 = ' 222: Hemolytic jaundice and perinatal jaundice'
      223 = ' 223: Birth trauma'
      224 = ' 224: Other perinatal conditions'
      225 = ' 225: Joint disorders and dislocations; trauma-related'
      226 = ' 226: Fracture of neck of femur (hip)'
      227 = ' 227: Spinal cord injury'
      228 = ' 228: Skull and face fractures'
      229 = ' 229: Fracture of upper limb'
      230 = ' 230: Fracture of lower limb'
      231 = ' 231: Other fractures'
      232 = ' 232: Sprains and strains'
      233 = ' 233: Intracranial injury'
      234 = ' 234: Crushing injury or internal injury'
      235 = ' 235: Open wounds of head; neck; and trunk'
      236 = ' 236: Open wounds of extremities'
      237 = ' 237: Complication of device; implant or graft'
      238 = ' 238: Complications of surgical procedures or medical care'
      239 = ' 239: Superficial injury; contusion'
      240 = ' 240: Burns'
      241 = ' 241: Poisoning by psychotropic agents'
      242 = ' 242: Poisoning by other medications and drugs'
      243 = ' 243: Poisoning by nonmedicinal substances'
      244 = ' 244: Other injuries and conditions due to external causes'
      245 = ' 245: Syncope'
      246 = ' 246: Fever of unknown origin'
      247 = ' 247: Lymphadenitis'
      248 = ' 248: Gangrene'
      249 = ' 249: Shock'
      250 = ' 250: Nausea and vomiting'
      251 = ' 251: Abdominal pain'
      252 = ' 252: Malaise and fatigue'
      253 = ' 253: Allergic reactions'
      254 = ' 254: Rehabilitation care; fitting of prostheses; and adjustment of devices'
      255 = ' 255: Administrative/social admission'
      256 = ' 256: Medical examination/evaluation'
      257 = ' 257: Other aftercare'
      258 = ' 258: Other screening for suspected conditions (not mental disorders or infectious disease)'
      259 = ' 259: Residual codes; unclassified'
      260 = ' 260: E Codes: All (external causes of injury and poisoning)'
      650 = ' 650: Adjustment disorders'
      651 = ' 651: Anxiety disorders'
      652 = ' 652: Attention-deficit, conduct, and disruptive behavior disorders'
      653 = ' 653: Delirium, dementia, and amnestic and other cognitive disorders'
      654 = ' 654: Developmental disorders'
      655 = ' 655: Disorders usually diagnosed in infancy, childhood, or adolescence'
      656 = ' 656: Impulse control disorders, NEC'
      657 = ' 657: Mood disorders'
      658 = ' 658: Personality disorders'
      659 = ' 659: Schizophrenia and other psychotic disorders'
      660 = ' 660: Alcohol-related disorders'
      661 = ' 661: Substance-related disorders'
      662 = ' 662: Suicide and intentional self-inflicted injury'
      663 = ' 663: Screening and history of mental health and substance abuse codes'
      670 = ' 670: Miscellaneous disorders'
     2601 = '2601: E Codes: Cut/pierceb'
     2602 = '2602: E Codes: Drowning/submersion'
     2603 = '2603: E Codes: Fall'
     2604 = '2604: E Codes: Fire/burn'
     2605 = '2605: E Codes: Firearm'
     2606 = '2606: E Codes: Machinery'
     2607 = '2607: E Codes: Motor vehicle traffic (MVT)'
     2608 = '2608: E Codes: Pedal cyclist; not MVT'
     2609 = '2609: E Codes: Pedestrian; not MVT'
     2610 = '2610: E Codes: Transport; not MVT'
     2611 = '2611: E Codes: Natural/environment'
     2612 = '2612: E Codes: Overexertion'
     2613 = '2613: E Codes: Poisoning'
     2614 = '2614: E Codes: Struck by; against'
     2615 = '2615: E Codes: Suffocation'
     2616 = '2616: E Codes: Adverse effects of medical care'
     2617 = '2617: E Codes: Adverse effects of medical drugs'
     2618 = '2618: E Codes: Other specified and classifiable'
     2619 = '2619: E Codes: Other specified; NEC'
     2620 = '2620: E Codes: Unspecified'
     2621 = '2621: E Codes: Place of occurrence'
   ;

   Value FLGPRCCS
       . = '   .: Missing'
      .A = '   A: Invalid procedure'
      .C = '   C: Inconsistent'
      .Z = '   Z: Overall'
       1 = '   1: Incision and excision of CNS'
       2 = '   2: Insertion; replacement; or removal of extracranial ventricular shunt'
       3 = '   3: Laminectomy; excision intervertebral disc'
       4 = '   4: Diagnostic spinal tap'
       5 = '   5: Insertion of catheter or spinal stimulator and injection into spinal canal'
       6 = '   6: Decompression peripheral nerve'
       7 = '   7: Other diagnostic nervous system procedures'
       8 = '   8: Other non-OR or closed therapeutic nervous system procedures'
       9 = '   9: Other OR therapeutic nervous system procedures'
      10 = '  10: Thyroidectomy; partial or complete'
      11 = '  11: Diagnostic endocrine procedures'
      12 = '  12: Other therapeutic endocrine procedures'
      13 = '  13: Corneal transplant'
      14 = '  14: Glaucoma procedures'
      15 = '  15: Lens and cataract procedures'
      16 = '  16: Repair of retinal tear; detachment'
      17 = '  17: Destruction of lesion of retina and choroid'
      18 = '  18: Diagnostic procedures on eye'
      19 = '  19: Other therapeutic procedures on eyelids; conjunctiva; cornea'
      20 = '  20: Other intraocular therapeutic procedures'
      21 = '  21: Other extraocular muscle and orbit therapeutic procedures'
      22 = '  22: Tympanoplasty'
      23 = '  23: Myringotomy'
      24 = '  24: Mastoidectomy'
      25 = '  25: Diagnostic procedures on ear'
      26 = '  26: Other therapeutic ear procedures'
      27 = '  27: Control of epistaxis'
      28 = '  28: Plastic procedures on nose'
      29 = '  29: Dental procedures'
      30 = '  30: Tonsillectomy and/or adenoidectomy'
      31 = '  31: Diagnostic procedures on nose; mouth and pharynx'
      32 = '  32: Other non-OR therapeutic procedures on nose; mouth and pharynx'
      33 = '  33: Other OR therapeutic procedures on nose; mouth and pharynx'
      34 = '  34: Tracheostomy; temporary and permanent'
      35 = '  35: Tracheoscopy and laryngoscopy with biopsy'
      36 = '  36: Lobectomy or pneumonectomy'
      37 = '  37: Diagnostic bronchoscopy and biopsy of bronchus'
      38 = '  38: Other diagnostic procedures on lung and bronchus'
      39 = '  39: Incision of pleura; thoracentesis; chest drainage'
      40 = '  40: Other diagnostic procedures of respiratory tract and mediastinum'
      41 = '  41: Other non-OR therapeutic procedures on respiratory system'
      42 = '  42: Other OR Rx procedures on respiratory system and mediastinum'
      43 = '  43: Heart valve procedures'
      44 = '  44: Coronary artery bypass graft (CABG)'
      45 = '  45: Percutaneous transluminal coronary angioplasty (PTCA)'
      46 = '  46: Coronary thrombolysis'
      47 = '  47: Diagnostic cardiac catheterization; coronary arteriography'
      48 = '  48: Insertion; revision; replacement; removal of cardiac pacemaker or cardioverter/defibrillator'
      49 = '  49: Other OR heart procedures'
      50 = '  50: Extracorporeal circulation auxiliary to open heart procedures'
      51 = '  51: Endarterectomy; vessel of head and neck'
      52 = '  52: Aortic resection; replacement or anastomosis'
      53 = '  53: Varicose vein stripping; lower limb'
      54 = '  54: Other vascular catheterization; not heart'
      55 = '  55: Peripheral vascular bypass'
      56 = '  56: Other vascular bypass and shunt; not heart'
      57 = '  57: Creation; revision and removal of arteriovenous fistula or vessel-to-vessel cannula for dialysis'
      58 = '  58: Hemodialysis'
      59 = '  59: Other OR procedures on vessels of head and neck'
      60 = '  60: Embolectomy and endarterectomy of lower limbs'
      61 = '  61: Other OR procedures on vessels other than head and neck'
      62 = '  62: Other diagnostic cardiovascular procedures'
      63 = '  63: Other non-OR therapeutic cardiovascular procedures'
      64 = '  64: Bone marrow transplant'
      65 = '  65: Bone marrow biopsy'
      66 = '  66: Procedures on spleen'
      67 = '  67: Other therapeutic procedures; hemic and lymphatic system'
      68 = '  68: Injection or ligation of esophageal varices'
      69 = '  69: Esophageal dilatation'
      70 = '  70: Upper gastrointestinal endoscopy; biopsy'
      71 = '  71: Gastrostomy; temporary and permanent'
      72 = '  72: Colostomy; temporary and permanent'
      73 = '  73: Ileostomy and other enterostomy'
      74 = '  74: Gastrectomy; partial and total'
      75 = '  75: Small bowel resection'
      76 = '  76: Colonoscopy and biopsy'
      77 = '  77: Proctoscopy and anorectal biopsy'
      78 = '  78: Colorectal resection'
      79 = '  79: Local excision of large intestine lesion (not endoscopic)'
      80 = '  80: Appendectomy'
      81 = '  81: Hemorrhoid procedures'
      82 = '  82: Fluoroscopy of the biliary and pancreatic ducts (ERCP, ERC and ERP)'
      83 = '  83: Biopsy of liver'
      84 = '  84: Cholecystectomy and common duct exploration'
      85 = '  85: Inguinal and femoral hernia repair'
      86 = '  86: Other hernia repair'
      87 = '  87: Laparoscopy (GI only)'
      88 = '  88: Abdominal paracentesis'
      89 = '  89: Exploratory laparotomy'
      90 = '  90: Excision; lysis peritoneal adhesions'
      91 = '  91: Peritoneal dialysis'
      92 = '  92: Other bowel diagnostic procedures'
      93 = '  93: Other non-OR upper GI therapeutic procedures'
      94 = '  94: Other OR upper GI therapeutic procedures'
      95 = '  95: Other non-OR lower GI therapeutic procedures'
      96 = '  96: Other OR lower GI therapeutic procedures'
      97 = '  97: Other gastrointestinal diagnostic procedures'
      98 = '  98: Other non-OR gastrointestinal therapeutic procedures'
      99 = '  99: Other OR gastrointestinal therapeutic procedures'
     100 = ' 100: Endoscopy and endoscopic biopsy of the urinary tract'
     101 = ' 101: Transurethral excision; drainage; or removal urinary obstruction'
     102 = ' 102: Ureteral catheterization'
     103 = ' 103: Nephrotomy and nephrostomy'
     104 = ' 104: Nephrectomy; partial or complete'
     105 = ' 105: Kidney transplant'
     106 = ' 106: Genitourinary incontinence procedures'
     107 = ' 107: Extracorporeal lithotripsy; urinary'
     108 = ' 108: Indwelling catheter'
     109 = ' 109: Procedures on the urethra'
     110 = ' 110: Other diagnostic procedures of urinary tract'
     111 = ' 111: Other non-OR therapeutic procedures of urinary tract'
     112 = ' 112: Other OR therapeutic procedures of urinary tract'
     113 = ' 113: Transurethral resection of prostate (TURP)'
     114 = ' 114: Open prostatectomy'
     115 = ' 115: Circumcision'
     116 = ' 116: Diagnostic procedures; male genital'
     117 = ' 117: Other non-OR therapeutic procedures; male genital'
     118 = ' 118: Other OR therapeutic procedures; male genital'
     119 = ' 119: Oophorectomy; unilateral and bilateral'
     120 = ' 120: Other operations on ovary'
     121 = ' 121: Ligation or occlusion of fallopian tubes'
     122 = ' 122: Removal of ectopic pregnancy'
     123 = ' 123: Other operations on fallopian tubes'
     124 = ' 124: Hysterectomy; abdominal and vaginal'
     125 = ' 125: Other excision of cervix and uterus'
     126 = ' 126: Abortion (termination of pregnancy)'
     127 = ' 127: Dilatation and curettage (D&C); aspiration after delivery or abortion'
     128 = ' 128: Diagnostic dilatation and curettage (D&C)'
     129 = ' 129: Repair of cystocele and rectocele; obliteration of vaginal vault'
     130 = ' 130: Other diagnostic procedures; female organs'
     131 = ' 131: Other non-OR therapeutic procedures; female organs'
     132 = ' 132: Other OR therapeutic procedures; female organs'
     133 = ' 133: Episiotomy'
     134 = ' 134: Cesarean section'
     135 = ' 135: Forceps; vacuum; and breech delivery'
     136 = ' 136: Artificial rupture of membranes to assist delivery'
     137 = ' 137: Other procedures to assist delivery'
     138 = ' 138: Diagnostic amniocentesis'
     139 = ' 139: Fetal monitoring'
     140 = ' 140: Repair of current obstetric laceration'
     141 = ' 141: Other therapeutic obstetrical procedures'
     142 = ' 142: Partial excision bone'
     143 = ' 143: Bunionectomy or repair of toe deformities'
     144 = ' 144: Treatment; facial fracture or dislocation'
     145 = ' 145: Treatment; fracture or dislocation of radius and ulna'
     146 = ' 146: Treatment; fracture or dislocation of hip and femur'
     147 = ' 147: Treatment; fracture or dislocation of lower extremity (other than hip or femur)'
     148 = ' 148: Other fracture and dislocation procedure'
     149 = ' 149: Arthroscopy'
     150 = ' 150: Division of joint capsule; ligament or cartilage'
     151 = ' 151: Excision of semilunar cartilage of knee'
     152 = ' 152: Arthroplasty knee'
     153 = ' 153: Hip replacement; total and partial'
     154 = ' 154: Arthroplasty other than hip or knee'
     155 = ' 155: Arthrocentesis'
     156 = ' 156: Injections and aspirations of muscles; tendons; bursa; joints and soft tissue'
     157 = ' 157: Amputation of lower extremity'
     158 = ' 158: Spinal fusion'
     159 = ' 159: Other diagnostic procedures on musculoskeletal system'
     160 = ' 160: Other therapeutic procedures on muscles and tendons'
     161 = ' 161: Other OR therapeutic procedures on bone'
     162 = ' 162: Other OR therapeutic procedures on joints'
     163 = ' 163: Other non-OR therapeutic procedures on musculoskeletal system'
     164 = ' 164: Other OR therapeutic procedures on musculoskeletal system'
     165 = ' 165: Breast biopsy and other diagnostic procedures on breast'
     166 = ' 166: Lumpectomy; quadrantectomy of breast'
     167 = ' 167: Mastectomy'
     168 = ' 168: Incision and drainage; skin and subcutaneous tissue'
     169 = ' 169: Debridement of wound; infection or burn'
     170 = ' 170: Excision of skin lesion'
     171 = ' 171: Suture of skin and subcutaneous tissue'
     172 = ' 172: Skin graft'
     173 = ' 173: Other diagnostic procedures on skin and subcutaneous tissue'
     174 = ' 174: Other non-OR therapeutic procedures on skin and breast'
     175 = ' 175: Other OR therapeutic procedures on skin and breast'
     176 = ' 176: Organ transplantation (other than bone marrow, corneal or kidney)'
     177 = ' 177: Computerized axial tomography (CT) scan head'
     178 = ' 178: CT scan chest'
     179 = ' 179: CT scan abdomen'
     180 = ' 180: Other CT scan'
     181 = ' 181: Myelogram'
     182 = ' 182: Mammography'
     183 = ' 183: Routine chest X-ray'
     184 = ' 184: Intraoperative cholangiogram'
     185 = ' 185: Upper gastrointestinal X-ray'
     186 = ' 186: Lower gastrointestinal X-ray'
     187 = ' 187: Intravenous pyelogram'
     188 = ' 188: Cerebral arteriogram'
     189 = ' 189: Contrast aortogram'
     190 = ' 190: Contrast arteriogram of femoral and lower extremity arteries'
     191 = ' 191: Arterio- or venogram (not heart and head)'
     192 = ' 192: Diagnostic ultrasound of head and neck'
     193 = ' 193: Diagnostic ultrasound of heart (echocardiogram)'
     194 = ' 194: Diagnostic ultrasound of gastrointestinal tract'
     195 = ' 195: Diagnostic ultrasound of urinary tract'
     196 = ' 196: Diagnostic ultrasound of abdomen or retroperitoneum'
     197 = ' 197: Other diagnostic ultrasound'
     198 = ' 198: Magnetic resonance imaging'
     199 = ' 199: Electroencephalogram (EEG)'
     200 = ' 200: Nonoperative urinary system measurements'
     201 = ' 201: Cardiac stress tests'
     202 = ' 202: Electrocardiogram'
     203 = ' 203: Electrographic cardiac monitoring'
     204 = ' 204: Swan-Ganz catheterization for monitoring'
     205 = ' 205: Arterial blood gases'
     206 = ' 206: Microscopic examination (bacterial smear; culture; toxicology)'
     207 = ' 207: Nuclear medicine imaging of bone'
     208 = ' 208: Nuclear medicine imaging of pulmonary'
     209 = ' 209: Non-imaging nuclear medicine probe or assay'
     210 = ' 210: Other nuclear medicine imaging'
     211 = ' 211: Radiation therapy'
     212 = ' 212: Diagnostic physical therapy'
     213 = ' 213: Physical therapy exercises; manipulation; and other procedures'
     214 = ' 214: Traction; splints; and other wound care'
     215 = ' 215: Other physical therapy and rehabilitation'
     216 = ' 216: Respiratory intubation and mechanical ventilation'
     217 = ' 217: Other respiratory therapy'
     218 = ' 218: Psychological and psychiatric evaluation and therapy'
     219 = ' 219: Alcohol and drug rehabilitation/detoxification'
     220 = ' 220: Ophthalmologic and otologic diagnosis and treatment'
     221 = ' 221: Nasogastric tube'
     222 = ' 222: Blood transfusion'
     223 = ' 223: Enteral and parenteral nutrition'
     224 = ' 224: Cancer chemotherapy'
     225 = ' 225: Conversion of cardiac rhythm'
     226 = ' 226: Other diagnostic radiology and related techniques'
     227 = ' 227: Other diagnostic procedures'
     228 = ' 228: Prophylactic vaccinations and inoculations'
     229 = ' 229: Nonoperative removal of foreign body'
     230 = ' 230: Extracorporeal shock wave other than urinary'
     231 = ' 231: Other therapeutic procedures'
   ;

   run;

