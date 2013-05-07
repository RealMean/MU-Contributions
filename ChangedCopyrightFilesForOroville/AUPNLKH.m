AUPNLKH ; IHS/CMI/LAB - HELP PROMPTS ;17NOV2006
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ; Changed from FOIA in WorldVistA EHR
 ;'Modified' MAS Patient Look-up Check Cross-References June 1987
HELP ;
 I AUPX["??" S DZ="??",D="B",X=AUPX D DQ^DICQ S AUPQF=3 Q
 D EN^DDIOL("Identify the Patient in one of the following ways:","","!!")
 D EN^DDIOL("- Enter the Patient's NAME or a portion of the NAME in the following format: ","","!"),EN^DDIOL($$NAME_" DOE  or "_$$NAME,"","!?10")
 D EN^DDIOL("1...Use from 3 to 30 letters","","!!?5"),EN^DDIOL("2...a COMMA MUST FOLLOW THE LAST NAME","","!?5"),EN^DDIOL("3...If ""JR"" or ""II"", etc, is included, follow the form "_$$NAME_" DOE,JR.","","!?5")
 D EN^DDIOL("4...NO SPACES after commas.","","!?5")
 D  ;I $G(VWVOEPAR("HRN")) D
 .D EN^DDIOL("- Enter the Patient's "_$S($G(DUZ("AG"))="E":"Health Record",1:"IHS Chart")_" Number","","!!")
 ;End new code  DAOU/JLG  2/7/05
 D  ;I $G(VWVOEPAR("DOB")) D
 .D EN^DDIOL("- Enter the Patient's DOB in one of the following forms: ","","!!"),EN^DDIOL("B01221966 or any valid date e.g.  01/22/66, 01-22-66, JAN 22,1966","","!?5")
 D  ;I $G(VWVOEPAR("SSN")) D
 .D EN^DDIOL("- Enter the Patient's SSN or the last 4 digits of the SSN","","!!"),EN^DDIOL("or the last 4 digits preceded by the first letter of the last name","","!?5")
 D  ;I $G(VWVOEPAR("ROOM")) D
 .D EN^DDIOL("- If the Patient is an Inpatient, enter the Ward or Room-Bed in the form:","","!!"),EN^DDIOL("66-2   PEDIATRICS","","!?5")
 D  ;I $G(VWVOEPAR("PHONE")) 
 .D EN^DDIOL("- Enter Patient's residence PHONE NUMBER")
 Q
 ;
NAME() I $G(DUZ("AG"))="I" Q "HORSECHIEF,JOHN"
 Q "SMITH,JOHN"
