program proga;

uses CRT,DOS;
{Type SearchRec = Record
     Fill : Array [1..21] Of Byte;
     Attr : Byte;
     Time : Longint;
     Size : Longint;
     Name : String[12];
                 End;  }
const
  max = 13;
  nashi = 'X';
  nushi = 'O';
  code='iddqd';
var a,b,c,d,i,j,x,y,u,t:LongInt;
fignya:integer;
search:Searchrec;
leng:byte;
ukaz:byte;
nowukaz:byte;
command: string[127];
cox,coy:LongInt;
l,q,w,f:boolean;
x1,x2,x3,x4:boolean;
s,z:string;
hour,minute,second,sec100:word;
year,month,day,dayofweek :word;
copypath:string;
copyname:string;
ch:char;
pr:byte;
bufer:string;
tex:text;
time:integer;
timer:boolean;
r:array[-10..max+10,-10..max+10] of char;
h:array[-10..max+10,-10..max+10] of LongInt;
history:array[1..100,1..4] of LongInt;
ran:array[1..max*max,1..3]of LongInt;
result:array[1..3]of LongInt;
label l1,l2,l3,l4,l5,l6,l7,l8;
function Nashi_2_dia_2:Boolean;
begin
  Nashi_2_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j-1]=nashi) then
        begin
          Nashi_2_dia_2:=true;
          if r[i+2,j-2]='.' then inc(h[i+2,j-2],5);
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],5);
        end;
    end;
end;
function Nashi_2_dia_1:Boolean;
begin
  Nashi_2_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j+1]=nashi) then
        begin
          Nashi_2_dia_1:=true;
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],5);
          if r[i+2,j+2]='.' then inc(h[i+2,j+2],5);
        end;
    end;
end;
function Nashi_2_verti:Boolean;
begin
  Nashi_2_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j]=nashi) then
        begin
          Nashi_2_verti:=true;
          if r[i-1,j]='.' then inc(h[i-1,j],5);
          if r[i+2,j]='.' then inc(h[i+2,j],5);
        end;
    end;
end;
function Nashi_2_goriz:Boolean;
begin
  Nashi_2_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i,j+1]=nashi) then
        begin
          Nashi_2_goriz:=true;
          if r[i,j-1]='.' then inc(h[i,j-1],5);
          if r[i,j+2]='.' then inc(h[i,j+2],5);
        end;
    end;
end;
function Nashi_1_g_v_d:Boolean;
begin
  Nashi_1_g_v_d:=true;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if r[i,j]=nashi then
        begin
          if r[i+1,j]='.' then inc(h[i+1,j],1);
          if r[i+1,j+1]='.' then inc(h[i+1,j+1],1);
          if r[i+1,j-1]='.' then inc(h[i+1,j-1],1);
          if r[i-1,j]='.' then inc(h[i-1,j],1);
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],1);
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],1);
          if r[i,j+1]='.' then inc(h[i,j+1],1);
          if r[i,j-1]='.' then inc(h[i,j-1],1);
        end;
    end;
end;
function Nashi_4_d_1_r:Boolean;
begin
  Nashi_4_d_1_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j+2]=nashi)and(r[i+3,j+3]=nashi) then
        begin
          Nashi_4_d_1_r:=true;
          if r[i+1,j+1]='.' then if (r[i-1,j-1]='.')and(r[i+4,j+4]='.') then inc(h[i+1,j+1],50) else
                                 if (r[i-1,j-1]='.')or(r[i+4,j+4]='.') then inc(h[i+1,j+1],30);
        end;
      if (r[i,j]=nashi)and(r[i+1,j+1]=nashi)and(r[i+3,j+3]=nashi) then
        begin
          Nashi_4_d_1_r:=true;
          if r[i+2,j+2]='.' then if (r[i-1,j-1]='.')and(r[i+4,j+4]='.') then inc(h[i+2,j+2],50) else
                                 if (r[i-1,j-1]='.')or(r[i+4,j+4]='.') then inc(h[i+2,j+2],30);
        end;
    end;
end;
function Nashi_4_d_2_r:Boolean;
begin
  Nashi_4_d_2_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j-2]=nashi)and(r[i+3,j-3]=nashi) then
        begin
          Nashi_4_d_2_r:=true;
          if r[i+1,j-1]='.' then if (r[i-1,j+1]='.')and(r[i+4,j-4]='.') then inc(h[i+1,j-1],50) else
                                 if (r[i-1,j+1]='.')or(r[i+4,j-4]='.') then inc(h[i+1,j-1],30);
        end;
      if (r[i,j]=nashi)and(r[i+1,j-1]=nashi)and(r[i+3,j-3]=nashi) then
        begin
          Nashi_4_d_2_r:=true;
          if r[i+2,j-2]='.' then if (r[i-1,j+1]='.')and(r[i+4,j-4]='.') then inc(h[i+2,j-2],50) else
                                 if (r[i-1,j+1]='.')or(r[i+4,j-4]='.') then inc(h[i+2,j-2],30);
        end;
    end;
end;
function Nashi_4_gor_r:Boolean;
begin
  Nashi_4_gor_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i,j+2]=nashi)and(r[i,j+3]=nashi) then
        begin
          Nashi_4_gor_r:=true;
          if r[i,j+1]='.' then if (r[i,j-1]='.')and(r[i,j+4]='.') then inc(h[i,j+1],50) else if (r[i,j-1]='.')or(r[i,j+4]='.')
                                                                  then inc(h[i,j+1],30);
        end;
      if (r[i,j]=nashi)and(r[i,j+1]=nashi)and(r[i,j+3]=nashi) then
        begin
          Nashi_4_gor_r:=true;
          if r[i,j+2]='.' then if (r[i,j-1]='.')and(r[i,j+4]='.') then inc(h[i,j+2],50) else if (r[i,j-1]='.')or(r[i,j+4]='.')
                                                                  then inc(h[i,j+2],30);
        end;
    end;
end;
function Nashi_4_ver_r:Boolean;
begin
  Nashi_4_ver_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j]=nashi)and(r[i+3,j]=nashi) then
        begin
          Nashi_4_ver_r:=true;
          if r[i+1,j]='.' then if (r[i-1,j]='.')and(r[i+4,j]='.') then inc(h[i+1,j],50) else if (r[i-1,j]='.')or(r[i+4,j]='.')
                                                                                              then inc(h[i+1,j],35);
        end;
      if (r[i,j]=nashi)and(r[i+1,j]=nashi)and(r[i+3,j]=nashi) then
        begin
          Nashi_4_ver_r:=true;
          if r[i+2,j]='.' then if (r[i-1,j]='.')and(r[i+4,j]='.') then inc(h[i+2,j],50) else if (r[i-1,j]='.')or(r[i+4,j]='.')
                                                                                              then inc(h[i+2,j],35);
        end;
    end;
end;
procedure noll;
begin
  for i:=1 to max do
  for j:=1 to max do h[i,j]:=0;
end;
function Nashi_3_gor_r:Boolean;
begin
  Nashi_3_gor_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i,j+2]=nashi) then
        begin
          Nashi_3_gor_r:=true;
          if r[i,j+1]='.' then inc(h[i,j+1],10);
        end;
    end;
end;
function Nashi_3_ver_r:Boolean;
begin
  Nashi_3_ver_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j]=nashi) then
        begin
          Nashi_3_ver_r:=true;
          if r[i+1,j]='.' then inc(h[i+1,j],10);
        end;
    end;
end;
function Nashi_3_d_1_r:Boolean;
begin
  Nashi_3_d_1_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j+2]=nashi) then
        begin
          Nashi_3_d_1_r:=true;
          if r[i+1,j+1]='.' then inc(h[i+1,j+1],10);
        end;
    end;
end;
function Nashi_3_d_2_r:Boolean;
begin
  Nashi_3_d_2_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+2,j-2]=nashi)then
        begin
          Nashi_3_d_2_r:=true;
          if r[i+1,j-1]='.' then inc(h[i+1,j-1],10);
        end;
    end;
end;
function Nashi_3_dia_2:Boolean;
begin
  Nashi_3_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j-1]=nashi)and(r[i+2,j-2]=nashi) then
        begin
          Nashi_3_dia_2:=true;
          if (r[i-1,j+1]='.')and(r[i+3,j-3]='.') then inc(h[i-1,j+1],40) else inc(h[i-1,j+1],20);
          if (r[i+3,j-3]='.')and(r[i-1,j+1]='.') then inc(h[i+3,j-3],40) else inc(h[i+3,j-3],20);
        end;
    end;
end;
function Nashi_3_dia_1:Boolean;
begin
  Nashi_3_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j+1]=nashi)and(r[i+2,j+2]=nashi) then
        begin
          Nashi_3_dia_1:=true;
          if (r[i-1,j-1]='.')and(r[i+3,j+3]='.')then inc(h[i-1,j-1],40)else inc(h[i-1,j-1],20);
          if (r[i+3,j+3]='.')and(r[i-1,j-1]='.')then inc(h[i+3,j+3],40)else inc(h[i+3,j+3],20);
        end;
    end;
end;
function Nashi_3_verti:Boolean;
begin
  Nashi_3_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j]=nashi)and(r[i+2,j]=nashi) then
        begin
          Nashi_3_verti:=true;
          if (r[i-1,j]='.')and(r[i+3,j]='.') then inc(h[i-1,j],40) else inc(h[i-1,j],20);
          if (r[i+3,j]='.')and(r[i+3,j]='.') then inc(h[i+3,j],40) else inc(h[i+3,j],20);
        end;
    end;
end;
function Nashi_3_goriz:Boolean;
begin
  Nashi_3_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i,j+1]=nashi)and(r[i,j+2]=nashi) then
        begin
          Nashi_3_goriz:=true;
          if (r[i,j-1]='.')and(r[i,j+3]='.')then inc(h[i,j-1],40) else inc(h[i,j-1],20);
          if (r[i,j+3]='.')and(r[i,j-1]='.')then inc(h[i,j+3],40) else inc(h[i,j+3],20);
        end;
    end;
end;
procedure NULL;
begin
  for i:=1 to max do
  for j:=1 to max do
    begin
      r[i,j]:='.';
      h[i,j]:=0;
    end;
  CLRSCR;
end;
function Nashi_4_dia_2:Boolean;
begin
  Nashi_4_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j-1]=nashi)and(r[i+2,j-2]=nashi)and(r[i+3,j-3]=nashi) then
        begin
          Nashi_4_dia_2:=true;
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],600);
          if r[i+4,j-4]='.' then inc(h[i+4,j-4],600);
        end;
    end;
end;
function Nashi_4_dia_1:Boolean;
begin
  Nashi_4_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j+1]=nashi)and(r[i+2,j+2]=nashi)and(r[i+3,j+3]=nashi)then
        begin
          Nashi_4_dia_1:=true;
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],600);
          if r[i+4,j+4]='.' then inc(h[i+4,j+4],600);
        end;
    end;
end;
function Nashi_4_verti:Boolean;
var chetchik:LongInt;
begin
  Nashi_4_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j]=nashi)and(r[i+2,j]=nashi)and(r[i+3,j]=nashi)then
        begin
          Nashi_4_verti:=true;
          if r[i-1,j]='.' then inc(h[i-1,j],600);
          if r[i+4,j]='.' then inc(h[i+4,j],600);
        end;
    end;
end;
function Nashi_4_goriz:boolean;
begin
  Nashi_4_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i,j+1]=nashi)and(r[i,j+2]=nashi)and(r[i,j+3]=nashi) then
        begin
          Nashi_4_goriz:=true;
          if r[i,j-1]='.' then inc(h[i,j-1],600);
          if r[i,j+4]='.' then inc(h[i,j+4],600);
        end;
    end;
end;
function Nushi_2_dia_2:Boolean;
begin
  Nushi_2_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j-1]=nushi) then
        begin
          Nushi_2_dia_2:=true;
          if r[i+2,j-2]='.' then inc(h[i+2,j-2],16);
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],16);
        end;
    end;
end;
function Nushi_2_dia_1:Boolean;
begin
  Nushi_2_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j+1]=nushi) then
        begin
          Nushi_2_dia_1:=true;
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],16);
          if r[i+2,j+2]='.' then inc(h[i+2,j+2],16);
        end;
    end;
end;
function Nushi_2_verti:Boolean;
begin
  Nushi_2_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nashi)and(r[i+1,j]=nashi) then
        begin
          Nushi_2_verti:=true;
          if r[i-1,j]='.' then inc(h[i-1,j],16);
          if r[i+2,j]='.' then inc(h[i+2,j],16);
        end;
    end;
end;
function Nushi_2_goriz:Boolean;
begin
  Nushi_2_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i,j+1]=nushi) then
        begin
          Nushi_2_goriz:=true;
          if r[i,j-1]='.' then inc(h[i,j-1],16);
          if r[i,j+2]='.' then inc(h[i,j+2],16);
        end;
    end;
end;
function Nushi_1_g_v_d:Boolean;
begin
  Nushi_1_g_v_d:=true;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if r[i,j]=nushi then
        begin
          if r[i+1,j]='.' then inc(h[i+1,j],2);
          if r[i+1,j+1]='.' then inc(h[i+1,j+1],2);
          if r[i+1,j-1]='.' then inc(h[i+1,j-1],2);
          if r[i-1,j]='.' then inc(h[i-1,j],2);
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],2);
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],2);
          if r[i,j+1]='.' then inc(h[i,j+1],2);
          if r[i,j-1]='.' then inc(h[i,j-1],2);
        end;
    end;
end;
function Nushi_4_d_1_r:Boolean;
begin
  Nushi_4_d_1_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j+2]=nushi)and(r[i+3,j+3]=nushi) then
        begin
          Nushi_4_d_1_r:=true;
          if r[i+1,j+1]='.' then if (r[i-1,j-1]='.')and(r[i+4,j+4]='.') then inc(h[i+1,j+1],50) else
                                 if (r[i-1,j-1]='.')or(r[i+4,j+4]='.') then inc(h[i+1,j+1],30);
        end;
      if (r[i,j]=nushi)and(r[i+1,j+1]=nushi)and(r[i+3,j+3]=nushi) then
        begin
          Nushi_4_d_1_r:=true;
          if r[i+2,j+2]='.' then if (r[i-1,j-1]='.')and(r[i+4,j+4]='.') then inc(h[i+2,j+2],50) else
                                 if (r[i-1,j-1]='.')or(r[i+4,j+4]='.') then inc(h[i+2,j+2],30);
        end;
    end;
end;
function Nushi_4_d_2_r:Boolean;
begin
  Nushi_4_d_2_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j-2]=nushi)and(r[i+3,j-3]=nushi) then
        begin
          Nushi_4_d_2_r:=true;
          if r[i+1,j-1]='.' then if (r[i-1,j+1]='.')and(r[i+4,j-4]='.') then inc(h[i+1,j-1],50) else
                                 if (r[i-1,j+1]='.')or(r[i+4,j-4]='.') then inc(h[i+1,j-1],30);
        end;
      if (r[i,j]=nushi)and(r[i+1,j-1]=nushi)and(r[i+3,j-3]=nushi) then
        begin
          Nushi_4_d_2_r:=true;
          if r[i+2,j-2]='.' then if (r[i-1,j+1]='.')and(r[i+4,j-4]='.') then inc(h[i+2,j-2],50) else
                                 if (r[i-1,j+1]='.')or(r[i+4,j-4]='.') then inc(h[i+2,j-2],30);
        end;
    end;
end;
function Nushi_4_gor_r:Boolean;
begin
  Nushi_4_gor_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i,j+2]=nushi)and(r[i,j+3]=nushi) then
        begin
          Nushi_4_gor_r:=true;
          if r[i,j+1]='.' then if (r[i,j-1]='.')and(r[i,j+4]='.') then inc(h[i,j+1],50) else if (r[i,j-1]='.')or(r[i,j+4]='.')
                                                                  then inc(h[i,j+1],30);
        end;
      if (r[i,j]=nushi)and(r[i,j+1]=nushi)and(r[i,j+3]=nushi) then
        begin
          Nushi_4_gor_r:=true;
          if r[i,j+2]='.' then if (r[i,j-1]='.')and(r[i,j+4]='.') then inc(h[i,j+2],50) else if (r[i,j-1]='.')or(r[i,j+4]='.')
                                                                  then inc(h[i,j+2],30);
        end;
    end;
end;
function Nushi_4_ver_r:Boolean;
begin
  Nushi_4_ver_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j]=nushi)and(r[i+3,j]=nushi) then
        begin
          Nushi_4_ver_r:=true;
          if r[i+1,j]='.' then if (r[i-1,j]='.')and(r[i+4,j]='.') then inc(h[i+1,j],50) else if (r[i-1,j]='.')or(r[i+4,j]='.')
                                                                                              then inc(h[i+1,j],35);
        end;
      if (r[i,j]=nushi)and(r[i+1,j]=nushi)and(r[i+3,j]=nushi) then
        begin
          Nushi_4_ver_r:=true;
          if r[i+2,j]='.' then if (r[i-1,j]='.')and(r[i+4,j]='.') then inc(h[i+2,j],50) else if (r[i-1,j]='.')or(r[i+4,j]='.')
                                                                                              then inc(h[i+2,j],35);
        end;
    end;
end;
function Nushi_3_gor_r:Boolean;
begin
  Nushi_3_gor_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i,j+2]=nushi) then
        begin
          Nushi_3_gor_r:=true;
          if r[i,j+1]='.' then inc(h[i,j+1],16);
        end;
    end;
end;
function Nushi_3_ver_r:Boolean;
begin
  Nushi_3_ver_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j]=nushi) then
        begin
          Nushi_3_ver_r:=true;
          if r[i+1,j]='.' then inc(h[i+1,j],16);
        end;
    end;
end;
function Nushi_3_d_1_r:Boolean;
begin
  Nushi_3_d_1_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j+2]=nushi) then
        begin
          Nushi_3_d_1_r:=true;
          if r[i+1,j+1]='.' then inc(h[i+1,j+1],16);
        end;
    end;
end;
function Nushi_3_d_2_r:Boolean;
begin
  Nushi_3_d_2_r:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+2,j-2]=nushi)then
        begin
          Nushi_3_d_2_r:=true;
          if r[i+1,j-1]='.' then inc(h[i+1,j-1],16);
        end;
    end;
end;
function Nushi_3_dia_2:Boolean;
begin
  Nushi_3_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j-1]=nushi)and(r[i+2,j-2]=nushi) then
        begin
          Nushi_3_dia_2:=true;
          if (r[i-1,j+1]='.')and(r[i+3,j-3]='.') then inc(h[i-1,j+1],35) else inc(h[i-1,j+1],15);
          if (r[i+3,j-3]='.')and(r[i-1,j+1]='.') then inc(h[i+3,j-3],35) else inc(h[i+3,j-3],15);
        end;
    end;
end;
function Nushi_3_dia_1:Boolean;
begin
  Nushi_3_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j+1]=nushi)and(r[i+2,j+2]=nushi) then
        begin
          Nushi_3_dia_1:=true;
          if (r[i-1,j-1]='.')and(r[i+3,j+3]='.') then inc(h[i-1,j-1],35) else inc(h[i-1,j-1],15);
          if (r[i+3,j+3]='.')and(r[i-1,j-1]='.') then inc(h[i+3,j+3],35) else inc(h[i+3,j+3],15);
        end;
    end;
end;
function Nushi_3_verti:Boolean;
begin
  Nushi_3_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j]=nushi)and(r[i+2,j]=nushi) then
        begin
          Nushi_3_verti:=true;
          if (r[i-1,j]='.')and(r[i+3,j]='.') then inc(h[i-1,j],35) else inc(h[i-1,j],15);
          if (r[i+3,j]='.')and(r[i-1,j]='.') then inc(h[i+3,j],35) else inc(h[i+3,j],15);
        end;
    end;
end;
function Nushi_3_goriz:Boolean;
begin
  Nushi_3_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i,j+1]=nushi)and(r[i,j+2]=nushi) then
        begin
          Nushi_3_goriz:=true;
          if (r[i,j-1]='.')and(r[i,j+3]='.') then inc(h[i,j-1],35) else inc(h[i,j-1],15);
          if (r[i,j+3]='.')and(r[i,j-1]='.') then inc(h[i,j+3],35) else inc(h[i,j+3],15);
        end;
    end;
end;
function Nushi_4_dia_2:Boolean;
begin
  Nushi_4_dia_2:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j-1]=nushi)and(r[i+2,j-2]=nushi)and(r[i+3,j-3]=nushi) then
        begin
          Nushi_4_dia_2:=true;
          if r[i-1,j+1]='.' then inc(h[i-1,j+1],999);
          if r[i+4,j-4]='.' then inc(h[i+4,j-4],999);
        end;
    end;
end;
function Nushi_4_dia_1:Boolean;
begin
  Nushi_4_dia_1:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j+1]=nushi)and(r[i+2,j+2]=nushi)and(r[i+3,j+3]=nushi)then
        begin
          Nushi_4_dia_1:=true;
          if r[i-1,j-1]='.' then inc(h[i-1,j-1],999);
          if r[i+4,j+4]='.' then inc(h[i+4,j+4],999);
        end;
    end;
end;
function Nushi_4_verti:Boolean;
begin
  Nushi_4_verti:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i+1,j]=nushi)and(r[i+2,j]=nushi)and(r[i+3,j]=nushi)then        begin
          Nushi_4_verti:=true;
          if r[i-1,j]='.' then inc(h[i-1,j],999);
          if r[i+4,j]='.' then inc(h[i+4,j],999);
        end;
    end;
end;
function Nushi_4_goriz:boolean;
begin
  Nushi_4_goriz:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if (r[i,j]=nushi)and(r[i,j+1]=nushi)and(r[i,j+2]=nushi)and(r[i,j+3]=nushi) then
        begin
          Nushi_4_goriz:=true;
          if r[i,j-1]='.' then inc(h[i,j-1],999);
          if r[i,j+4]='.' then inc(h[i,j+4],999);
        end;
    end;
end;
procedure Cena_pozicii;
begin
  result[1]:=0;
  result[2]:=0;
  result[3]:=0;
  x:=1;
  ran[1,3]:=h[1,1];
  for i:=1 to max do
  for j:=1 to max do
    begin
      if r[i,j]='.' then
      begin
      if h[i,j]=ran[x,3] then
        begin                {
          result[1]:=i;
          result[2]:=j;
          result[3]:=h[i,j];}
          inc(x);
          ran[x,1]:=i;
          ran[x,2]:=j;
          ran[x,3]:=h[i,j];
        end;
      if h[i,j]>ran[x,3] then
        begin
          for a:=1 to max*max do
            begin
              ran[a,1]:=0;
              ran[a,2]:=0;
              ran[a,3]:=0;
            end;
          x:=1;
          ran[x,1]:=i;
          ran[x,2]:=j;
          ran[x,3]:=h[i,j];
        end;
        end;
    end;
end;
function Nashi_5(c:char):Boolean;
label l1,l2,l3,l4;
begin
  Nashi_5:=false;
  for i:=1 to max do
  for j:=1 to max do
    begin
      if r[i,j]=c then
        begin
          if (r[i,j+1]=c)and(r[i,j+2]=c)and(r[i,j+3]=c)and(r[i,j+4]=c) then goto l1;
          if (r[i+1,j]=c)and(r[i+2,j]=c)and(r[i+3,j]=c)and(r[i+4,j]=c) then goto l2;
          if (r[i+1,j+1]=c)and(r[i+2,j+2]=c)and(r[i+3,j+3]=c)and(r[i+4,j+4]=c) then goto l3;
          if (r[i+1,j-1]=c)and(r[i+2,j-2]=c)and(r[i+3,j-3]=c)and(r[i+4,j-4]=c) then goto l4;
        end;
      continue;
      l1: begin
            Nashi_5:=true;
            if c='O' then
              begin
                r[i,j]:='o';
                r[i,j+1]:='o';
                r[i,j+2]:='o';
                r[i,j+3]:='o';
                r[i,j+4]:='o';
              end else
              begin
                r[i,j]:='x';
                r[i,j+1]:='x';
                r[i,j+2]:='x';
                r[i,j+3]:='x';
                r[i,j+4]:='x';
              end;
            exit;
          end;
      l2: begin
            Nashi_5:=true;
            if c='O' then
              begin
                r[i,j]:='o';
                r[i+1,j]:='o';
                r[i+2,j]:='o';
                r[i+3,j]:='o';
                r[i+4,j]:='o';
              end else
              begin
                r[i,j]:='x';
                r[i+1,j]:='x';
                r[i+2,j]:='x';
                r[i+3,j]:='x';
                r[i+4,j]:='x';
              end;
            exit;
          end;
      l3: begin
            Nashi_5:=true;
            if c='O' then
              begin
                r[i,j]:='o';
                r[i+1,j+1]:='o';
                r[i+2,j+2]:='o';
                r[i+3,j+3]:='o';
                r[i+4,j+4]:='o';
              end else
              begin
                r[i,j]:='x';
                r[i+1,j+1]:='x';
                r[i+2,j+2]:='x';
                r[i+3,j+3]:='x';
                r[i+4,j+4]:='x';
              end;
            exit;
          end;
      l4: begin
            Nashi_5:=true;
            if c='O' then
              begin
                r[i,j]:='o';
                r[i+1,j-1]:='o';
                r[i+2,j-2]:='o';
                r[i+3,j-3]:='o';
                r[i+4,j-4]:='o';
              end else
              begin
                r[i,j]:='x';
                r[i+1,j-1]:='x';
                r[i+2,j-2]:='x';
                r[i+3,j-3]:='x';
                r[i+4,j-4]:='x';
              end;
            exit;
          end;
    end;
end;
function Nichya:Boolean;
begin
  Nichya:=true;
  for i:=1 to max do
  for j:=1 to max do if r[i,j]='.' then
                       begin
                         Nichya:=false;
                         exit;
                       end;
end;
procedure pole(l,m:integer;
              kurs:boolean);
var i,j:integer;
label l5;
begin
textcolor(green);

             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                textcolor(green);
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if (kurs=true)and(i=cox)and(j=coy) then
              begin
                textcolor(magenta);
                if r[i,j]='.' then
                  begin
                    write('@ ');
                    continue
                  end;
                goto l5;
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else textcolor(green);
            if r[i,j]='x' then textcolor(125) else
            if r[i,j]='o' then textcolor(125);
            l5:;
            write(UpCase(r[i,j]),' ');
            textcolor(green);
          end;
         textcolor(green);
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
         writeln;
end;
procedure zaderg(x:integer);
var i,j:integer;
begin
  for i:=1 to 3 do
  for j:=1 to x do delay(30000);
end;
procedure windows;
begin
  textbackground(black);
  textcolor(green);
  window(1,1,80,25);
  window(1,1,80,43);
  CLRSCR;
end;
begin
  textcolor(green);
  textbackground(black);
  for i:=1 to max do
  for j:=1 to max do r[i,j]:='.';
  if paramstr(1)='I''m_gamer_iddqd' then
    begin
      q:=true;
      w:=true;
      goto l8;
    end;
  l4:;
  CLRSCR;
  randomize;
  while a<>999 do
    begin
      readln(s);
      for i:=1 to length(s) do s[i]:=UpCase(s[i]);
      x1:=false;
      x2:=false;
      x3:=false;
      x4:=false;
      z:=s;
      if z='SYSTEM' then
        begin
          textcolor(blue);
          CLRSCR;
          writeln('SYSTEM ENTER');
          textcolor(green);
          writeln;
          writeln('Please press any key to continue...');
          writeln;
          textcolor(blue);
          writeln('...but if you have not got a tolerance...');
          writeln;
          writeln('...then I do not know what I do with you...');
          gettime(hour,minute,second,sec100);
          time:=second*100+sec100;
          readkey;
          gettime(hour,minute,second,sec100);
          CLRSCR;
          if second*100+sec100 - time > 100 then timer:=false else timer:=true;
          textcolor(magenta);
          writeln;
          writeln('_______________________');
          writeln('|^|^|^|^|^|^|^|^|^|^|^|');
          writeln('|_/////////|\\\\\\\\\_|');
          writeln('| \\\\\\\\\|///////// |');
          writeln('|^|^|^|^|^|^|^|^|^|^|^|');
          writeln('-----------------------');
          writeln;
          textcolor(125);
          writeln('Checking personality...');
          writeln;
          textcolor(6);
          writeln('Scan of retina your eyes is: ');
          writeln('Small system enter is... ');
          zaderg(5);
          CLRSCR;
          {textcolor(blue);
          CLRSCR;
          writeln('SYSTEM ENTER');    }
          textcolor(magenta);
          writeln;
          writeln('_______________________');
          writeln('|^|^|^|^|^|^|^|^|^|^|^|');
          writeln('|_/////////|\\\\\\\\\_|');
          writeln('| \\\\\\\\\|///////// |');
          writeln('|^|^|^|^|^|^|^|^|^|^|^|');
          writeln('-----------------------');
          writeln;
          if timer=true then
            begin
              textcolor(blue);
              writeln('Scan of retina your eyes is: TRUE!!!');
              writeln('Small system enter is opened');
            end else
            begin
              textcolor(red);
              writeln('Scan of retina your eyes is: FALSE!!!');
              writeln('Small system enter is CLOSED');
            end;
          zaderg(3);
          q:=true;
          textcolor(green);
          CLRSCR;
        end else
      if z='SYSTEM EDIT' then
        begin
          CLRSCR;
          textcolor(blue);
          writeln('SYSTEM ENTER');
          writeln;
          textcolor(magenta);
          write('Please insert code here: ');
          textcolor(green);
          s:='';
          l5:;
          ch:=readkey;
          if ord(ch)=8 then goto l5;
          s:=s+ch;
          t:=0;
          while ord(ch)<>13 do
             begin
               inc(t);
               if ord(ch)<>8 then
                 begin
                   write('*');
                   pr:=0;
                 end else
                 begin
                   CLRSCR;
                   textcolor(blue);
                   writeln('SYSTEM ENTER');
                   writeln;
                   textcolor(magenta);
                   write('Please insert code here: ');
                   textcolor(green);
                   delete(s,length(s)-1,2);
                   {if pr<>0 then delete(s,length(s)-1,1);}
                   pr:=1;
                   dec(t);
                   for i:=1 to length(s) do write('*');
                 end;
               ch:=readkey;
               if ord(ch)=13 then break;
               s:=s+ch;
             end;
          w:=true;
          textcolor(28);
          writeln;
          writeln;
          writeln('Checking code');
          if s=code then textcolor(green) else textcolor(red);
          zaderg(7);
          if s<>code then w:=false;
          write('The code is: ');
          zaderg(2);
          if s=code then writeln('TRUE!!!') else write('FALSE!');
          zaderg(2);
          textcolor(green);
          CLRSCR;
        end else
      if s='EXIT' then exit else
      if (s='PLAY')or(s='PLAY 2') then
      begin
        l8:;
        cox:=max div 2;
        coy:=max div 2;
        CLRSCR;
        if s='PLAY 2' then goto l3;
        if w=false then
          for i:=1 to max do
          for j:=1 to max do r[i,j]:='.';
        repeat
            {textcolor(green);
             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else textcolor(green);
            write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
        textcolor(green);
        writeln;
        write('Coordinates: ');   }
        noll;
        l2:;
        ch:=' ';
        while ord(ch)<>13 do
        begin
          CLRSCR;
          textcolor(green);
      writeln;
      pole(cox,coy,true);
      {write('  ');
      for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if (i=cox)and(j=coy) then textcolor(magenta) else
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else
            if (r[i,j]='o')or(r[i,j]='x') then textcolor(125);
            if r[i,j]='o' then write('O ') else
            if r[i,j]='x' then write('X ') else
            if (i=cox)and(j=coy)and(r[i,j]='.') then write('@ ') else write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');   }
        textcolor(green);
        writeln;
           ch:=readkey;
           if ch='@'then goto l4;
           CLRSCR;
            if UpCase(ch)='W' then dec(cox) else
            if UpCase(ch)='S' then inc(cox) else
            if UpCase(ch)='A' then dec(coy) else
            if UpCase(ch)='D' then inc(coy) else
              begin
                if (x3=true)and(UpCase(ch)='T') then x4:=true else
                if (x2=true)and(UpCase(ch)='I') then x3:=true else
                if (x1=true)and(UpCase(ch)='X') then x2:=true else
                if             (UpCase(ch)='E') then x1:=true;
                if x4=true then exit;
                continue;
              end;

            if cox=0 then inc(cox);
            if cox>max then dec(cox);
            if coy=0 then inc(coy);
            if coy>max then dec(coy);
        end;
        inc(u);
        if (w=false)and(r[cox,coy]<>'.') then goto l2 else r[cox,coy]:=nashi;
        history[u,1]:=cox;
        history[u,2]:=coy;
        l3:;
        l:=Nashi_4_verti;
        l:=Nashi_4_goriz;
        l:=Nashi_4_dia_1;
        l:=Nashi_4_dia_2;
        l:=Nashi_4_gor_r;
        l:=Nashi_4_ver_r;
        l:=Nashi_4_d_1_r;
        l:=Nashi_4_d_2_r;
        l:=Nashi_3_goriz;
        l:=Nashi_3_verti;
        l:=Nashi_3_dia_1;
        l:=Nashi_3_dia_2;
        l:=Nashi_3_gor_r;
        l:=Nashi_3_ver_r;
        l:=Nashi_3_d_1_r;
        l:=Nashi_3_d_2_r;
        l:=Nashi_2_goriz;
        l:=Nashi_2_verti;
        l:=Nashi_2_dia_1;
        l:=Nashi_2_dia_2;
        l:=Nashi_1_g_v_d;
        l:=Nushi_4_verti;
        l:=Nushi_4_goriz;
        l:=Nushi_4_dia_1;
        l:=Nushi_4_dia_2;
        l:=Nushi_4_gor_r;
        l:=Nushi_4_ver_r;
        l:=Nushi_4_d_1_r;
        l:=Nushi_4_d_2_r;
        l:=Nushi_3_goriz;
        l:=Nushi_3_verti;
        l:=Nushi_3_dia_1;
        l:=Nushi_3_dia_2;
        l:=Nushi_3_gor_r;
        l:=Nushi_3_ver_r;
        l:=Nushi_3_d_1_r;
        l:=Nushi_3_d_2_r;
        l:=Nushi_2_goriz;
        l:=Nushi_2_verti;
        l:=Nushi_2_dia_1;
        l:=Nushi_2_dia_2;
        l:=Nushi_1_g_v_d;
    for i:=1 to max do
    for j:=1 to max do if r[i,j]<>'.' then h[i,j]:=0;
    if Nashi_5('X') then
      begin
        CLRSCR;
        textcolor(blue);
        writeln('You won...');
        writeln('...but I will be back...');
        writeln('...and I will beat you');
        writeln;
        textcolor(green);
        writeln('Program created by Tyulbashev');
        writeln('              (c) MATRIX 2009');
        break;
      end;
    if Nichya=true then
          begin
            writeln;
            writeln('You cannot won me!!!');
            writeln('Nichya');
            writeln;
            writeln('Program created by Tyulbashev');
            writeln('              (c) MATRIX 2009');
            break;
          end;
    Cena_pozicii;
    y:=0;
    while (y<=0)or(y>x) do  y:=random(x+1);
    r[ran[y,1],ran[y,2]]:='O';
    inc(u);
    history[u,3]:=ran[y,1];
    history[u,4]:=ran[y,2];
    CLRSCR;
         begin
      if Nashi_5('O') then
        begin
        textcolor(magenta);
          writeln;
          writeln('I won :-)');
          writeln;
          textcolor(green);
          writeln('Program created by Tyulbashev');
          writeln('             (c)  MATRIX 2009');
          break;
        end;
        if Nichya=true then
          begin
            writeln;
            writeln('You cannot won me!!!');
            writeln('Nichya');
            writeln;
            writeln('Program created by Tyulbashev');
            writeln('              (c) MATRIX 2009');
            break;
          end;
          end;
    until a=999;
      textcolor(magenta);
      writeln('GAME OVER');
      textcolor(green);
      {writeln;
      write('  ');
      for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else
            if (r[i,j]='o')or(r[i,j]='x') then textcolor(125);
            if r[i,j]='o' then write('O ') else
            if r[i,j]='x' then write('X ') else write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');  }
        pole(0,0,false);
        textcolor(green);
        writeln;
      end else
      if (s='PLAY GAME, 1')or(s='PLAY GAME, 2')or(s='PLAY GAME')or(s='GAME')or(s='GLYUK:-)')then
      begin
        CLRSCR;
        if w=false then
          for i:=1 to max do
          for j:=1 to max do r[i,j]:='.';
        repeat
        if s='GLYUK:-)' then goto l1;
        if s='PLAY GAME, 2' then
          begin
            s:='play game';
            goto l1;
          end;
        {textcolor(green);
             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else textcolor(green);
            write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
        textcolor(green);
        writeln;}
        pole(0,0,false);
        write('Coordinates: ');
        noll;
        {$I-}
        read(x,y);
        {$I+}
        if IOResult<>0 then
          begin
            writeln('THE GAME HAS BEEN CANCELLED');
            writeln('INVALID NUMERIC FORMAT');
            break;
          end;
        inc(u);
        history[u,1]:=x;
        history[u,2]:=y;
        if r[x,y]<>'.' then
          begin
              CLRSCR;
              writeln('Coordinates: ',x,' ',y);
              writeln('ERROR COORDINATE');
              continue;
            end;
        r[x,y]:=nashi;
        l:=Nashi_4_verti;
        l:=Nashi_4_goriz;
        l:=Nashi_4_dia_1;
        l:=Nashi_4_dia_2;
        l:=Nashi_4_gor_r;
        l:=Nashi_4_ver_r;
        l:=Nashi_4_d_1_r;
        l:=Nashi_4_d_2_r;
        l:=Nashi_3_goriz;
        l:=Nashi_3_verti;
        l:=Nashi_3_dia_1;
        l:=Nashi_3_dia_2;
        l:=Nashi_3_gor_r;
        l:=Nashi_3_ver_r;
        l:=Nashi_3_d_1_r;
        l:=Nashi_3_d_2_r;
        l:=Nashi_2_goriz;
        l:=Nashi_2_verti;
        l:=Nashi_2_dia_1;
        l:=Nashi_2_dia_2;
        l:=Nashi_1_g_v_d;
        l:=Nushi_4_verti;
        l:=Nushi_4_goriz;
        l:=Nushi_4_dia_1;
        l:=Nushi_4_dia_2;
        l:=Nushi_4_gor_r;
        l:=Nushi_4_ver_r;
        l:=Nushi_4_d_1_r;
        l:=Nushi_4_d_2_r;
        l:=Nushi_3_goriz;
        l:=Nushi_3_verti;
        l:=Nushi_3_dia_1;
        l:=Nushi_3_dia_2;
        l:=Nushi_3_gor_r;
        l:=Nushi_3_ver_r;
        l:=Nushi_3_d_1_r;
        l:=Nushi_3_d_2_r;
        l:=Nushi_2_goriz;
        l:=Nushi_2_verti;
        l:=Nushi_2_dia_1;
        l:=Nushi_2_dia_2;
        l:=Nushi_1_g_v_d;
        l1:;
    for i:=1 to max do
    for j:=1 to max do if r[i,j]<>'.' then h[i,j]:=0;
    if Nashi_5('X') then
      begin
        CLRSCR;
        textcolor(blue);
        writeln('You won...');
        writeln('...but I will be back...');
        writeln('...and I will beat you');
        writeln;
        textcolor(green);
        writeln('Program created by Tyulbashev');
        writeln('              (c) MATRIX 2009');
        break;
      end;
    if Nichya=true then
          begin
            writeln;
            writeln('You cannot won me!!!');
            writeln('Nichya');
            writeln;
            writeln('Program created by Tyulbashev');
            writeln('              (c) MATRIX 2009');
            break;
          end;
    Cena_pozicii;
    y:=0;
    while (y<=0)or(y>x) do  y:=random(x+1);
    r[ran[y,1],ran[y,2]]:='O';
    history[u,3]:=ran[y,1];
    history[u,4]:=ran[y,2];
    CLRSCR;
         begin
      if Nashi_5('O') then
        begin
        textcolor(magenta);
          writeln;
          writeln('I won :-)');
          writeln;
          textcolor(green);
          writeln('Program created by Tyulbashev');
          writeln('             (c)  MATRIX 2009');
          break;
        end;
        if Nichya=true then
          begin
            writeln;
            writeln('You cannot won me!!!');
            writeln('Nichya');
            writeln;
            writeln('Program created by Tyulbashev');
            writeln('              (c) MATRIX 2009');
            break;
          end;
          end;
    until a=999;
      textcolor(magenta);
      writeln('GAME OVER');
      textcolor(green);
      writeln;
      {write('  ');
      for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else
            if (r[i,j]='o')or(r[i,j]='x') then textcolor(125);
            if r[i,j]='o' then write('O ') else
            if r[i,j]='x' then write('X ') else write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
        textcolor(green);
        writeln; }
      pole(0,0,false);
      end else
      if s='IGRA' then
        begin
    write('Kol-vo: ');
    {$I-}
    read(a);
    {$I+}
    if IOResult<>0 then
      begin
        writeln('ERROR "Kol-vo"');
        continue;
      end;
    for i:=1 to a do
      begin
        {$I-}
        read(x,y);
        {$I+}
        if IOResult<>0 then
          begin
            writeln('ERROR coordinate');
            f:=true;
            break;
          end;
        r[x,y]:=nashi;
      end;
    if i<>a then continue else
    if f=true then continue;
    noll;
    writeln('Nashi_4_verti: ',Nashi_4_verti);
    writeln('Nashi_4_goriz: ',Nashi_4_goriz);
    writeln('Nashi_4_dia_1: ',Nashi_4_dia_1);
    writeln('Nashi_4_dia_2: ',Nashi_4_dia_2);
    writeln('Nashi_4_gor_r: ',Nashi_4_gor_r);
    writeln('Nashi_4_ver_r: ',Nashi_4_ver_r);
    writeln('Nashi_4_d_1_r: ',Nashi_4_d_1_r);
    writeln('Nashi_4_d_2_r: ',Nashi_4_d_2_r);
    writeln('Nashi_3_goriz: ',Nashi_3_goriz);
    writeln('Nashi_3_verti: ',Nashi_3_verti);
    writeln('Nashi_3_dia_1: ',Nashi_3_dia_1);
    writeln('Nashi_3_dia_2: ',Nashi_3_dia_2);
    writeln('Nashi_3_gor_r: ',Nashi_3_gor_r);
    writeln('Nashi_3_ver_r: ',Nashi_3_ver_r);
    writeln('Nashi_3_d_1_r: ',Nashi_3_d_1_r);
    writeln('Nashi_3_d_2_r: ',Nashi_3_d_2_r);
    writeln('Nashi_2_goriz: ',Nashi_2_goriz);
    writeln('Nashi_2_verti: ',Nashi_2_verti);
    writeln('Nashi_2_dia_1: ',Nashi_2_dia_1);
    writeln('Nashi_2_dia_2: ',Nashi_2_dia_2);
    writeln('Nashi_1_g_v_d: ',Nashi_1_g_v_d);
    writeln('Nushi_4_verti: ',Nushi_4_verti);
    writeln('Nushi_4_goriz: ',Nushi_4_goriz);
    writeln('Nushi_4_dia_1: ',Nushi_4_dia_1);
    writeln('Nushi_4_dia_2: ',Nushi_4_dia_2);
    writeln('Nushi_4_gor_r: ',Nushi_4_gor_r);
    writeln('Nushi_4_ver_r: ',Nushi_4_ver_r);
    writeln('Nushi_4_d_1_r: ',Nushi_4_d_1_r);
    writeln('Nushi_4_d_2_r: ',Nushi_4_d_2_r);
    writeln('Nushi_3_goriz: ',Nushi_3_goriz);
    writeln('Nushi_3_verti: ',Nushi_3_verti);
    writeln('Nushi_3_dia_1: ',Nushi_3_dia_1);
    writeln('Nushi_3_dia_2: ',Nushi_3_dia_2);
    writeln('Nushi_3_gor_r: ',Nushi_3_gor_r);
    writeln('Nushi_3_ver_r: ',Nushi_3_ver_r);
    writeln('Nushi_3_d_1_r: ',Nushi_3_d_1_r);
    writeln('Nushi_3_d_2_r: ',Nushi_3_d_2_r);
    writeln('Nushi_2_goriz: ',Nushi_2_goriz);
    writeln('Nushi_2_verti: ',Nushi_2_verti);
    writeln('Nushi_2_dia_1: ',Nushi_2_dia_1);
    writeln('Nushi_2_dia_2: ',Nushi_2_dia_2);
    writeln('Nushi_1_g_v_d: ',Nushi_1_g_v_d);
    for i:=1 to max do
    for j:=1 to max do if r[i,j]<>'.' then h[i,j]:=0;
    Cena_pozicii;
    r[result[1],result[2]]:='O';
    begin
    {textcolor(green);
             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else textcolor(green);
            write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
        textcolor(green);
        writeln;} pole(0,0,false);
                      end
    end else
      if s='POLE' then
           begin
             {textcolor(green);
             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else
            if (r[i,j]='x')or(r[i,j]='o') then textcolor(125);
            if r[i,j]='x' then write('X ') else
            if r[i,j]='o' then write('O ') else write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
        textcolor(green);
        writeln; } pole(0,0,false);
            end else
      if s='TABL' then
          begin
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then writeln;
            if h[i,j]<>0 then textcolor(red) else textcolor(green);
            if r[i,j]='.' then
              begin
                write(h[i,j],' ');
                if h[i,j]<10 then write(' ');
              end else
            if r[i,j]='X' then
              begin
                textcolor(magenta);
                write('X  ');
              end else
            if r[i,j]='O' then
              begin
                textcolor(blue);
                write('O  ');
              end else
            if r[i,j]='o' then
              begin
                textcolor(yellow);
                write('O  ');
              end else
            if r[i,j]='x' then
              begin
                textcolor(yellow);
                write('X  ');
              end else
              begin
                writeln('System error');
                readkey;
                exit;
              end;
          end
          end else
      if s='FUNC' then
        begin
          noll;
          writeln('Nashi_4_verti: ',Nashi_4_verti);
          writeln('Nashi_4_goriz: ',Nashi_4_goriz);
          writeln('Nashi_4_dia_1: ',Nashi_4_dia_1);
          writeln('Nashi_4_dia_2: ',Nashi_4_dia_2);
          writeln('Nashi_4_gor_r: ',Nashi_4_gor_r);
          writeln('Nashi_4_ver_r: ',Nashi_4_ver_r);
          writeln('Nashi_4_d_1_r: ',Nashi_4_d_1_r);
          writeln('Nashi_4_d_2_r: ',Nashi_4_d_2_r);
          writeln('Nashi_3_goriz: ',Nashi_3_goriz);
          writeln('Nashi_3_verti: ',Nashi_3_verti);
          writeln('Nashi_3_dia_1: ',Nashi_3_dia_1);
          writeln('Nashi_3_dia_2: ',Nashi_3_dia_2);
          writeln('Nashi_3_gor_r: ',Nashi_3_gor_r);
          writeln('Nashi_3_ver_r: ',Nashi_3_ver_r);
          writeln('Nashi_3_d_1_r: ',Nashi_3_d_1_r);
          writeln('Nashi_3_d_2_r: ',Nashi_3_d_2_r);
          writeln('Nashi_2_goriz: ',Nashi_2_goriz);
          writeln('Nashi_2_verti: ',Nashi_2_verti);
          writeln('Nashi_2_dia_1: ',Nashi_2_dia_1);
          writeln('Nashi_2_dia_2: ',Nashi_2_dia_2);
          writeln('Nashi_1_g_v_d: ',Nashi_1_g_v_d);
          writeln('Nushi_4_verti: ',Nushi_4_verti);
          writeln('Nushi_4_goriz: ',Nushi_4_goriz);
          writeln('Nushi_4_dia_1: ',Nushi_4_dia_1);
          writeln('Nushi_4_dia_2: ',Nushi_4_dia_2);
          writeln('Nushi_4_gor_r: ',Nushi_4_gor_r);
          writeln('Nushi_4_ver_r: ',Nushi_4_ver_r);
          writeln('Nushi_4_d_1_r: ',Nushi_4_d_1_r);
          writeln('Nushi_4_d_2_r: ',Nushi_4_d_2_r);
          writeln('Nushi_3_goriz: ',Nushi_3_goriz);
          writeln('Nushi_3_verti: ',Nushi_3_verti);
          writeln('Nushi_3_dia_1: ',Nushi_3_dia_1);
          writeln('Nushi_3_dia_2: ',Nushi_3_dia_2);
          writeln('Nushi_3_gor_r: ',Nushi_3_gor_r);
          writeln('Nushi_3_ver_r: ',Nushi_3_ver_r);
          writeln('Nushi_3_d_1_r: ',Nushi_3_d_1_r);
          writeln('Nushi_3_d_2_r: ',Nushi_3_d_2_r);
          writeln('Nushi_2_goriz: ',Nushi_2_goriz);
          writeln('Nushi_2_verti: ',Nushi_2_verti);
          writeln('Nushi_2_dia_1: ',Nushi_2_dia_1);
          writeln('Nushi_2_dia_2: ',Nushi_2_dia_2);
          writeln('Nushi_1_g_v_d: ',Nushi_1_g_v_d);
        end else
      if s='NULL' then
        begin
          NULL;
          Writeln('ok');
        end else
      if s='COMMAND'then
        begin
          writeln('play game');
          writeln('play');
          writeln('play 2');
          writeln('pole');
          writeln('igra');
          writeln('tabl');
          writeln('history');
          writeln('func');
          writeln('null');
          writeln('exit');
          writeln('CLRSCR');
          writeln('Glyuk:-)');
          writeln('time');
          writeln('date');
          writeln('data');
          writeln('dos string');
          writeln('command string');
          writeln('color or another...');
        end else
      if s='CLRSCR'then CLRSCR else
      if s='TIME' then
        begin
          while not keypressed do
            begin
              CLRSCR;
              gettime(hour,minute,second,sec100);
              writeln(hour,':',minute,':',second,' (',sec100,' millisecond)');
              delay(10000+random(60000));
            end;
          CLRSCR;
          writeln(hour,':',minute);
        end else
      if s='DATE' then
        begin
          getdate(year,month,day,dayofweek);
          CLRSCR;
          write(year,', ');
          if month=1 then write('JANUARY') else
          if month=2 then write('FEBRUARY') else
          if month=3 then write('MARCH') else
          if month=4 then write('APRIL') else
          if month=5 then write('MAY') else
          if month=6 then write('JUNE') else
          if month=7 then write('JULY') else
          if month=8 then write('AUGUST') else
          if month=9 then write('SEPTEMBER') else
          if month=10 then write('OCTOBER') else
          if month=11 then write('NOVEMBER') else
          if month=12 then write('DECEMBER');
          write('(',month,'), ');
          write('day',day,', ');
          if dayofweek=0 then write('SUNDAY') else
          if dayofweek=1 then write('MONDAY') else
          if dayofweek=2 then write('TUESDAY') else
          if dayofweek=3 then write('WEDNESDAY') else
          if dayofweek=4 then write('THURSDAY') else
          if dayofweek=5 then write('FRIDAY') else
          if dayofweek=6 then write('SATURDAY');
          writeln;
        end else
      if s='DATA' then
        begin
          CLRSCR;
          for i:=1 to 30 do
            begin
              if diskfree(i)=-1 then continue;
              writeln;
              write('Drive: ');
              if i=1 then writeln('A');
              if i=2 then writeln('B');
              if i=3 then writeln('C');
              if i=4 then writeln('D');
              if i=5 then writeln('E');
              if i=6 then writeln('F');
              if i=7 then writeln('G');
              if i=8 then writeln('H');
              if i=9 then writeln('I');
              if i=10 then writeln('J');
              if i=11 then writeln('K');
              if i=12 then writeln('L');
              if i=13 then writeln('M');
              if i=14 then writeln('N');
              if i=15 then writeln('O');
              if i=16 then writeln('P');
              if i=17 then writeln('Q');
              if i=18 then writeln('R');
              if i=19 then writeln('S');
              if i=20 then writeln('T');
              if i=21 then writeln('U');
              if i=22 then writeln('V');
              if i=23 then writeln('W');
              if i=24 then writeln('X');
              if i=25 then writeln('Y');
              if i=26 then writeln('Z');
              writeln('Total free space: ',diskfree(i),' bytes, ( ',diskfree(i)div 1048576,' Mb)');
              writeln('Total busy space: ',disksize(i)-diskfree(i),' bytes, ( ',(disksize(i)-diskfree(i))div 1048576,' Mb)');
              writeln('Total disk size: ',disksize(i),' bytes, ( ',disksize(i) div 1048576,' Mb)');
            end;
          writeln;
          {writeln('Should I start file manager? y/n');
          ch:=readkey;
          CLRSCR;
          s:='C:';
          chdir(s+'\');
          if ch='n' then
            begin
              CLRSCR;
              continue;
            end;
 else
            begin
              writeln('I don''t know this command...');
              delay(30000);
              continue;
            end;}
        end else
      if s='COLOR' then
        begin
          CLRSCR;
          write('color: ');
          readln(s);
          if s='red' then textcolor(red) else
          if s='green' then textcolor(green) else
          if s='blink' then textcolor(125) else
          if s='yellow' then textcolor(yellow) else
          if s='white' then textcolor(white) else
          if s='blue' then textcolor(cyan) else
          if s='magenta' then textcolor(magenta) else
          if s='orange' then textcolor(6);
            begin
              writeln(' ... ');
              if s='exit' then exit;
              val(s,i,fignya);
              if fignya<>0 then
                begin
                  writeln('Uncknown color');
                  continue;
                end;
              textcolor(i);
              writeln('I know this color');
            end;
        end else
        if (s='COMMAND STRING')or(s='DOS STRING') then
        begin
          CLRSCR;
          repeat
            write('Please enter DOS command: ');
            readln(command);
            if command <> '' then
            begin
              Swapvectors;
              Exec(GetEnv('COMSPEC'), '/C '+ Command);
              SwapVectors;
              if DosError <> 0 then
                Writeln('Could not execute COMMAND.COM');
                writeln;
            end;
          until command='';
        end else
      if s='HISTORY' then
        begin
          for i:=1 to max do
          for j:=1 to max do r[i,j]:='.';
          for a:=1 to u do
            begin
              CLRSCR;
              r[history[a,1],history[a,2]]:='X';
              r[history[a,3],history[a,4]]:='O';
              l:=Nashi_5('X');
              l:=Nashi_5('O');
              textcolor(green);
             writeln;
             write('  ');
             for i:=1 to max do if i<10 then write(i,' ') else write(i);
        for i:=1 to max do
        for j:=1 to max do
          begin
            if j=1 then
              begin
                if i<>1 then write(i-1,' ');
                writeln;
                if i>=10 then write(i) else write(i,' ');
              end;
            if r[i,j]='X' then textcolor(red) else
            if r[i,j]='O' then textcolor(yellow) else
            if (r[i,j]='o')or(r[i,j]='x') then textcolor(125) else textcolor(green);
            if r[i,j]='x' then write('X ') else
            if r[i,j]='o' then write('O ') else write(r[i,j],' ');
            textcolor(green);
          end;
         writeln(max);
         write('  ');
         for i:=1 to max do if i>=10 then write(i) else write(i,' ');
         writeln;
        textcolor(green);
              readkey;
            end;
        end;
    end;
end.
