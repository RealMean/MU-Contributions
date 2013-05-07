PSOLMPO	;ISC-BHAM/LC - pending orders ;10:43 AM  3 Aug 2009
	;;7.0;OUTPATIENT PHARMACY;**46,225,208**;DEC 1997;Build 65;WorldVistA 30-June-08
	;
	;Modified from FOIA VISTA,
	; Changed from FOIA in WorldVistA EHR
	;
EN	; -- main entry point for PSO LM PENDING ORDER
	;Begin WorldVistA change; PSO*7*208 ;08/02/2009
	I $G(PSOAFYN)'="Y" S PSOLMC=0 D EN^VALM("PSO LM PENDING ORDER") K PSOLMC
	I $G(PSOAFYN)="Y" D ACP^PSOORNEW ;vfam
	;End WorldVistA change
	Q
	;
HDR	; -- header code
	D HDR^PSOLMUTL
	Q
	;
INIT	; -- init variables and list array
	;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
	S VALMCNT=IEN,VALM("TITLE")=$S($P(OR0,"^",23):"FL-",1:"")_"Pending OP Orders ("_$S($P(OR0,"^",14)="S":"STAT",$P(OR0,"^",14)="E":"EMERGENCY",1:"ROUTINE")_")"
	D RV^PSONFI
	Q
	;
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	K FLAGLINE D CLEAN^VALM10
	Q
	;
EXPND	; -- expand code
	Q
	;
