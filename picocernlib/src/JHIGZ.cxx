#include "TColor.h"
#include "TLatex.h"
#include "TList.h"
#include "TMath.h"
#include "TText.h"
#include "TPad.h"
#include "TApplication.h"
#include "TCanvas.h"
#include "TTree.h"
#include "TBox.h"
#include "TStyle.h"
#include "TPaveLabel.h"
#include "TPolyLine.h"
#include "TPolyMarker.h"
#include <iostream>
#include <map>
#include <string>
#include <sstream>

#define JADEZROOT

#ifndef JADEZROOT
TApplication* jApplication;
#endif
int UPDATER;
//std::map<int,TCanvas*>   jCanvas;
TCanvas*   jCanvas;
std::map<int,int>   jColors;
TPad*   jPad;
int jTextAlignment;
float jTextSize;
int jTextAngle;
int jTextColor;
int jLineColor;
int jLineStyle;
int jFillAreaColor;

int jPolyMarkerColor;
int jPolyLineColor;
float jPolyMarkerSize;
float jPolyLineWidth;

std::map<int,double>  gSX,gSY;
std::map<int,double>  grSX,grSY;



#include <TApplication.h>
#include <TRootEmbeddedCanvas.h>
#include "Frame.h"
Frame* jFrame;
void showFrame() {
    // Popup the GUI...
    jFrame=new Frame(gClient->GetRoot(),200,200);
}


std::map<int,std::vector<double> >  gWN;

int jNT;
#define DEBUG 1
#ifdef DEBUG
 #define DDDD if(1) 
#else
 #define DDDD if(0) 
#endif

#define BIGK 2.0

extern "C" {
/*
void igstrt_()
{
//Init

}
*/

//      CALL ISWN(NTS,XTMIN,XTMAX,YTMIN,YTMAX)
//      CALL ISVP(NTS,0.,1.,0.,1.)

void iswn_(int &NTS,float &XTMIN,float &XTMAX,float &YTMIN,float &YTMAX)
{
/*Action: This routine sets the boundaries of the window of a normalization transformation. The window
must be specified in world coordinates. The boundaries of the window, together with the boundaries of
the viewport (which are in normalized device coordinates) determine a transformation from world coor-
dinates to normalized device coordinates consisting of separate X and Y scale factors and a translation in
two dimensions. The normalization transformation is selected by using routine ISELNT.
Parameter description:
NT
 Normalization transformation index (0<NT<1000000).
XMIN
 X coordinate of the lower left hand corner in WC space.
XMAX
 X coordinate of the upper right hand corner in WC space.
YMIN
 Y coordinate of the lower left hand corner in WC space.
YMAX
 Y coordinate of the upper right hand corner in WC space.

*/
//DDDD 
printf("iswn_(int &NTS,float &XTMIN,float &XTMAX,float &YTMIN,float &YTMAX)  %i %f %f %f %f\n", NTS, XTMIN, XTMAX, YTMIN, YTMAX);

std::vector<double> a;
a.push_back(XTMIN);
a.push_back(YTMIN);
a.push_back(XTMAX);
a.push_back(YTMAX);
gWN[NTS]=a;

//if (NTS==8&&gWN.find(9)==gWN.end())gWN[9]=a;

}


void isvp_(int &NTS,float &XTMIN,float &XTMAX,float &YTMIN,float &YTMAX)
{
/*	
	
Action: This routine sets the boundaries of the viewport of a normalization transformation. The viewport
must be specified in normalized device coordinates. The boundaries of the viewport have two roles:
1 Together with the boundaries of the window (which are in world coordinates) they determine a
transformation from world coordinates to normalized device coordinates consisting of separate X
and Y scale factors and a translation in two dimensions.
2 When the clipping indicator is 1 (see ISCLIP), primitives are clipped to the boundary of the view-
port (once the primitives are transformed to normalized device coordinates)
The normalization transformation is selected with the routine ISELNT.
Parameter description:
3.2. The coordinate systems and transformations
 17
NT
 Normalization transformation index (0<NT<1000000).
XMIN
 X coordinate of the lower left hand corner in NDC space (0.0 ≤XMIN≤ 1.0).
XMAX
 X coordinate of the upper right hand corner in NDC space (0.0 ≤XMAX≤ 1.0).
YMIN
 Y coordinate of the lower left hand corner in NDC space (0.0 ≤YMIN≤ 1.0).
YMAX
 Y coordinate of the upper right hand corner in NDC space (0.0 ≤YMAX≤ 1.0).
The last four parameters must satisfy the conditions XMIN < XMAX and YMIN < YMAX.


*/
//DDDD 
printf("void isvp_(int &NTS,float &XTMIN,float &XTMAX,float &YTMIN,float &YTMAX)  %i %f %f %f %f\n", NTS, XTMIN, XTMAX, YTMIN, YTMAX);

if (!jCanvas)   {
   // jCanvas= new TCanvas("jCanvas","JADE Display",768,768); 
    jCanvas =jFrame->fEcanvas->GetCanvas();
    
    jPad= new TPad("Jpad","Jpad",0,0,1,1); 
   jPad->SetFillStyle(4000);
   jPad->SetFillColor(0);
   jPad->SetFrameFillStyle(4000);
    jPad->Draw();

    jPad->cd();
    if (gWN.find(NTS)!=gWN.end())
gPad->Range(BIGK*gWN[NTS][0],BIGK*gWN[NTS][1],BIGK*gWN[NTS][2],BIGK*gWN[NTS][3]);
//gPad->Range(gWN[NTS][0],gWN[NTS][1],gWN[NTS][2],gWN[NTS][3]);
else
{
printf("Error in void isvp_\n",NTS);

}
    gPad->Update();
    

}
     jCanvas->cd();
      
     if ( NTS==9) 
     {
  //  TPad* pad= new TPad(Form("jCanvas%iPad%i",NTS,jCanvas[NTS]->GetListOfPrimitives()->GetSize()+1),"jPad", XTMIN, YTMIN, XTMAX, YTMAX);
    
    if (jCanvas->GetListOfPrimitives()->FindObject("Jpad")) jCanvas->GetListOfPrimitives()->FindObject("Jpad")->Delete();
    TString pname=Form("jCanvasPad%2.2f_%2.2f_%2.2f_%2.2f",XTMIN, YTMIN, XTMAX, YTMAX);
    TPad* pad=(TPad*)(jCanvas->GetListOfPrimitives()->FindObject(pname));
    if (!pad) pad= new TPad(pname,"jPad", XTMIN, YTMIN, XTMAX, YTMAX);
    
    pad->SetFillStyle(4000);
    pad->SetFillColor(0);
    pad->SetFrameFillStyle(4000);
    gPad->Update();
    pad->Draw();
    pad->cd();
    if (gWN.find(NTS)!=gWN.end())
    gPad->Range(BIGK*gWN[NTS][0],BIGK*gWN[NTS][1],BIGK*gWN[NTS][2],BIGK*gWN[NTS][3]);
//gPad->Range(gWN[NTS][0],gWN[NTS][1],gWN[NTS][2],gWN[NTS][3]);
    else
    printf("Error in void isvp_\n",NTS);
    gPad->Update();
    }
   
   if (NTS==8)
   {
   if (jCanvas->GetListOfPrimitives()->FindObject("Jpad")) 
   { ((TPad*)(jCanvas->GetListOfPrimitives()->FindObject("Jpad")))->cd();
   if (gWN.find(NTS)!=gWN.end())
   gPad->Range(BIGK*gWN[NTS][0],BIGK*gWN[NTS][1],BIGK*gWN[NTS][2],BIGK*gWN[NTS][3]);
//gPad->Range(gWN[NTS][0],gWN[NTS][1],gWN[NTS][2],gWN[NTS][3]); 
   }
   else
   printf("Error in void isvp_\n",NTS);
   gPad->Update();
   }   
   printf("jCanvas->GetListOfPrimitives()->GetSize()=%i\n",jCanvas->GetListOfPrimitives()->GetSize());
}


//`iselnt_'
void iselnt_(int & t)
{
//DDDD printf("void iselnt_(int & t)  %i\n",t);
	jNT=t;
if (gWN.find(t)!=gWN.end())
gPad->Range(BIGK*gWN[t][0],BIGK*gWN[t][1],BIGK*gWN[t][2],BIGK*gWN[t][3]);
//gPad->Range(gWN[t][0],gWN[t][1],gWN[t][2],gWN[t][3]);
else
{
printf("Error in void iselnt_(int & t)  %i\n",t);

}
}	



//`iclrwk_'

void iclrwk_()
{
puts("iclrwk_()\n");
//if (jCanvas) if(jCanvas->GetPad(1)) jCanvas->GetPad(1)->Clear();
//if(gPad) gPad->Clear();
}	


//`iclwk_'
void iclwk_()
{
	puts("iclwk_()\n");
	//if (gPad) gPad->Clear();
//terminates usage of ws
}


//`igbox_'

void igbox_(float& x1, float & x2,float& y1, float & y2)
{
//DDDD 
printf("void igbox_(float& x1, float & x2,float& y1, float & y2) %f %f %f %f\n",x1,y1,x2,y2);
TBox* B= new TBox(x1,y1,x2,y2);
B->SetFillColor(1);
B->SetFillStyle(1);
B->SetLineWidth(1);
B->SetLineColor(1);
B->Draw();
gPad->Update();
}	

void ixbox_(float& x1, float & x2,float& y1, float & y2, int mode)
{
//DDDD 
printf("void ixbox_(float& x1, float & x2,float& y1, float & y2) %f %f %f %f\n",x1,y1,x2,y2);
TBox* B= new TBox(x1,y1,x2,y2);
B->SetFillColor(1);
B->SetFillStyle(1);
B->SetLineWidth(1);
B->SetLineColor(1);
B->Draw();
gPad->Update();
}	


void igrng_(float *a, float*b)
{
	
	
}	

void igset_(char* a, float& val){
/*
CALL IGSET
 (CHNAME,VAL)
Action: Routine used to set the value of attributes related to primitives and/or macroprimitives. The first
parameter is the mnemonic name of the parameter, the second is the value to be assigned. Note that all
the basic primitives attributes can also be set with this routine.
CHNAME
VAL
Character variable specifying the name of the parameter to be set (type CHARACTER*4). This
is an UPPERCASE character string.
Floating point value of the parameter (must be specified as a REAL number).
A value of 0.0 indicates that the parameter value must be reset to its default value.
*/
DDDD printf("  void igset_(char* , float& val){ %s %f\n",a,val);
//jTextAngle=atan(val)*180.0/TMath::Pi();
jTextAngle=val*180.0/TMath::Pi();
}


//`iginit_'
void iginit_(int& a)
{
DDDD printf("iginit_(int a)   %i\n",a);	
#ifndef JADEZROOT
jApplication=new TApplication("Jade display",0,0);
#else
showFrame();
#endif
jTextSize=0.01;
jTextColor=kRed;
jLineColor=kBlack;
jPolyLineColor=kBlack;

jFillAreaColor=kWhite;
jTextAlignment=12;
jTextAngle=0;
jNT=0;
std::vector<double> az;
az.push_back(0);
az.push_back(0);
az.push_back(2*4096);
az.push_back(2*4096);
gWN[0]=az;
jPolyMarkerSize=1.1;
jPolyLineWidth=1.0;

jLineStyle=kSolid;

/*

ixsetco 11 0.400000 0.400000 0.400000
ixsetco 12 0.000000 0.700000 1.000000
ixsetco 13 1.000000 0.600000 0.000000
ixsetco 14 0.000000 0.900000 0.000000
ixsetco 15 0.000000 1.000000 0.500000
ixsetco 16 1.000000 0.000000 0.000000
ixsetco 17 8.000000 1.000000 0.000000
ixsetco 18 1.000000 1.000000 0.000000
ixsetco 19 0.000000 0.000000 0.500000
ixsetco 20 0.000000 1.000000 0.000000
ixsetco 100 1.000000 1.000000 1.000000
ixsetco 101 0.000000 0.000000 0.000000

 */ 

jColors[0]=kWhite;
jColors[1]=kBlack;
jColors[2]=kRed;
jColors[3]=kGreen;
jColors[4]=kBlue;
jColors[5]=kYellow;
jColors[6]=kViolet;
jColors[7]=kCyan;

}	

//`igend_'
void igend_()
{
#ifndef JADEZROOT
jApplication->Run();	
#endif
}	


//`igloc_'

void igloc_(int *is, int nt, int BN, float &a,float &b,float &c,float &d)
{
DDDD printf("igloc_(int *is, int nt, int BN, float &a,float &b,float &c,float &d)\n");
}	

//`igmess_'
void igmess_(int &n,char** chmess,char *chtit,char chopt)
{
	
	
}	
//`igmeta_'
void igmeta_(int& LUN, int& KWTYPE)
{
	
	
}	
//`igpave_'
//(X1,X2,Y1,Y2,DZ,ISBOX,ISFRAM,CHOPT)
void igpave_(float& x1, float&  x2,float& y1,float& y2,int*, int*,const char* )
{
	//DDDD 
	printf("igpave_(float& x1, float&  x2,float& y1,float y2, %f %f %f %f\n",x1,y1,x2,y2);
//	double f=0.1;
   gPad->cd();
	TPave* P= new TPave(x1,y1,x2,y2);
	P->Draw();
}	
/*`
`igrng_'
`igset_'
`igsse_'
`igterm_'
*/ 

//`ipl_'
void ipl_(int&n, float* x, float* y)
{
	//DDDD 		
	//printf("ipl_(int&n, float x, float y) %i,%f %f\n", n, x[0], y[0]);
	float l=0;
	if (n==2) {l=pow(x[0]-x[1],2)+pow(y[0]-y[1],2);
		if (l>10000)
		printf("ipl_(int&n, float x, float y) %i,%f %f   %f %f\n", n, x[0], y[0], x[1], y[1]);
	}
	gPad->cd();
	//TPolyLine* P=new TPolyLine(n,X,Y);
	TPolyLine* P=new TPolyLine(n,x,y);
	P->SetLineWidth(jPolyLineWidth);
	P->SetLineStyle(jLineStyle);
	P->SetLineColor(jPolyLineColor);
	P->Draw();
	//gPad->Update();
	//gPad->SaveAs("2.C");
	
}	


//`ipm_'
void ipm_(int&n, float* x, float* y)
{
	gPad->cd();
//	DDDD  printf("void ipm_(int&n, float* x, float* y) %i,%f %f\n", n, x[0], y[0]);
	TPolyMarker* P=new TPolyMarker(n,x,y);
	//P->SetLineWidth(1);
	//P->SetLineStyle(1);
	P->SetMarkerColor(jPolyMarkerColor);
	P->SetMarkerSize(jPolyMarkerSize);
//	P->SetMarkerStyle(kStar);
	P->Draw();
}	


//`ischh_'
void ischh_(float& h)
{
/*
GKS
 CALL ISCHH
 (CHH)
Action: This routine sets the character height attribute for use by future invocations of ITX. The routine
IGSET (see section 4.11) can also be used with the parameter CHHE.
Parameter description:
CHH
 Character height. The default set by IGSSE is 0.01. The height is given in world coordi-
nates and it must be positive.
*/
//gStyle->SetFontSize(h);
 DDDD printf(" ischh  %f,  NOT IMPLEMENTED\n",h);
 if (h<1) jTextSize=h;
if (h>10)
 jTextSize=0.01;

} 
//`iscr_'
void iscr_(int &w, int &ci, float &r,float&g,float&b)
{
	
	
	
}	


void isfaci_(int& a )
{
/*
Action: This routine sets the fill area colour index attribute for use by future invocations of IFA. The
routine IGSET (see section 4.11) can also be used with the parameter FACI.
Parameter description:
ICOLI
 Fill area colour index.

*/
DDDD printf("isfaci_(int& col )   %i\n",a);

}	

void isfais_(int& a )
{
/*
Action: This routine sets the fill area interior style attribute for use by future invocations of IFA. The
routine IGSET (see section 4.11) can also be used with the parameter FAIS.
Parameter description:
INTS
 Fill area interior style. Possible values are:
0
 Hollow: the perimeter of the filled area, after clipping, is drawn using solid lines.
1
 Solid: the area is filled solidly.
2
 Pattern: the area is filled with a dot-dashed pattern.
3
 Hatched: the area is filled according to the current value of the fill area style index.


*/


DDDD printf("isfais_(int& sty )  %i\n",a);

}	

void isln_(int &a)
{
/*
Action: This routine sets the line type attribute for use b
* y future invocations of IPL. All workstations
support at least line types 1 through 4 (see figure 3.5). Other line types may be supported. If a requested
line type is not supported on a workstation, line type 1 is used when polylines are created. The routine
IGSET (see section 4.11) can also be used with the parameter LTYP.
Parameter description:
LTYPE
Line type (positive number).
1
 Solid lines
2
 Dashed lines
3
 Dotted lines
4
 Dashed-dotted lines
*/

DDDD printf("isln_(int *a)  %i\n",a);

if (a==1)jLineStyle=kSolid;
if (a==2)jLineStyle=kDashed;
if (a==3)jLineStyle=kDotted;
if (a==4)jLineStyle= kDashDotted;

}



void islwsc_(float& a)
{
/*
Action: This routine sets the width of a line for use by future invocations of the polyline drawing routine
IPL. The actual line width is determined by a nominal line width (workstation-dependent) multiplied by
the line width scale factor. The nominal line width is one pixel on screens. On PostScript printers the
nominal line width is one “dot”. Therefore the width of a line can vary from a printer to another depending
on the printer definition (300 dots per inch, 400 dots per inch etc.). The figure 3.6 shows some examples
of various line width. The routine IGSET (see section 4.11) can also be used with the parameter LWID.
Parameter description:
WIDTH
 Line width scale factor.
*/
DDDD printf("islwsc_(int& a)  %f\n",a);
jPolyLineWidth=a;

}



void ismk_(int &a)
{
/*
Action: This routine sets the marker type attribute for use by future invocations of IPM. All workstations
support at least the marker types 1 through 5 (see below). More marker types may be supported by the
underlying graphics package. Marker types 20 to 31 are also defined, according to the figure 3.7, and
are independent from the underlying graphics package used. If a requested marker type is not supported
on a workstation, marker type 1 (a point) is used when polymarkers are created. The routine IGSET (see
section 4.11) can also be used with the parameter MTYP.
Parameter description:
MTYPE
Marker type (positive number)
1 Point shape (·).
2 Plus shape (+).
3 Asterisk shape (∗).
4 Circle shape (◦).
5 X shape (×).
*/
	DDDD printf("ismk_(int &a)  %i\n",a);
//switch (a):
//{
//case 1: gStyle->SetMarkerStyle(kPoint); break
//case 2: gStyle->SetMarkerStyle(kPoint); break
//case 3: gStyle->SetMarkerStyle(kPoint); break
//case 4: gStyle->SetMarkerStyle(kCircle); break
//case 5: gStyle->SetMarkerStyle(kPoint); break
//default: break;
//}

}	
void ismksc_(int a)
{
/*
Action: This routine sets the marker scale factor. This scale factor is applied on the nominal size of the
marker. On all workstation, except PostScript files, the marker type 1 is not scalable. The routine IGSET
(see section 4.11) can also be used with the parameter MSCF.
Parameter description:
SSFM
 Scale factor applied to markers. (≥ 0.)
*/	
	
		DDDD printf("ismksc_  %i\n",a);
	gStyle->SetMarkerSize(1.0+0.1*a);
}	

/*
`isplci_'
`ispmci_'
`istxal_'
`istxci_'
`istxfp_'
`isvp_'
`iswn_'
`itx_'
`iuwk_'
`ixbox_'
`ixsetco_'
`ixsetfc_'
`ixsetlc_'
`ixsetln_'
`ixsetmc_'
`ixsettc_'
*/
void ixsync_(bool mode)
{
	printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);
	
}	




void iuwk_(int&a, int&b)
{
/*
GKS
 CALL IUWK
 (KWKID,IRFLG)
Action: This routine updates the workstation KWKID. It send all buffered output to the screen. In the
X11 version of HIGZ, this routine allows to flush the X11 buffer. This routine is usually called with the
first parameter equal to 0 and the second to 1.
Parameter description:
KWKID
 Workstation identifier. KWKID = 0 updates all the current open workstations.
IRFLG
 Regeneration flag:
0
 postpone update workstation (only when the underlying graphics package is GKS)
1
 refresh entire display
2
 update current view
*/

//DDDD 
//printf("iuwk_(int&a, int&b) %i, %i\n",a,b);
 
	gPad->Modified();
	gPad->Update();
}



void itx_(float &x, float &y, char* txt)
{
 //DDDD   
 printf("void itx_(float &x, float &y, char* txt)   %f %f %s, jTextAlignment=%i  jTextAngle=%f\n", x,y, txt, jTextAlignment,jTextAngle );
   std::string vn(txt);
if (vn.size()>0)vn[vn.size()-1]=0;
//stripUnicode(vn);
while (vn.back()==' '||vn.back()=='\n') vn.pop_back();
   
   
   
   //TText *t = new TText(grSX[jNT]*x,grSY[jNT]*y,txt);
   TText *t;
   t = new TText(x,y,vn.c_str());
   //t->SetNDC(false);
   t->SetTextAlign(jTextAlignment-jTextAlignment%10+1);
   t->SetTextColor(jTextColor);
 //  t->SetTextColor(kRed);
   t->SetTextFont(82);
   //t->SetTextSize(jTextSize*grSY[jNT]);
   t->SetTextSize(jTextSize);
   t->SetTextAngle(jTextAngle);
   t->Draw();


}	


void itxn_(float &x, float &y, char* txt, int& n)
{
 //DDDD   
 printf("void itxn_(float &x, float &y, char* txt)   %f %f %s, jTextAlignment=%i  jTextAngle=%f\n", x,y, txt, jTextAlignment,jTextAngle );
   std::string vn(txt);
if (vn.size()>0)vn[vn.size()-1]=0;
//stripUnicode(vn);
while (vn.back()==' '||vn.back()=='\n') vn.pop_back();
vn=vn.substr(0,std::min((int)vn.size(),n));
   
   
   //TText *t = new TText(grSX[jNT]*x,grSY[jNT]*y,txt);
   TText *t;
   t = new TText(x,y,vn.c_str());
   //t->SetNDC(false);
   t->SetTextAlign(jTextAlignment-jTextAlignment%10+1);
   t->SetTextColor(jTextColor);
 //  t->SetTextColor(kRed);
   t->SetTextFont(82);
   //t->SetTextSize(jTextSize*grSY[jNT]);
   t->SetTextSize(jTextSize);
   t->SetTextAngle(jTextAngle);
   t->Draw();


}	




void drawpi_(float &x, float &y)
{
DDDD   printf("void drawpi_(float &x, float &y)   %f %f , jTextAlignment=%i  jTextAngle=%f\n", x,y, jTextAlignment,jTextAngle );
   TLatex *t;
   t = new TLatex();
   t->SetTextAlign(jTextAlignment-jTextAlignment%10+1);
   t->SetTextColor(jTextColor);
   t->SetTextFont(82);
   t->SetTextSize(0.015);
   t->SetTextAngle(jTextAngle);
   t->DrawLatex(x,y,"#pi");
}

void drawmu_(float &x, float &y)
{
DDDD   printf("void drawmu_(float &x, float &y)   %f %f , jTextAlignment=%i  jTextAngle=%f\n", x,y,  jTextAlignment,jTextAngle );
   TLatex *t;
   t = new TLatex();
   t->SetTextAlign(jTextAlignment-jTextAlignment%10+1);
   t->SetTextColor(jTextColor);
   t->SetTextFont(82);
   t->SetTextSize(jTextSize);
   t->SetTextAngle(jTextAngle);
   t->DrawLatex(x,y,"#mu");
}




void itxl_(float &x, float &y, char* txt, int& l)
{
 //DDDD   printf("void itx_(float &x, float &y, char* txt)   %f %f %s, jTextAlignment=%i  jTextAngle=%f\n", x,y, txt, jTextAlignment,jTextAngle );
   std::string vn(txt);
while (vn.back()==' '||vn.back()=='\n') vn.pop_back();

vn=vn.substr(0,std::min((int)(vn.length()),l));   
   //TText *t = new TText(grSX[jNT]*x,grSY[jNT]*y,txt);
   TText *t;
   t = new TText(x,y,vn.c_str());
   //t->SetNDC(false);
   t->SetTextAlign(jTextAlignment-jTextAlignment%10+1);
   t->SetTextColor(jTextColor);
 //  t->SetTextColor(kRed);
   t->SetTextFont(82);
   //t->SetTextSize(jTextSize*grSY[jNT]);
   t->SetTextSize(0.015);
   t->SetTextAngle(jTextAngle);
   t->Draw();


}	




void ixsetco_(int&i, float &r, float &g, float &b)
{/*

CALL IXSETCO
 (INDEX,R,G,B)
Action: Set colour intensities for given colour index.
Parameter description:
INDEX
 Colour index.
R
 Red intensity between 0.0 and 1.0.
G
 Green intensity between 0.0 and 1.0.
B
 Blue intensity between 0.0 and 1.0.
*/
printf("ixsetco %i %f %f %f\n",i,r,g,b);
jColors[i]=TColor::GetColor(r,g,b);
}
void istxal_(int& a, int& b)
{/*
GKS
 CALL ISTXAL
 (ITXALH,ITXALV)
Action: This routine sets the text alignment attribute for use by future invocations of ITX. Text alignment
controls the placement of the character string with respect to the position specified in the call to ITX.
Horizontal alignment specifies which end of the string (or its geometric center) is aligned with the point
specified in ITX. For a given horizontal alignment, the vertical alignment controls whether the tops of tall
characters or the bottoms of capital letters line up with the point specified (see figure 3.9). The routine
IGSET (see section 4.11) can also be used with the parameter TXAL.
Parameter description:
ITXALH
ITXALV
Horizontal alignment specifier (0≤ITXALH≤3) 0
 Left end of string at point specified (normal).
1 Same as 0.
2 Center of string at point specified.
3 Right end of string at point specified.
Vertical alignment specifier (0≤ITXALV≤5)
0 Base of the characters (normal).
1 Top of tallest characters.
2 Same as 2.
3 Middle of tallest characters.
*/
int bb=1;

jTextAlignment=10*a+bb;


}



void istxci_(int& a)
{
DDDD printf("istxci_(int& a), %i\n",a);
/*
Text colour index.
GKS
 CALL ISTXCI
 (ICOLI)
Action: This routine sets the text colour index attribute for use by future invocations of ITX. The routinIGSET (see section 4.11) can also be used with the parameter TXCI.
Parameter description:
ICOLI
 Text colour index.
3.6.3
 Fill area interior style
*/
jTextColor=a;

}
void isplci_(int&a)
{/*
GKS
 CALL ISPLCI
 (ICOLI)
Action: This routine sets the polyline colour index attribute for use by future invocations of IPL. The
routine IGSET (see section 4.11) can also be used with the parameter PLCI.
Parameter description:
ICOLI
 Polyline colour index.
*/
//DDDD 
printf("isplci_(int&a), %i\n",a);
if (jColors.find(a)!=jColors.end()) jPolyLineColor=jColors.at(a);

//jPolyLineColor=a;
//if  (a==14) jPolyLineColor=kRed;
}




void ispmci_(int& a)
{
/*
Polymarker colour index.
GKS
 CALL ISPMCI
 (ICOLI)
Action: This routine sets the polymarker colour index attribute for use by future invocations of IPM. The
routine IGSET (see section 4.11) can also be used with the parameter PMCI.
Parameter description:
ICOLI
 Polymarker colour index.
*/
if (jColors.find(a)!=jColors.end()) jPolyMarkerColor=jColors.at(a);

//jPolyMarkerColor=a;
//printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);
}

void istxfp_(int &a, float *prec)
{
/*
GKS
 CALL ISTXFP
 (IFONT,IPREC)
Action: This routine sets the text font and precision attributes for use by future invocations of ITX. The
text font parameter selects among possible character shapes, as a roman font, a sans-serif font, etc. The
text precision parameter specifies how closely HIGZ (and also the underlying graphics package) must
follow the current size and orientation attributes. String precision is most liberal, stroke precision is most
strict. Character precision is in the middle. The routine IGSET (see section 4.11) can also be used with
the parameter TXFP.
Parameter description:
IFONT
IPREC
Text font. The value of IFONTText precision (0≤IPREC≤2).
depends on the underlying graphics package used.
*/
printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);
}

void ixsettc_(int&a)
{
/*
CALL IXSETTC
 (INDEX)
Action: Set colour index for text.
Parameter description:
INDEX
 Colour index defined my IXSETCOL.
*/
if (jColors.find(a)!=jColors.end()) jTextColor=jColors.at(a);
printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);
}


void ixsetlc_(int&a)
{
DDDD printf("ixsetlc_(int&a), %i\n",a);
jLineColor=a;



}



void ixsetmc_(int&a)
{

if (jColors.find(a)!=jColors.end())  jPolyMarkerColor=a;
//printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);

}








void ixsetfc_(int&a)
{
if (jColors.find(a)!=jColors.end())  jFillAreaColor=a;

printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);

}




void ixsetln_(int&a)
{
printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);

jPolyLineWidth=a;

}


void igsse_(int*a , int* b)
{
printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);

}

void igterm_(){
	
	printf ("__PRETTY_FUNCTION__ = %s\n", __PRETTY_FUNCTION__);
	
	}




}
