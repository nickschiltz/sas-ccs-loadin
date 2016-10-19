
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
*  		software (CCS) single-level code for each ICD-9-CM diagnosis code 
*		in a claims or similar type data. The program loads in the formats
*		from the file provided on the HCUP website. It then creates a 
*		format file of these CCS codes. The final step is to apply the 
*		formats to your data.
*		
*===========================================================================;

*Step 1: Set path of the $dxref.csv file downloaded from HCUP website;
	*https://www.hcup-us.ahrq.gov/toolssoftware/ccs/ccs.jsp#download ;
Filename inraw "SET YOUR LOCATION HERE\$DXREF 2015.csv" ;

*Step 2: Run this code below to bring in the CCS codes into a dataset;
data ccs_in;
      infile inraw dsd dlm=',' end = eof firstobs=3 missover;
         input start : $char5.
              label : $char4.
              ccs_lab : $char70.
              Value2 : $char70.
              Label2 : $char4.
              Value3 : $char70.
              ;
      retain hlo "   ";
      fmtname = "$ccs" ;
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

*Step 3: Run this code to put the above data into SAS Format;
proc format cntlin = ccs_in ;
run;

*Step 4: Set the location and file name of the data set you wish to assign ccs codes to;
libname in "SET YOUR LOCATION HERE";
data test;
      Set in.fakedata; *set the name of your SAS dataset;
	  array diag[25] dx1-dx25; *change name of your ICD-9 variables and number;
	  array cc[25] 3 dxccs1-dxccs25; *set the names of you CCS variables;
	  do i = 1 to 25;
	  	cc[i] = put(diag[i],$ccs.);
		if cc[i] = 0 then cc[i] = . ;
	  end;
	  drop i;
run;

*optional: check contents of new data and print some records;
proc contents data=test order=varnum;
run;
proc print data=test (obs=10);
run;
proc freq data=test;
	table dxccs1-dxccs25;
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
   run;

