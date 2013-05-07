VWHLUT	;WVEHR/John McCormack- World VistA HL Table Utilities; 4 June 2012
	;;1.0;;**250068**;Sep 27, 1994;Build 14
	;;WVEHR-1007;WORLD VISTA;*WVEHR1*;;Build 12
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
FILE2CWE(VW260,VWPOS,VWFS,VWECH,VWLV,VWVER,VWCS)	; File #260 entry to HL7 CWE field/component
	; Call with VW260 =  internal entry number of entry in file #260 to encode
	;           VWPOS = 1 (primary) / 2 (alternate) code system
	;            VWFS = HL field separator
	;           VWECH = HL encoding characters
	;            VWLV = component (1) / sub-component (2) level in message
	;           VWVER = HL7 Version
	;            VWCS = Code system to use
	;
	; Returns   VWOUT = checked data, escaped encoded if appropriate
	;
	;
	N I,VWIEN,VWX
	;
	S VWOUT=""
	I $G(VWLV)<1 S VWLV=1
	;
	; If no version then default to HL7 2.5.1
	I VWVER="" S VWVER="HL7 2.5.1"
	;
	S VWIEN=$O(^VWLEX(260,VW260,1,"B",VWVER,0))
	; If version does not exist then default to HL7 2.5.1
	I VWIEN D
	. S VWVER="HL7 2.5.1"
	. S VWIEN=$O(^VWLEX(260,VW260,1,"B",VWVER,0))
	;
	F I=0,.02,.03,1 S VWIEN(I)=$G(^VWLEX(260,VW260,1,VWIEN,I))
	;
	S VWX(1)=$$CHKDATA(VWIEN(.02),VWFS_VWECH)
	S VWX(2)=$$CHKDATA(VWIEN(.03),VWFS_VWECH)
	;
	; Retrieve OID
	;S VWX(3)=$P(VWIEN(0),"^",6)
	; Retrieve code system name
	S VWX(3)=$P(VWIEN(0),"^",5)
	;
	; Coding system version
	S VWX(4)=""
	I $P(VWIEN(1),"^")'="" S VWX(4)=$$CHKDATA($P(VWIEN(1),"^"),VWFS_VWECH)
	I VWX(4)="",$E($P(VWIEN(0),"^",5),1,3)="HL7" S VWX(4)=VWVER
	;
	; Build field/component based on parameters passed in.
	I VWPOS=1 F I=1,2,3,7 S $P(VWOUT,$S(VWLV=1:$E(VWECH),1:$E(VWECH,4)),I)=VWX($S(I=7:4,1:I))
	I VWPOS=2 F I=4,5,6,8 S $P(VWOUT,$S(VWLV=1:$E(VWECH),1:$E(VWECH,4)),I)=VWX($S(I=8:4,1:I-3))
	;
	;
	Q VWOUT
	;
	;
CHKDATA(VWIN,VWCH)	; Check data to be built into an HL7 field for characters that
	; conflict with encoding characters. Convert conflicting character using HL7 escape encoding.
	;
	; Call with VWIN = data to be checked
	;           VWCH = HL7 delimiters to check for
	;
	; Returns VWOUT - checked data, converted if appropriate
	;
	N VWOUT
	;
	D CHKDATA^VWHLUT1
	;
	Q VWOUT
	;
	;
CNVFLD(VWIN,VWECH1,VWECH2)	; Convert an encoded HL7 segment/field from one encoding scheme to another
	; Call with   VWIN = data to be converted
	;           VWECH1 = delimiters of input
	;           VWECH2 = delimiters of output
	;
	; Returns VWOUT - segment/field converted to new encoding scheme
	;
	D CNVFLD^VWHLUT1
	;
	Q VWOUT
	;
	;
ENESC(VWX,VWESC)	; Encode data using HL7 escape encoding
	; Call with   VWX = character to encode
	;           VWESC = HL7 escape encoding character
	;
	; Returns string of escape encoded data.
	;
	N VWY
	;
	S VWY=VWESC_VWX_VWESC
	;
	Q VWY
	;
	;
UNESC(VWX,VWCH)	; Unescape data using HL7 escape encoding
	; Call with  VWX = string to decode
	;           VWCH = HL7 delimiters (both field separator & encoding characters)
	;
	; Returns string of unencoded data.
	;
	D UNESC^VWHLUT1
	;
	Q VWX
	;
	;
UNESCFT(VWX,VWCH,VWY)	; Unescape formatted text data using HL7 escape encoding
	; Call with  VWX = array to decode (pass by reference)
	;           VWCH = HL7 delimiters (both field separator & encoding characters)
	;
	; Returns    VWY =  array of unencoded data (pass by reference).
	;
	D UNESCFT^VWHLUT1
	;
	Q
	;
	;
MSH(VWHDR,VW773,VWFS,VWECH)	; Build MSH segment
	; Call with VWHDR = variable to contain MSH segment, passed by reference
	;           VW773 = Pointer to entry in Message Administration file (#773)
	;            VWFS = HL field separator
	;           VWECH = HL encoding characters
	;
	; Returns   VWHDR = MSH segment, passed by reference.
	;
	; Called from HLCSDHR1
	;
	N VW101,VW772,VWMSH,VWX
	;
	S VWMSH(0)="MSH"
	S VWMSH(1)=EC
	S VWMSH(2)=SERAPP
	S VWMSH(3)=SERFAC
	S VWMSH(4)=CLNTAPP
	S VWMSH(5)=CLNTFAC
	S VWMSH(6)=HLDATE
	S VWMSH(7)=SECURITY
	S VWMSH(8)=MSGTYPE
	S VWMSH(9)=HLID
	S VWMSH(10)=HLPID
	S VWMSH(11)=$P(PROT,U,9)
	S VWMSH(12)=""
	S VWMSH(13)=$G(^HL(772,TXTP,1))
	S VWMSH(14)=ACCACK
	S VWMSH(15)=APPACK
	S VWMSH(16)=CNTRY
	;
	; Construct Message Profile Identifier
	S VW772=$P($G(^HLMA(VW773,0)),U)
	I VW772 D
	. S VW101=+$P($G(^HL(772,VW772,0)),U,10),VWX=""
	. I VW101 S VWX=$$MPI(VW101,VWFS,VWECH)
	. I VWX'="" S VWMSH(20)=VWX
	;
	; Buildup MSH segment
	D BUILDSEG(.VWHDR,.VWMSH,VWFS)
	D ^%ZTER
	Q
	;
	;
MPI(VW101,VWFS,VWECH)	; Construct message profile identifier - can be repeating field up to 427 characters
	; Call with VW101 = IEN of protocol in file #101 to use to construct MPI. 
	;            VWFS = HL field separator
	;           VWECH = HL encoding characters
	;
	; Returns   VWMPI = message profile identifier
	;
	N VWCOUNT,VWJ,VWK,VWMPI,VWX,VWY
	S VWMPI="",VWCOUNT=0
	;
	S VWI=0
	F  S VWI=$O(^ORD(101,VW101,770.021,VWI)) Q:VWI<1  D
	. S VWJ=+^ORD(101,VW101,770.021,VWI,0)
	. S VWJ(0)=$G(^HL(779.0059,VWJ,0))
	. I VWJ(0)="" Q
	. S VWY=""
	. S VWX(1)=$E($G(^HL(779.0059,VWJ,1)),1,199)
	. S VWX(2)=$P(VWJ(0),U,2)
	. S VWX(3)=$E($G(^HL(779.0059,VWJ,3)),1,199)
	. S VWX(4)=$P(VWJ(0),U,3)
	. F VWK=1:1:4 I VWX(VWK)'="" S $P(VWY,$E(VWECH,1),VWK)=$$CHKDATA(VWX(VWK),VWFS_VWECH)
	. S VWCOUNT=VWCOUNT+1,VWMPI=VWMPI_$S(VWCOUNT>1:$E(VWECH,2),1:"")_VWY
	;
	Q VWMPI
	;
	;
SFT(VWFS,VWECH)	; Build SFT segment
	;
	; Call with VWFS = HL field separator
	;          VWECH = HL encoding characters
	; 
	; Returns    VWY = SFT segment based on site's settings.
	;
	N I,SFT,VWX,VWY
	;
	S SFT(0)="SFT"
	;
	; Construct SFT-1 Software Vendor Organization (XON)
	S VWX="WorldVistA"
	S SFT(1)=$$CHKDATA(VWX,VWFS_VWECH)
	;
	; Construct SFT-2  Software Certified Version or Release Number (ST)
	S SFT(2)="1.0"
	;
	; Construct SFT-3 Software Product Name (ST)
	S VWX="WorldVistA EHR"
	S SFT(3)=$$CHKDATA(VWX,VWFS_VWECH)
	;
	; Construct SFT-4 Software Binary ID (ST)
	S VWX="20110614"
	S SFT(4)=VWX_"-"_$$CRC16^XLFCRC(VWX,0)
	;
	; Construct SFT-5 Software Product Information (TX)
	; Sent when performing diagnostics.
	S SFT(5)=""
	;
	; Construct SFT-6 Software Install Date (DTM)
	;  Note: should be parameter that is updated when patches are installed.
	S SFT(6)="20110614"
	;
	S VWY=""
	F I=0:1:6 S $P(VWY,VWFS,I+1)=SFT(I)
	;
	Q VWY
	;
	;
BUILDSEG(LA7DATA,LA7ARRAY,LA7FS)	; Build HL segment
	; Call with       LA7DATA = array used to build segment, pass by reference, used to return built segment.
	;                LA7ARRAY = array containing fields to build into a segment, passed by reference.
	;                   LA7FS = HL field separator
	;
	; Returns      LA7DATA(1) = if everything fits on one node
	;         LA7DATA(1,2...) = multiple elements if >245 characters
	;
	N LA7I,LA7J,LA7LAST,LA7SUB
	;
	K LA7DATA
	;
	S LA7FS=$G(LA7FS)
	;
	; Node to store data in array
	S LA7SUB=1
	;
	; Last element in array
	S LA7LAST=$O(LA7ARRAY(""),-1)
	;
	F LA7I=0:1:LA7LAST D
	. I ($L($G(LA7DATA(LA7SUB)))+$L($G(LA7ARRAY(LA7I))))>245 S LA7SUB=LA7SUB+1
	. I $O(LA7ARRAY(LA7I,""))'="" D
	. . S LA7J=""
	. . F  S LA7J=$O(LA7ARRAY(LA7I,LA7J)) Q:LA7J=""  D
	. . . I ($L($G(LA7DATA(LA7SUB)))+$L($G(LA7ARRAY(LA7I,LA7J))))>245 S LA7SUB=LA7SUB+1
	. . . S LA7DATA(LA7SUB)=$G(LA7DATA(LA7SUB))_$G(LA7ARRAY(LA7I,LA7J))
	. S LA7DATA(LA7SUB)=$G(LA7DATA(LA7SUB))_$G(LA7ARRAY(LA7I))_LA7FS
	Q
