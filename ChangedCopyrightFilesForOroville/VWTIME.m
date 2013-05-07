VWTIME	; Report Age in Time / Date;3:48 PM  18 Sep 2011
	;;1.0;WorldVistA;;WorldVistA 30-June-08;Build 7
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
	QUIT  ;  No Fall Through
	;  =============
AGE(SD,ED,FLAG)	;
	; SD(Required) = Start Date, Time(optional)
	; ED(optional) = End Date, Time(optional)
	; FLAG(optional) = 0(default) Apply Health Care Rules
	;                = 1 Do not apply Health Care Rules
	;                = 2 Apply Health Care Rules + Verbose
	;                = 3 Do not apply Health Care Rules + Verbose
	; RESULT(Returned) = Age in:
	;                    years^months^weeks^days^hours^minutes^
	; Examples:
	; DATE: 3/5/47  (MAR 05, 1947)
	; FLAG:0=64^^^^^^
	; FLAG:1=64^6^^^7^20^
	; FLAG:2=64y
	; FLAG:3=64y 6m 7h 20m
	; FLAG:4=64years
	; FLAG:5=64years 6months 7hours 20minutes
	; DATE: 5/1/11  (MAY 01, 2011)
	; FLAG:0=0^4^^^^^
	; FLAG:1=^4^^5^7^21^
	; FLAG:2=4m
	; FLAG:3=4m 5d 7h 21m
	; FLAG:4=4months
	; FLAG:5=4months 5days 7hours 21minutes
	; DATE: T-30  (AUG 06, 2011)
	; FLAG:0=0^0^4^^^^
	; FLAG:1=^^4^2^7^22^
	; FLAG:2=4w
	; FLAG:3=4w 2d 7h 22m
	; FLAG:4=4weeks
	; FLAG:5=4weeks 2days 7hours 22minutes
	;   or               error message^^^^^
	;
	N DIFF,RESULT,X,I
	S SD=+$G(SD),ED=+$G(ED),FLAG=+$G(FLAG)
	I 'ED S ED=$$NOW^XLFDT
	;
	; Date validation & error handling
	I $P(SD,".")>DT S RESULT="Past Dates Only" G EXIT
	I 'SD S RESULT="Start Date Missing" G EXIT
	I SD<1000000 S RESULT="Invalid date" G EXIT
	I SD>ED S RESULT="Ending Date < Start Date" G EXIT
	;
	S $P(RESULT,U,7)=""
	S DIFF=$$FMDIFF^XLFDT(ED,SD,3) ;Get difference in Days HH:MM:SS
	; Time Frames
	; 1 Day    = 1
	; 1 WeeK   = 7
	; 1 Month  = 30.49
	; 1 Year   = 365.249
	N YR,MON,WEEK
	S YR=365.249,MON=30.49,WEEK=7
	S X=$P(DIFF," ") ;X=# DAYS
	I X>365.249 D  ;Calculate Years
	. S $P(RESULT,U)=X\YR
	. S X=(X#YR),X=X+.5,X=$P(X,".")
	.Q
	I X>30.49 D  ;Calculate Months
	. S $P(RESULT,U,2)=X\MON
	. S X=(X#MON),X=X+.5,X=$P(X,".")
	. Q
	I X>7 D  ;Calculate Weeks
	. S $P(RESULT,U,3)=X\WEEK
	. S X=(X#WEEK),X=X+.5,X=$P(X,".")
	. Q
	I X>1 S X=X+.5,$P(RESULT,U,4)=$P(X,".") ;Number of Days remaining
	S X=$P(DIFF," ",2)
	S $P(RESULT,U,5)=$P(X,":") ;Hours
	S $P(RESULT,U,6)=$P(X,":",2) ;Minutes
	;S $P(RESULT,U,7)=$P(X,":",3) ;Seconds
	;
	I FLAG=0 D HCRULE D  G EXIT ;Apply Health Care Rules, "^" format
	. N I,X S X=RESULT
	. F I=1:1:6 Q:$P(X,U,I)'=""  S $P(X,U,I)=0 ;Keep the current rVWEHR.pas happy
	. S RESULT=X
	. Q
	I FLAG=1 G EXIT ;Do not apply Health Care Rules, "^" format
	I FLAG=2 D HCRULE,BRIEF G EXIT ;Apply Health Care Rules & Brief format
	I FLAG=3 D BRIEF G EXIT ;Do not apply Health Care Rules, Brief format
	I FLAG=4 D HCRULE,LONG G EXIT ; Apply Health Care Rules & Long format
	I FLAG=5 D LONG ;Do not apply Health Care Rules, Long format
	;
EXIT	Q RESULT
	;
	;  ============
HCRULE	; Apply Health Care Business Rules
	;
	I $P(RESULT,U)>18 D  Q  ;Age > 18
	. F I=2:1:7 S $P(RESULT,U,I)=""
	. Q
	;
	I $P(RESULT,U)'<2 D  Q  ;Age 2 - 18
	. F I=3:1:7 S $P(RESULT,U,I)=""
	. Q
	;
	S X=($P(RESULT,U)*12)+$P(RESULT,U,2) ;Get Age in Months
	I X>3,X'>24 S $P(RESULT,U)="",$P(RESULT,U,2)=X D  Q  ;Age 4 mths - 23 mths
	. F I=3:1:7 S $P(RESULT,U,I)=""
	. Q
	;
	S X=($P(RESULT,U,2)*30.49)+($P(RESULT,U,3)*7)+$P(RESULT,U,4) ;Get Age in days
	I X>28 S $P(RESULT,U,2)="",$P(RESULT,U,3)=X\7 D  Q  ;Age 29 day - 4th month
	. F I=4:1:7 S $P(RESULT,U,I)=""
	. Q
	;
	S X=($P(RESULT,U,3)*7)+$P(RESULT,U,4) ;Get age in days
	I X>4,X<29 S $P(RESULT,U,3)="",$P(RESULT,U,4)=X D  Q  ;Age 5 days - 28 days
	. F I=5:1:7 S $P(RESULT,U,I)=""
	. Q
	;
	S X=($P(RESULT,U,4)*24)+$P(RESULT,U,5) ;Get age in hours
	I X>24 S $P(RESULT,U,4)="",$P(RESULT,U,5)=X D  Q  ;Age 24 hours - 96 hours
	. F I=6:1:7 S $P(RESULT,U,I)=""
	. Q
	Q
	;
	;  =============
BRIEF	; Add abbv. to values, like "y" for years, "m" for months, etc.
	N X,Y S X=RESULT,Y=""
	I +$P(X,U)>0 S Y=$P(X,U)_"yr"
	I +$P(X,U,2)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,2)_"mo"
	I +$P(X,U,3)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,3)_"wk"
	I +$P(X,U,4)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,4)_"d"
	I +$P(X,U,5)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,5)_"hr"
	I +$P(X,U,6)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,6)_"min"
	;I +$P(X,U,7)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,7)_"s"
	S RESULT=Y
	Q
	;
	;  =============
LONG	; Add words to values, like years, months, etc.
	N X,Y S X=RESULT,Y=""
	I +$P(X,U)>0 S Y=$P(X,U)_"year"_$S($P(X,U)>1:"s",1:"")
	I +$P(X,U,2)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,2)_"month"_$S($P(X,U,2)>1:"s",1:"")
	I +$P(X,U,3)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,3)_"week"_$S($P(X,U,3)>1:"s",1:"")
	I +$P(X,U,4)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,4)_"day"_$S($P(X,U,4)>1:"s",1:"")
	I +$P(X,U,5)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,5)_"hour"_$S($P(X,U,5)>1:"s",1:"")
	I +$P(X,U,6)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,6)_"minute"_$S($P(X,U,6)>1:"s",1:"")
	;I +$P(X,U,7)>0 S Y=Y_$S($L(Y):" ",1:"")_$P(X,U,7)_"seconds"_$S($P(X,U,7)>1:"s",1:"")
	S RESULT=Y
	Q
	;
	;  =============
LONGAGE(VWAGE,VWDFN)	; RPC FOR LONG AGE
	N VWDOB,VWDOD
	I +$G(VWDFN)<1 S VWAGE="Invalid Patient" Q
	S VWDOB=+$$OUTPUT(VWDFN)
	I '+$P(VWDOB,".") S VWAGE="Missing DOB" Q
	S VWDOD=$G(^DPT(VWDFN,.35)),VWDOD=$P(VWDOD,U) ;Get Date of Death
	S VWAGE=$$AGE(VWDOB,VWDOD,4)
	QUIT
	;  =============
BRFAGE(VWAGE,VWDFN)	; RPC FOR BRIEF AGE
	N VWDOB,VWDOD
	I +$G(VWDFN)<1 S VWAGE="Invalid Patient" Q
	S VWDOB=+$$OUTPUT(VWDFN)
	I '+$P(VWDOB,".") S VWAGE="Missing DOB" Q
	S VWDOD=$G(^DPT(VWDFN,.35)),VWDOD=$P(VWDOD,U) ;Get Date of Death
	S VWAGE=$$AGE(VWDOB,VWDOD,2)
	QUIT
	;  =============
RPCREG	; Register NEW RPCs
	N MENU,RPC,FDA,FDAIEN,ERR,DIERR
	S MENU="OR CPRS GUI CHART"
	F RPC="VWTIME LONG AGE","VWTIME BRIEF AGE" D
	. S FDA(19,"?1,",.01)=MENU
	. S FDA(19.05,"?+2,?1,",.01)=RPC
	. D UPDATE^DIE("E","FDA")
	. D CLEAN^DILF
	QUIT
	;  ============
INPUT	; Called from Date Of Birth(#.03), Patient(#2) file
	I DA<1 K X Q
	N FDA
	I '$P(X,".",2) S FDA(2,DA_",",540000.1)="" ;No time component
	I $P(X,".",2) S FDA(2,DA_",",540000.1)="."_$P(X,".",2) ;Time
	D FILE^DIE("","FDA")
	D CLEAN^DILF
	S X=$P(X,".")
	Q
	; ============
OUTPUT(DFN)	; Returns Date and Time of birth
	N X,TMP
	I DFN<1 S X="Invalid patient" Q X
	D GETS^DIQ(2,DFN_",",".03;540000.1","I","TMP")
	D CLEAN^DILF
	Q TMP(2,DFN_",",.03,"I")_TMP(2,DFN_",",540000.1,"I")
	; ===========
POST	; Called from build VW*1.0*250003
	D RPCREG
	; Add code here to move data from ^DD(2,540000.1 to final resting place
	Q
