VWHL260	;WVEHR/John McCormack- World VistA HL Table Utilities; 7:32 PM 25 Nov 2012
	;;WVEHR-1007;WORLD VISTA;*WVEHR1*;;Build 14
	;
	; Changed from FOIA in WorldVistA EHR
	; Copyright 2013 WorldVistA
	; Licensed under the Apache License, Version 2.0 (the "License");
	; you may not use this file except in compliance with the License.
	; 
	; You may obtain a copy of the License at
	;
	;       http://www.apache.org/licenses/LICENSE-2.0
	;
	; Unless required by applicable law or agreed to in writing, software
	; distributed under the License is distributed on an "AS IS" BASIS,
	; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	; implied.
	;
	; See the License for the specific language governing permissions and
	; limitations under the License.
	;
	Q
	;
	;
PRE	; Pre-intall for file #260 DD.
	;
	D DDEL
	Q
	;
	;
DDEL	;
	; Delete DD for file #260
	;
	I $G(XPDENV),$$VFILE^DILFD(260) D
	. N DIU
	. D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting Data Dictionary VW HL7 TABLES File (#260) ***",80))
	. S DIU="^VWLEX(260,",DIU(0)="DS" D EN^DIU2
	. D BMES^XPDUTL($$CJ^XLFSTR("*** Data Dictionary VW HL7 TABLES File (#260) ***",80))
	. D BMES^XPDUTL($$CJ^XLFSTR("*** will be installed by this KIDS installation***",80))
	;
	Q
