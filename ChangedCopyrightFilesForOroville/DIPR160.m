DIPR160	;O-OIFO/GMB-Change Routine Size ;3:03 PM  27 Feb 2012
	;;22.0;VA FileMan;**160**;Mar 30, 1999;Build 3;;WorldVistA 30-June-08
	;
	;Modified from FOIA VISTA,
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
	;
	;Per VHA Directive 2004-038, this routine should not be modified.
ENV	; Environmental Check
	D BMES^XPDUTL("Perform Environment Check...")
	D CHKSTOP
	D BMES^XPDUTL("Finished Environment Check.")
	Q
CHKSTOP	;
	; Check XPDENV 0 = Loading; 1 = Installing
	I 'XPDENV Q  ; Loading Distribution - No Check
	;
	;
INSCHK	; Do Checks During Install Only
	W $C(7)
	D MES^XPDUTL("** Although Queuing is allowed - it is HIGHLY recommended that ALL Users and")
	D MES^XPDUTL("VISTA Background jobs be STOPPED before installation of this patch.  Failure")
	D MES^XPDUTL("to do so may result in 'source routine edited' error(s). Edits will be")
	D MES^XPDUTL("lost and record(s) may be left in an inconsistent state, for example,")
	D MES^XPDUTL("not all Cross-Referencing completed; which in turn may cause FUTURE")
	D MES^XPDUTL("VistA/FileMan Hard Errors or corrupted Data. **")
	;
TMCHK	; Check to see if TaskMan is still running
	S X=$$TM^%ZTLOAD
	I X,'$D(^%ZTSCH("WAIT")) D
	. W $C(7)
	. D BMES^XPDUTL("* Warning TaskMan Has NOT Been Stopped or Placed in a WAIT State!")
	;
LINH	; Check to see if Logons are Inhibited
	D GETENV^%ZOSV  ; $P(Y,"^",2) = Installing Volume
	S X=+$G(^%ZIS(14.5,"LOGON",$P(Y,"^",2)))
	I 'X D
	. W $C(7)
	. D BMES^XPDUTL("* Warning Logons are NOT Inhibited!")
	Q
POSTINIT	; Post-Init
	D BMES^XPDUTL("Beginning Post-Installation...")
	I $$ROUSIZE^DILF=15000 D
	. D MES^XPDUTL("  Global ^DD(""ROU"") is already set to 15000. No action taken.")
	E  D
	. D MES^XPDUTL("  I am changing global ^DD(""ROU"") from "_$$ROUSIZE^DILF_"...")
	. S ^DD("ROU")=15000
	. D MES^XPDUTL("                                    ...to "_$$ROUSIZE^DILF)
	N LINE
	S LINE=$G(^DD("OS",19,"ZS"))
	;Begin WorldVistA change
	;I LINE["$P($P($P(",LINE?.E1"ZLINK X""" D
	I LINE["WorldVistA" D
	. ;End WorldVistA change
	. D BMES^XPDUTL("  The ZSAVE code has already been corrected for UNIX. No action taken.")
	E  D
	. D BMES^XPDUTL("  I am changing ^DD(""OS"",19,""ZS"") to correct the ZSAVE code for UNIX.")
	. ;Begin WorldVistA change
	. ;S LINE="N %I,%F,%S S %I=$I,%F=$P($P($P($ZRO,"")""),""("",2),"" "")_""/""_X_"".m"" O %F:(NEWVERSION) U %F X ""S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) "
	. S LINE="N %,%I,%F,%S S %I=$I,%F=$P($P($P($ZRO,"")""),""("",2),"" "")_""/""_X_"".m"" O %F:(NEWVERSION) U %F X ""S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) "
	. ;End WorldVistA change
	. S ^DD("OS",19,"ZS")=LINE_"Q:%S=""""""""  Q:'$D(^(%S))  S %=^UTILITY($J,0,%S) I $E(%)'="""";"""" W %,!"" C %F U %I X ""ZLINK X"""
	D MES^XPDUTL("Finished Post-Installation.")
	Q
