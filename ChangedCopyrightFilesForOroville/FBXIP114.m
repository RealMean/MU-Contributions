FBXIP114	;ALB/RC-PATCH INSTALL ROUTINE ;8:45 AM  20 Feb 2012
	;;3.5;FEE BASIS;**114**;JAN 30, 1995;Build 3;WorldVistA 30-June-08
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
	;;Per VHA Directive 2004-038, this routine should not be modified.
	Q
	;
PS	; post-install entry point
	; create KIDS checkpoints with call backs
	N FBX
	F FBX="EN" D
	.S Y=$$NEWCP^XPDUTL(FBX,FBX_"^FBXIP114")
	.I 'Y D BMES^XPDUTL("ERROR Creating "_FBX_" Checkpoint.")
	Q
	;
EN	; Begin Post-Install
	;re-index "AF" cross reference.
	;Begin WorldVistA change
	I '+$P($G(^FBAA(161.7,0)),U,4) Q  ;PREVENT DIK ERROR
	;End WorldVistA change
	N DIK
	S DIK="^FBAA(161.7,",DIK(1)="13^AF"
	D ENALL2^DIK ;Kill existing "AF" cross-reference.
	D ENALL^DIK ;Re-create "AF" cross-reference.
	Q
	;FBXIP114
