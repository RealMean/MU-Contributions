XOBVGTM	;ISF/RWF - Vistalink startup for GT.M v5 from xinetd ;8/29/07  11:13
	;;1.0;VISTALINK;;WorldVistA 30-Jan-08;Build 21
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
GTMLNX	; -- Linux xinetd multi-thread entry point for GT.M
	;
	NEW XOBEC
	DO ESET^XOBVTCP
	;
	; **GTM/linux specific code**
	SET (IO,IO(0))=$P,@("$ZT=""""")
	X "U IO:(nowrap:nodelimiter:IOERROR=""TRAP"")" ;Setup device
	S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)"""),X=""
	X "ZSHOW ""D"":TMP"
	F %=1:1 Q:'$D(TMP($J,"D",%))  S X=^(%) Q:X["LOCAL"
	S IO("IP")=$P($P(X,"REMOTE=",2),"@"),IO("PORT")=+$P($P(X,"LOCAL=",2),"@",2)
	;End GT.M code
	;
	SET XOBEC=$$NEWOK^XOBVTCPL()
	IF XOBEC DO LOGINERR^XOBVTCPL(XOBEC,IO)
	IF 'XOBEC DO COUNT^XUSCNT(1),SPAWN^XOBVLL,COUNT^XUSCNT(-1)
	QUIT
	;
	;Sample linux scripts
	;xinetd script
	;vvvvvvvvvvvvvvvvvvvvvvvvv
	;service vistalink
	;{
	;   socket_type     = stream
	;   port            = 18001
	;   type            = UNLISTED
	;   user            = vista
	;   wait            = no
	;   disable         = no
	;   server          = /bin/bash
	;   server_args     = /home/vista/dev/vistalink.sh
	;   passenv         = REMOTE_HOST
	;}
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;
	;cat /home/vista/dev/vistalink.sh
	;vvvvvvvvvvvvvvvvvvvvvvvvvvvv
	;#!/bin/bash
	;#RPC Broker
	;cd /home/vista/dev
	;. ./gtmprofile
	;$gtm_dist/mumps -r GTMLNX^XOBVGTM
	;exit 0
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
