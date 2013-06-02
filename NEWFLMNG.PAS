         {$M 02000, 0, 0 }
{$L+}                           {$F+}
{$A+}                           {$P-}
{$B-}                           {$Q-}
{$C Moveable Preload Permament} {$N+}
{$D+}                           {$S-}
{$E+}                           {$X+}
{$V-}                           {$W+}
{$R-}                           {$T+}
{$Y+}                           {$O-}
{$G-}                           {$X+}

{-----------------------------------}
{The program tested on this systems:}
{Windows Xp Alternative             }
{Windows Xp Professional            }
{Windows Vista Home edition         }
{Windows 7 Ultimate                 }
{Windows PE NervOs                  }
{Dos paragon 2000                   }
{Dos from hiren's boot cd           }
{Dos from Reranimator EE 2009       }
{MSDos 7.1                          }
{-----------------------------------}
{ Current version is recreated, but }
{without rewriting copy and deleting}
{-----------------------------------}       {__}
{      Version of program ?=$version           }
{    ---------------------------    }       {  }
{         Program created           }       {  }
{               by                  }       {  }
{         TYULBASHEV V.S.           }       {  }
{ --------------------------------- }       {  }
{ (c) NEWFLMNGR 14.07.09-01.01.10   }       {  }
{-----------------------------------}       {  }
                                            {  }
Uses CRT,DOS;                 {--------------  }
const                           version=6.10; {}
                              {--------------}
  DelayExitMessage=001500 div 10;
  TimeToHelp=50;         {millisecond}
  QuantityFunc=14;
  functions:array[1..QuantityFunc] of string=(
                   'Exit                                  ',
                   'Copy file or folder                   ',
                   'Change disk                           ',
                   'Create folder                         ',
                   'Execute                               ',
                   'Disk data                             ',
                   'My_CMDline                            ',
                   'Erase files                           ',
                   'Move files                            ',
                   'Parametrs of chosen file or folder    ',
                   'Graph                                 ',
                   'Colours                               ',
                   'Default options                       ',
                   'Help                                  '
                 );
{-------------------------programs-----------------------------}
  MPLAYERC='C:\PROGRA~1\K-LITE~1\MEDIAP~1\MPLAYERC.EXE';
  WNOTEPAD='C:\WINDOWS\NOTEPAD.EXE';
  WMSPAINT='C:\WINDOWS\system32\mspaint.EXE';
  WINRAR__='C:\progra~1\WinRar\winrar.exe';
  NONENONE='C:\WINDOWS\CMD.EXE';
{---------------------------CRT-----------------------------------}
  stCheckSnow=false;
  stDirectVideo=true;
{--------------------------colors---------------------------------}
  stblack=0;
  stfolder=7{lightgreen/brown};
  stvidel=black;
  stgreen=2{10};
  stbrown=8{11};
  stcyan=lightcyan;
  stblue=lightblue;
  stred=lightred;
  stmagenta=lightmagenta;
  stgray=lightgray;
  storange=yellow;
{-------------------------1234567890------------------------------}
  strezim=25;
  ststart=strezim-6;
  stlongline=strezim-5;
  stlongword=38;
  stdela=0000000 div 2;
{-----------------------on/off------------------------------------}
  stclre='on';
  stclrs='on';
  stmiganie='on';
  stglyuk='off';
  stbug='off';
  stcursor_place='off';
  stsafely_mode='off';
  stmatrix_is_searching_you='off';
  glyuk2='off';
var
searchmas:array[1..100,1..2]of searchrec;
{--------------------------on/off------------------------------}
clre,clrs,miganie,glyuk,bug,cursor_place,safely_mode,matrix_is_searching_you:string;
{--------------------------colors------------------------------}
videl,green,brown,cyan,blue,red,magenta,gray,orange,black,folder:integer;
pan:array[1..100,1..2]of boolean;
binary:array[1..8]of integer;
leftpanel,rightpanel:integer;
leftadress,rightadress:string;
rezim,start,longword,longline:integer;
leftname,rightname:string;
hour,minute,sec,sec100:word;
timetime:longint;
dela:longint;
command_line_count:integer;
leftstart,rightstart:integer;
bgiadress:string;
null:searchrec;
panel:boolean;
func,i:integer;
s:string;
ch:char;
pch:char;
special_key:boolean;
lk:boolean;
restart:boolean;
adrr:pointer;
ws:set of char;
leftline,rightline:integer;
label l1,l2,l3,l4;

procedure exitwrite; forward;


function ras(s:string):string;
var z,q:string;
begin
  ras:='';
  z:=copy(s,length(s)-3,4);
  q:=copy(s,length(s)-4,5);
  {Microsoft office notepad}
  if (z='.TXT')or(z='.PAS')or
     (z='.INI')or(z='.BAK')or
     (z='.INF')or(z='.SYS')or
     (z='.LOG')then
    ras:=WNOTEPAD else
  {Microsoft offise Paint}
  if (z='.JPG')or(z='.PNG')or
     (q='.JPEG')or(z='.GIF')or
     (z='.ICO')or(z='.BMP')then
    ras:=WMSPAINT else
  {Microsoft media player}
  if (z='.MP3')or(z='.AVI')or(z='.WMV') then
    ras:=mplayerc else
  {WinRar}
  if (z='.RAR')or(z='.ZIP')or(z='.CAB') THEN
    ras:=WINRAR__ else
  if (z='.EXE')or(z='.COM')or(z='.BAT') then
    ras:='' else ras:=NONENONE;
end;
function min(a,b:integer):integer;
begin
if a<b then min:=a else min:=b;
end;
function readk:char;
begin
  readk:=readkey;
end;
function readkey:char;
var ch:char;
begin
  ch:=readk;
  special_key:=false;
  if ch=#0 then
    begin
      special_key:=true;
      ch:=readk;
      if ch=#80 then ch:='s' else
      if ch=#77 then ch:='d' else
      if ch=#75 then ch:='a' else
      if ch=#72 then ch:='w' else
      if ch=#63 then ch:=#240 else {Copying [f5]}
      if ch=#64 then ch:=#239 else {Moving  [f6]}
      if ch=#68 then ch:=#238 else {Exitting[f10]}
      if ch=#104 then ch:=#237 else{alt+[f1]}
      if ch=#105 then ch:=#236 else{alt+[f2]}
      if ch=#83 then ch:=#235 else {delete}
      if ch=#67 then ch:='`' else  {special menu}
      if ch=#59 then ch:=#234 else {help}
      if ch=#81 then ch:=#233 else {page down}
      if ch=#73 then ch:=#232 else {page   up};
    end;
  readkey:=ch;
end;
procedure chi(ch:char);
begin
  if ch='s' then clrscr else clreol;
end;
procedure clrscr;
var i:integer;
begin
  if clrs='on' then
    begin
      chi('s');
      exit;
    end;
  gotoxy(1,1);
  for i:=1 to 100 do write('                                            ');
  gotoxy(1,1);
end;
procedure clreol;
var x,y,i:integer;
begin
  if clre='on' then
    begin
      chi('e');
      exit;
    end;
  x:=wherex;
  y:=wherey;
  for i:=1 to 80-x do write(' ');
  gotoxy(x,y);
end;
procedure copyfile(f1,f2:string);
var i:integer;
t:text;
attr:word;
begin
  {$I-}
  assigncrt(output);
  append(output);
  write(chr(random(100)+20),'> copy /B '+f1+' '+f2+' : ');
  for i:=4 to length(f2) do if f2[i]='\' then mkdir(copy(f2,1,i-1));
  assign(t,f1);
  getfattr(t,attr);
  setfattr(t,0);
  swapvectors;
  {exec(f1[1]+f1[2],'');   }
  exec(getenv('COMSPEC'),'/C copy /B '+f1+' '+f2);
  swapvectors;
  setfattr(t,attr);
  assign(t,f2);
  setfattr(t,attr);
  {$I+}
  if ioresult<>0 then writeln('Error : ',random(255));
end;
procedure erasefile(f:string);
var t:text;
begin
  {$I-}
  assigncrt(output);
  append(output);
  writeln(chr(random(100)+20),'> erase ',f);
  assign(t,f);
  setfattr(t,0);
  erase(t);
  {$I+}
  if ioresult=0 then ;
end;
procedure about(r:char);
var i:integer;
begin
  clrscr;
  textcolor(2);
  for i:=1 to 6 do writeln;
writeln('                     -----------------------------------');
writeln('                           Version of program ',version:3:2,'      ');
writeln('                         ---------------------------    ');
writeln('                              Program created           ');
writeln('                                    by                  ');
writeln('                                TYULBASHEV              ');
writeln('                      --------------------------------- ');
writeln('                      (c) NEWFLMNGR 14.07.09-21.11.09   ');
writeln('                     -----------------------------------');
  if r<>'r' then readkey;
end;

procedure help;
const
  QuantityFunc=7;
  functions:array[1..QuantityFunc]of string =
          (
            'About program               ',
            'First menu                  ',
            'Second menu                 ',
            'Second menu =>- Colours     ',
            'Second menu =>- My_CMDline  ',
            'Second menu =>- Chage disk  ',
            'Exit                        '
          );
var ch,pr:char;
  func:integer;
procedure wrt;
var i:integer;
begin
  gotoxy(1,1);
  textcolor(white);
  textbackground(black);
  writeln('                              ******HELP******');
  writeln;
  writeln;
  for i:=1 to QuantityFunc do
    begin
      textbackground(black);
      write('                         ');
                  if i=func then
                    begin
                      textbackground(cyan);
                      textcolor(videl);
                    end else
                    begin
                      textbackground(black);
                      textcolor(green);
                    end;
                  writeln(functions[i]);
    end;
end;
procedure hlpcm;
begin
  textbackground(black);
  textcolor(15);
  clrscr;
  writeln('                              ******HELP******');
  textcolor(gray);
  writeln;
  writeln;
  writeln;
  writeln('                      This function execute commands             ');
  writeln('                        from CMDline [command.com]               ');
  writeln('                        while you not press enter                ');
  writeln('                       and the string isn''t empty.              ');
  writeln('                        This function also execute               ');
  writeln('                      special commands. To run there:            ');
  writeln('                           "default"+SecretCode.                 ');
  readkey;
end;
procedure color;
begin
  textbackground(black);
  textcolor(white);
  clrscr;
  writeln('                              ******HELP******');
  textcolor(gray);
  writeln;
  writeln;
  writeln('                   To run Colour you must open second menu    ');
  writeln('                  and choose punkt "Colour" then press enter  ');
  writeln;
  writeln;
  writeln('                   "W"   ------------------   to move up               ');
  writeln('                   "S"   ------------------   to move down             ');
  writeln('                   "D"   ------------------   to "inc" color           ');
  writeln('                   "A"   ------------------   to "dec" color           ');
  readkey;
end;
procedure frstm;
begin
  textbackground(black);
  clrscr;
  textcolor(white);
  writeln('                              ******HELP******');
  writeln;
  writeln;
  writeln('                 in first menu you can use next commands:');
  writeln;
  writeln;
  textcolor(gray);
  writeln('               "W"   ---------------   to move cursor up                      ');
  writeln('               "S"   ---------------   to move cursor down                    ');
  writeln('               "A"   ---------------   to move cursor to left panel           ');
  writeln('               "D"   ---------------   to move cursor to right panel          ');
  writeln('               "`"   ---------------   to moving to second menu               ');
  writeln('               "|"   ---------------   to writting all symbols                ');
  writeln('               "@"   ---------------   to restart newflmng and kill bugs      ');
  writeln('               ""   ---------------   to view the attributes                 ');
  writeln('                                       of choosen file or folder [ctrl+"a"]   ');
  writeln('               " "   ---------------   to trying of renaming of file or folder');
  writeln('               #13   ---------------   to trying of executing file or         ');
  writeln('                                       to entering to the folder [enter]      ');
  writeln('               #9    ---------------   to moving to another panel [tabulation]');
  readkey;
end;
procedure scndm;
begin
  textbackground(black);
  clrscr;
  textcolor(white);
  writeln('                              ******HELP******');
  writeln;
  writeln;
  writeln('                 in second menu you can use next commands:');
  writeln;
  writeln;
  textcolor(gray);
  write('                "W"   ---------------   to move cursor up                      ');
  write('                "S"   ---------------   to move cursor down                    ');
  write('                #13   ---------------   to executing choosen function  [enter] ');
  write('                #27   ---------------   to exitting from second menu and       ');
  write('                                        moving to first menu           [escape]');
  readkey;
end;
procedure disks;
begin
  textbackground(black);
  clrscr;
  textcolor(white);
  writeln('                              ******HELP******');
  writeln;
  textcolor(gray);
  writeln;
  writeln('                This function is using for cheking');
  writeln('                all disks and change it to other  ');
  writeln('                In this function you should write ');
  writeln('                one of the disk which was writting');
  writeln('                by the function and press enter to continue');
  readkey;
end;
label l1;
var currentmode:integer;
begin
  func:=1;
  currentmode:=lastmode;
  if safely_mode='off' then textmode(co80);
  l1:;
  window(1,1,80,25);
  window(1,1,80,43);
  clrscr;
  window(2,3,80,25);
  window(2,3,80,43);
  textbackground(black);
  textcolor(white);
  ch:=#2;
  while ch<>#13 do
    begin
      wrt;
      ch:=#2;
      while (UpCase(ch)<>'W')and(UpCase(ch)<>'S')and(ch<>#13)and(ord(ch)<>27)do ch:=readkey;
      if ord(ch)=27 then
        begin
          func:=7;
          exit;
        end else
      if UpCase(ch)='W' then dec(func) else
      if UpCase(ch)='S' then inc(func);
      if func=0 then func:=QuantityFunc;
      if func=QuantityFunc+1 then func:=1;
    end;
  if func=1 then
    begin
      exitwrite;
      readkey;
    end else
  if func=2 then frstm else
  if func=3 then scndm else
  if func=4 then color else
  if func=5 then hlpcm else
  if func=6 then disks else
  if func=7 then
    begin
      if safely_mode='off' then textmode(currentmode);
      exit;
    end;
  goto l1;
end;
procedure colour;
const QuantityFunc=8;
functions:array[1..QuantityFunc]of string=
            (
              'Color of background                      ',
              'Standart color of text and watch         ',
              'Color of error messages                  ',
              'Color of board                           ',
              'Color of choosen string                  ',
              'Color of board in messages and background',
              'Color of strings in help                 ',
              'Color of all not-choosen folders         '
            );
procedure wrt;
begin
  gotoxy(1,1);
  for i:=1 to QuantityFunc do
    begin
                  if i=func then
                    begin
                      textbackground(cyan);
                      textcolor(videl);
                    end else
                    begin
                      textbackground(black);
                      textcolor(gray);
                    end;
                  write(functions[i]);
                  textbackground(black);
                  write('   -------------   ');
     if i=1 then
       begin
         if cyan=0 then textbackground(15) else textbackground(black);
         textcolor(cyan);
         write(cyan);
       end else
     if i=2 then
       begin
         if green=0 then textbackground(15) else textbackground(black);
         textcolor(green);
         write(green);
       end else
     if i=3 then
       begin
         if red=0 then textbackground(15) else textbackground(black);
         textcolor(red);
         write(red);
       end;
     if i=4 then
       begin
         if brown=0 then textbackground(15) else textbackground(black);
         textcolor(brown);
         write(brown);
       end;
     if i=5 then
       begin
         if videl=0 then textbackground(15) else textbackground(black);
         textcolor(videl);
         write(videl);
       end;
     if i=6 then
       begin
         if black=0 then textbackground(15) else textbackground(black);
         textcolor(black);
         write(black);
       end;
     if i=7 then
       begin
         if gray=0 then textbackground(15) else textbackground(black);
         textcolor(gray);
         write(gray);
       end;
     if i=8 then
       begin
         if folder=0 then textbackground(15) else textbackground(black);
         textcolor(folder);
         write(folder);
       end;

     writeln('    ');
    end;

end;
begin
  ch:='';
  func:=1;
  window(1,1,80,25);
  clrscr;
  writeln('                          *****Colors menu*****');
  window(10,4,80,25);
  window(10,4,80,43);
  clrscr;
  while ch<>#13 do
    begin
      wrt;
      ch:=#2;
      while (UpCase(ch)<>'A')and(UpCase(ch)<>'D')and(ch<>#13)and(UpCase(ch)<>'W')and(UpCase(ch)<>'S') do ch:=readkey;

      if UpCase(ch)='W' then dec(func) else
      if UpCase(ch)='S' then inc(func);
      if func=0 then inc(func);
      if func=QuantityFunc+1 then dec(func);

      if (func=1) then
      if (UpCase(ch)='A') then dec(cyan) else
      if (UpCase(ch)='D') then inc(cyan);

      if (func=2) then
      if (UpCase(ch)='A') then dec(green) else
      if (UpCase(ch)='D') then inc(green);

      if (func=3) then
      if (UpCase(ch)='A') then dec(red) else
      if (UpCase(ch)='D') then inc(red);

      if (func=4) then
      if (UpCase(ch)='A') then dec(brown) else
      if (UpCase(ch)='D') then inc(brown);

      if (func=5) then
      if (UpCase(ch)='A') then dec(videl) else
      if (UpCase(ch)='D') then inc(videl);

      if (func=6) then
      if (UpCase(ch)='A') then dec(black) else
      if (UpCase(ch)='D') then inc(black);

      if (func=7) then
      if (UpCase(ch)='A') then dec(gray) else
      if (UpCase(ch)='D') then inc(gray);

      if (func=8) then
      if (UpCase(ch)='A') then dec(folder) else
      if (UpCase(ch)='D') then inc(folder);

    end;
end;
function sokr(s:string;
              i:integer):string;
var q:string;
begin
  q:=s;
  if i<length(s) then
    begin
      q:=copy(s,4,i-4);
      while q[1]<>'\' do delete(q,1,1);
      q:=copy(s,1,3)+'...'+q;
    end;
  sokr:=q;
end;
procedure data;
var i:integer;
begin
  window(2,2,79,21);
  window(2,2,79,39);
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

              delay(33333);delay(33333);delay(33333);
              if keypressed then
                begin
                  readkey;
                  readkey;
                end;
            end;
  readkey;
end;
procedure date;
var
hour,minute,sec,sec100:word;
a,b:string;
begin
{randomize;
if random(5)=0 then exit;}
window(1,1,80,25);
window(1,1,80,43);
  if cursor_place='on' then gotoxy(command_line_count,25);
  if cursor_place='on' then gotoxy(command_line_count,43);
  gettime(hour,minute,sec,sec100);
  {write(hour,':',minute,':',sec,':',sec100);}
  {if minute<10 then write('0');
  write(minute,':');
  if sec<10 then write('0');
  write(sec,',');
  if sec100<10 then write('0');
  write(sec100);
  textcolor(black); }
  {textcolor(white);}
  str(hour div 10,a);
  b:=a;
  str(hour mod 10,a);
  b:=b+a+':';
  str(minute div 10,a);
  b:=b+a;
  str(minute mod 10,a);
  b:=b+a+':';
  str(sec div 10,a);
  b:=b+a;
  str(sec mod 10,a);
  b:=b+a+',';
  str(sec100 div 10,a);
  b:=b+a;
  str(sec100 mod 10,a);
  b:=b+a;
  gotoxy(69,25);
  gotoxy(69,43);
  write(b);
  if cursor_place='on' then gotoxy(command_line_count,25);
  if cursor_place='on' then gotoxy(command_line_count,43);
  delay(dela);
  delay(dela);


  textcolor(green);
  {
  window(2,2,79,21);
  window(2,2,79,40);}
end;
procedure line;
var i:integer;
begin
  textcolor(brown);
  for i:=1 to longline do
    begin
      gotoxy(39,i);
      write(chr(186));
    end;
  textcolor(green);
end;
procedure windows;
var i:integer;
year,month,day,dayofweek,x,y:word;
begin
  textbackground(black);
  textcolor(brown);
  window(1,1,80,25);
  window(1,1,80,43);
  clrscr;
  for i:=2 to rezim-1 do
    begin
      gotoxy(1,i);
      write(chr(186));
      gotoxy(80,i);
      write(chr(186));
    end;
  gotoxy(1,24);
  gotoxy(1,42);
  write(chr(200));
  for i:=2 to 79 do write(chr(205));
  write(chr(188));
  gotoxy(1,1);
  write(chr(201));
  for i:=2 to 39 do write(chr(205));
  write(chr(203));
  for i:=41 to 79 do write(chr(205));
  writeln(chr(187));

  gotoxy(1,22);
  gotoxy(1,40);
  write(chr(204));
  for i:=2 to 32 do write(chr(205));
 { write(chr(202));}
  for i:=33 to 79 do write(chr(205));
  write(chr(185));
  gotoxy(80,23);
  gotoxy(80,41);
  writeln(chr(186));
  gotoxy(60,24);
  gotoxy(60,42);
  writeln(chr(203));
  gotoxy(68,24);
  gotoxy(68,42);
  writeln(chr(203));
  gotoxy(40,22);
  gotoxy(40,40);
  writeln(chr(206));
  gotoxy(40,24);
  gotoxy(40,42);
  writeln(chr(202));
  gotoxy(40,23);
  gotoxy(40,41);
  writeln(chr(186));
  gotoxy(1,23);
  gotoxy(1,41);
  write(chr(186));
  textcolor(green);
  {clreol;    }
getdate(year,month,day,dayofweek);
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
          write('(',month,'), day',day,', ');
          if dayofweek=0 then write('SUNDAY') else
          if dayofweek=1 then write('MONDAY') else
          if dayofweek=2 then write('TUESDAY') else
          if dayofweek=3 then write('WEDNESDAY') else
          if dayofweek=4 then write('THURSDAY') else
          if dayofweek=5 then write('FRIDAY') else
          if dayofweek=6 then write('SATURDAY');
  gotoxy(42,23);
  gotoxy(42,41);
  write('File #');
  gotoxy(71,24);
  gotoxy(71,42);
  gotoxy(52,23);
  gotoxy(52,41);
  write('Name: ');
  gotoxy(72,23);
  gotoxy(72,41);
  write('Attr: ');
  textcolor(brown);
  gotoxy(71,24);
  gotoxy(71,43);
  write(chr(207));
  gotoxy(51,24);
  gotoxy(51,42);
  write(chr(207));
  gotoxy(71,22);
  gotoxy(71,40);
  write(chr(209));
  gotoxy(51,22);
  gotoxy(51,40);
  write(chr(209));
  gotoxy(71,23);
  gotoxy(71,41);
  write(chr(179));
  gotoxy(51,23);
  gotoxy(51,41);
  write(chr(179));
  window(2, 2, 79, 21);
  window(2, 2, 79, 39);
textcolor(green);
end;
procedure message;
var i:integer;
begin
  window(20,6,50,13);
  textbackground(cyan);
  textcolor(black);
  write(chr(201));
  for i:=21 to 48 do write(chr(205));
  writeln(chr(187));
  for i:=7 to 12 do writeln(chr(186),'                            ',chr(186));
  write(chr(200));
  for i:=21 to 48 do write(chr(205));
  write(chr(188));
  window(21,7,48,12);
  gotoxy(5,3);
end;
function max(a,b:integer):integer;
begin
  if a>b then max:=a else max:=b;
end;
function abs(a:integer):integer;
begin
  if -a>a then abs:=-a else abs:=a;
end;
procedure prov;
begin
  if leftline<=0 then leftline:=1 else
  if rightline<=0 then rightline:=1 else
  if leftline>=leftpanel+1 then leftline:=leftpanel else
  if rightline>=rightpanel+1 then rightline:=rightpanel;

  if {panel and} (abs(leftline-leftstart)>start) then
  if leftline>leftstart+start then leftstart:=leftline-start;
  if leftstart=leftline+1 then dec(leftstart);

  if {not panel and} (abs(rightline-rightstart)>start) then
  if rightline>rightstart+start then rightstart:=rightline-start;
  if rightstart=rightline+1 then dec(rightstart);

end;
procedure disk;
var i,j:integer;
x,y,xp,yp:integer;
pr:char;
label l1;
begin
  message;
  gotoxy(1,1);
  if panel then writeln('> Adress: ',sokr(leftadress,17)) else
                writeln('> Adress: ',sokr(rightadress,17));
  ws:=[];
  write('> Drives: ');
  xp:=20;
  yp:=6;
  for i:=1 to 26 do
    begin
      x:=wherex;
      y:=wherey;
      textbackground(black);
      window(1,23,79,24);
      window(1,41,79,42);
      for j:=1 to 78 do write(' ');
      textcolor(brown);
      gotoxy(1,1);
      write(chr(186));
      textcolor(green);
      write('This space reserved for messages');
      textcolor(brown);
      write('      ',chr(186),'          ',chr(179),'                   ',chr(179));
      textbackground(cyan);
      window(1,22,79,22);
      window(1,40,79,40);
      textcolor(green);
      window(x+xp,y+yp,x+xp+2,y+yp);
      xp:=x+xp-1;
      yp:=y+yp-1;
      IF DISKFREE(I)=-1 THEN continue;
      textcolor(black);
              if i=1 then ws:=ws+['A'];
              if i=2 then ws:=ws+['B'];
              if i=3 then ws:=ws+['C'];
              if i=4 then ws:=ws+['D'];
              if i=5 then ws:=ws+['E'];
              if i=6 then ws:=ws+['F'];
              if i=7 then ws:=ws+['G'];
              if i=8 then ws:=ws+['H'];
              if i=9 then ws:=ws+['I'];
              if i=10 then ws:=ws+['J'];
              if i=11 then ws:=ws+['K'];
              if i=12 then ws:=ws+['L'];
              if i=13 then ws:=ws+['M'];
              if i=14 then ws:=ws+['N'];
              if i=15 then ws:=ws+['O'];
              if i=16 then ws:=ws+['P'];
              if i=17 then ws:=ws+['Q'];
              if i=18 then ws:=ws+['R'];
              if i=19 then ws:=ws+['S'];
              if i=20 then ws:=ws+['T'];
              if i=21 then ws:=ws+['U'];
              if i=22 then ws:=ws+['V'];
              if i=23 then ws:=ws+['W'];
              if i=24 then ws:=ws+['X'];
              if i=25 then ws:=ws+['Y'];
              if i=26 then ws:=ws+['Z'];
       write(chr(i+64),' ');
     end;
  window(21,7,48,12);
  textcolor(black);
  writeln;
  writeln;
  {if not panel then writeln('> ',leftadress) else
                writeln('> ',rightadress);        }
  if panel then writeln('> Leftpanel') else
                writeln('> Rightpanel');
  gotoxy(1,5);
  write('> Please enter new disk: ');
  ch:='C';
  write('C');
  while ord(ch)<>13 do
    begin
      pr:=ch;
      ch:='`';
      while (not (UpCase(ch) in ws))and(ord(ch)<>13)and(ord(ch)<>27) do ch:=readkey;
      gotoxy(26,5);
      write(ch);
      if ch=#27 then goto l1;
    end;
  ch:=pr;
  {$I-}
  for i:=1 to 10 do
    begin
  chdir(ch);
  if ioresult=ioresult then halt(1);
  chdir(ch+':\.');
  if ioresult=0 then
  if panel then leftadress:=ch+':' else
                rightadress:=ch+':' else
                  begin
                    writeln('> I can''t');
                    readkey;
                  end;
    end;
  {$I+}
  l1:;
  windows;
end;

procedure poisk(x:integer;
                s:string);
var i:integer;
search:searchrec;
begin
  i:=0;
  prov;
  if (x=1) and panel then for i:=1 to 100 do pan[i,1]:=false;
  if (x=2) and not panel then for i:=1 to 100 do pan[i,2]:=false;
  if glyuk2='off' then i:=0;
  {$I-}
  chdir('c:\');
  chdir('c:\');
  chdir('..');
  if x=1 then
    begin
      {chdir(leftadress+'\');}
      chdir(leftadress);
    end
    else
    begin
      {chdir(rightadress+'\');}
      chdir(rightadress);
    end;
  if ioresult<>0 then if x=1 then chdir(leftadress+'\.\.') else chdir(rightadress+'\.\.');
  {$I+}
  if IOResult<>0 then
    begin
      message;
      textcolor(red);
      writeln('>   Unknown error');
      if panel then writeln('>Error in left panel')else writeln('Error in right panel');
      writeln('>   Error adres:>');
      if panel then writeln(leftadress) else writeln(rightadress);
      readkey;
      disk;
    end;
  findfirst('*.*',$3F,search);
  if search.name='.' then findnext(search);
  while (doserror=0)and(i<99) do
    begin
      inc(i);
      searchmas[i,x]:=search;
      findnext(search);
    end;
  if x=1 then leftpanel:=i else rightpanel:=i;
  if i=99 then
  if ((panel=true)and(x=1))or((panel=false)and(x=2)) then
    begin
      message;
      gotoxy(5,2);
      i:=0;
      textcolor(red);
      writeln('> Too many files');
      gotoxy(5,3);
      write('  and folders: ');
      findfirst('*.*',$3F,search);
        while (doserror=0) do
               begin
                 inc(i);
                 findnext(search);
               end;
      writeln(i);
      readkey;
      windows;
      clrscr;
    end;
  prov;
end;
procedure com_str(l:boolean;s:string);
Var ProgramName, CmdLine : String;
label l1;
Begin
 cmdline:='';
 if l then
   begin
     programname:=s;
     goto l1;
   end;
 message;
 Writeln('    Execute:     ');
 ReadLn(ProgramName);
 Writeln('Paramstr : ');
 ReadLn(CmdLine);
 Write('Try to execute...');
 l1:;
 window(1,1,80,25);
 window(1,1,80,43);
 textbackground(black);
 clrscr;
 SwapVectors;
 Exec(ProgramName, CmdLine);
 SwapVectors;
 writeln;
 textcolor(125);
 writeln('Plese press any key to continue...');
 textcolor(green);
 readkey;
 DELLINE;
 {WriteLn('... вернулся из Exec');}
 { Была ошибка ? }{
 If DosError<>0 Then WriteLn('Ошибка DOS #', DosError)
 Else WriteLn('Запуск был удачным. Код выхода = ', DosExitCode);   }
 clrscr;
 message;
 if doserror<>0 then textcolor(red);
 writeln('> Function: exec');
 if doserror=0 then writeln('> Result: OK, dosserror=',doserror) else
                    write('> Result: FAILED dosserror=',doserror);
 writeln('> Kod of exit: ',dosexitcode);
 writeln('> Program Name: ');
 writeln(programname,' : ',cmdline);
   begin
     if doserror=2 then write('> File not found');
     if doserror=3 then write('> Path not found');
     if doserror=5 then write('> File access denided');
     if doserror=6 then write('> Inadmissible descriptor');
     if doserror=8 then write('> Too litle memory');
   end;
 readkey;
 window(1,1,80,25);
 windows;
End;

procedure wrt;
var i,j:integer;
q,x:string;
begin
  prov;
  textbackground(black);
  window(1,1,80,25);
  window(1,1,80,43);
  gotoxy(48,23);
  gotoxy(48,41);
  if panel then write(leftline) else write(rightline);
  if panel and(leftline<10) then write(' ') else
  if not panel and (rightline<10) then write(' ');
  textcolor(10);
  if panel and pan[leftline,1] then write('C') else
  if not panel and pan[rightline,2] then write('C') else
  if panel and (leftline=1) then write(chr(31)) else
  if not panel and (rightline=1) then write(chr(31)) else
  if panel and (leftline=leftpanel) then write(chr(30)) else
  if not panel and (rightline=rightpanel) then write(chr(30)) else write(chr(18));
  textcolor(green);
  gotoxy(58,23);
  GOTOXY(58,41);
  if panel then write(searchmas[leftline,1].name) else write(searchmas[rightline,2].name);
  if panel then for i:=1 to 12-length(searchmas[leftline,1].name) do write(' ') else
                for i:=1 to 12-length(searchmas[rightline,2].name) do write(' ');
  gotoxy(77,23);
  gotoxy(77,41);
  if panel then write(searchmas[leftline,1].attr) else write(searchmas[rightline,2].attr);
  if panel then
  if searchmas[leftline,1].attr<10 then write(' ') else else
  if searchmas[rightline,1].attr<10 then write(' ');
  gotoxy(1,25);
  gotoxy(1,43);
  if panel then
    begin
      write(sokr(leftadress,60)+'\');
      command_line_count:=wherex;
      for i:=length(sokr(leftadress,60)) to 60-length(sokr(leftadress,60))+1 do write(' ');
    end else
    begin
      write(sokr(rightadress,60)+'\');
      command_line_count:=wherex;
      for i:=length(sokr(rightadress,60)) to 60-length(sokr(rightadress,60))+1 do write(' ');
    end;
  gotoxy(61,25);
  gotoxy(61,43);
  textcolor(blue);
  write(leftpanel,'<->',rightpanel);
  textcolor(brown);
  gotoxy(60,25);
  gotoxy(60,43);
  write(chr(186));
  gotoxy(68,25);
  gotoxy(68,43);
  write(chr(186));
  textcolor(green);
  date;
  window(2,2,79,22);
  window(2,2,79,41);
  for i:=0 to {min(max(leftpanel,rightpanel),}start do
    begin
      begin
      gotoxy(1,i+1);
       if (panel)and(leftline=i+leftstart) then textbackground(cyan) else textbackground(black);
      if pan[i+leftstart,1] then textcolor(yellow) else
      if (panel)and(leftline=i+leftstart) then textcolor(videl) else
      if (searchmas[i+leftstart,1].attr=Directory)then textcolor(folder)
      else textcolor(green);
      x:=searchmas[i+leftstart,1].name;
      for j:=1 to longword-length(searchmas[i+leftstart,1].name) do x:=x+' ';
      write(x);
      end;
      begin
      {textcolor(brown);
      textbackground(black);
      write(chr(186),'  ');  }
      gotoxy(40,i+1);
      if pan[i+rightstart,2] then textcolor(yellow) else
      if (not panel)and(rightline=i+rightstart) then textcolor(videl) else
      if (searchmas[i+rightstart,2].attr=Directory) then textcolor(folder)
      else textcolor(green);
      if (not panel)and(rightline=i+rightstart) then textbackground(cyan) else textbackground(black);
      x:=' '+searchmas[i+rightstart,2].name;
      for j:=1 to longword-length(searchmas[i+rightstart,2].name) do x:=x+' ';
      write(x);
      delay(25);
      {writeln;}
      end;
    end;
  textbackground(black);
end;
procedure exitwrite;
var i,j:integer;
begin
  if safely_mode='off' then textmode(CO80);
  window(1,1,80,25);
  textbackground(black);
  clrscr;
  about('r');
  textcolor(gray);
  window(20,6,60,18);
  write(chr(201));
  for i:=1 to 37 do write(chr(205));
  writeln(chr(187));
  for i:=1 to 9 do
    begin
      write(chr(186));
      gotoxy(39,i+1);
      writeln(chr(186));
    end;
  write(chr(200));
  for i:=1 to 37 do write(chr(205));
  write(chr(188));
  window(1,1,80,25);
  gotoxy(1,19);
  delay(50000);
  for i:=1 to 50 do delay(DelayExitMessage);
end;
procedure f10;
var pr:char;
begin
  {window(10,5,30,8);
  textbackground(cyan);
  clrscr;
  gotoxy(1,2); }
  line;
  message;
  textcolor(red);
  gotoxy(1,3);
  writeln('      Do you really');
  write('      want to quit:');
  ch:='N';
  textbackground(blue);
  textcolor(white);
  write('N');
  textcolor(green);
  while ch<>#13 do
    begin
      pr:=ch;
      ch:='X';
      textbackground(black);
      while (UpCase(ch)<>'N')and(UpCase(ch)<>'Y')and(ch<>#13) do
        begin
          if miganie='on' then textcolor(white) else textcolor(green);
          while not keypressed do date;
          ch:=readkey;
        end;
      textbackground(blue);
      textcolor(white);
      gotoxy(40,10);
      write(ch);
    end;
  if UpCase(pr)='Y' then
    begin
      exitwrite;
      halt(1);
    end;
  windows;
end;
{procedure copy(s1,s2:string);
var ch:char;
begin
  assign(input,s1);
  assign(output,s2);
  {$I-}
  {reset(input);
  if ioresult<>0 then
    begin
      assign(input,'');
      assign(output,'');
      reset(input);
      rewrite(output);
      exit;
    end;}
  {$I+}
  {rewrite(output);
  while not(eof(input)) do
  begin
    read(ch);
    write(ch);
  end;}
{end;}
procedure options;
const
  QuantityFunc=13;
  functions:array[1..QuantityFunc]of string =
          (
            'Scentellation of watch      ',
            'My_own_procedure_clrscr     ',
            'My_own_procedure_clreol     ',
            'My_regim_mode_25/80_43/80   ',
            'My_own_bug_!!!_?!Rename     ',
            'My_own_glyuk_name?=$BuG     ',
            'My_delay_of_viewing_watch   ',
            'My_place_for_cursor         ',
            'BIOS DirectVideo            ',
            'BIOS CheckSnow              ',
            'Safely_mode                 ',
            'Searching you by matrix     ',
            'Exit                        '
          );
var func:integer;
ch:char;
procedure wrt;

begin
  gotoxy(1,3);
  for i:=1 to QuantityFunc do
    begin
                  if i=func then
                    begin
                      textbackground(cyan);
                      textcolor(videl);
                    end else
                    begin
                      textbackground(black);
                      textcolor(gray);
                    end;
                  write(functions[i],'   ---------    ');
                  if i=1 then writeln(miganie);
                  if i=2 then writeln(clrs);
                  if i=3 then writeln(clre);
                  if i=4 then writeln(rezim);
                  if i=5 then writeln(glyuk);
                  if i=6 then writeln(bug);
                  if i=7 then writeln(dela);
                  if i=8 then writeln(cursor_place);
                  if i=9 then writeln(DirectVideo);
                  if i=10 then writeln(CheckSnow);
                  if i=11 then writeln(safely_mode);
                  if i=12 then writeln(matrix_is_searching_you);
                  if i=QuantityFunc then writeln('no value');
   end;
end;
var l1,l2:boolean;
begin
  window(1,1,80,25);
  window(1,1,80,43);
  textbackground(black);
  func:=1;
  while true do
  begin
  clrscr;
  textcolor(white);
  writeln('                   *****Default options menu***** ');
  writeln;
  writeln;
  window(10,4,70,rezim-3);
  textcolor(gray);
  ch:='';
  while ch<>#13 do
    begin
      wrt;
      ch:='';
      while (UpCase(ch)<>'W')and(UpCase(ch)<>'S')and(UpCase(ch)<>#13) do ch:=readkey;
      if (UpCase(ch)='W') then dec(func);
      if (UpCase(ch)='S') then inc(func);
      if func=0 then inc(func);
      if func=QuantityFunc+1 then dec(func);
    end;
  if func=QuantityFunc then exit;
  writeln;
  writeln;
  writeln('Please enter mode: ');
  if (func=9)or(func=10) then
     begin
       readln(s);
       if func=9 then if (s<>'on')and(s<>'true') then DirectVideo:=false else DirectVideo:=true;
       if func=10 then if (s='on')or(s='true')then CheckSnow:=true else CheckSnow:=false;
       l1:=directvideo;
       l2:=checksnow;
     end else
  if func=4 then
    begin
      readln(func);
      if func=43 then rezim:=43 else rezim:=25;
      func:=4;
      if rezim=43 then if safely_mode='off' then textmode(CO80+font8x8) else if safely_mode='off' then textmode(CO80);
      start:=rezim-6;
      longline:=rezim-5;
    end else
  if func=7 then
      readln(dela) else
  readln(s);
  if s='exit' then exit;
  if func=1 then miganie:=s;
  if func=2 then clrs:=s;
  if func=3 then clre:=s;
  if func=5 then glyuk:=s;
  if func=6 then bug:=s;
  if func=8 then cursor_place:=s;
  if func=11 then safely_mode:=s;
  if func=12 then matrix_is_searching_you:=s;
 if safely_mode='off' then if bug='on' then textmode(font8x8) else if rezim=25 then textmode(co80) else textmode(co80+font8x8);
  if glyuk='off' then
    begin
      assigncrt(output);
      append(output);
    end;
  directvideo:=l1;
  checksnow:=l2;
  end;
end;
procedure cwap(var a,b:integer);
var c:integer;
begin
  c:=a;
  a:=b;
  b:=c;
end;
procedure parametr;
var mys:searchrec;
lef,rig:string;
a,attr,i:word;
time:datetime;
procedure x(v:boolean);
begin
  if v then writeln('+') else writeln('-');
end;
procedure bin(v:integer);
var i,j,q:integer;
begin
  fillchar(binary,sizeof(binary),0);
  for i:=1 to 8 do
    begin
      binary[i]:=v mod 2;
      v:=v div 2;
      if v=0 then
        begin
          q:=i;
          break;
        end;
    end;
  while binary[i]=0 do dec(i);
  j:=1;
  while j<i do
    begin
      cwap(binary[j],binary[i]);
      inc(j);
      dec(i);
    end;
  {i:=8;
  while binary[i] do dec(i);
  i:=8-i;}
  i:=8-q;
  for j:=8 downto 1 do
    binary[j]:=binary[j-i];
  for j:=1 to i do binary[j]:=0;
end;
begin
  message;
  if panel then mys:=searchmas[leftline,1] else mys:=searchmas[rightline,2];
  unpacktime(mys.time,time);
  bin(mys.attr);
  writeln('> Attributives: ',mys.attr);
  writeln('> Time: ',mys.time);
  writeln('> Size: ',mys.size);
  writeln('> Name: ',mys.name);
  readkey;
  clrscr;
    begin
      writeln('> Year: ',time.year);
      writeln('> Month: ',time.month);
      writeln('> Day: ',time.day);
      writeln('> Hour: ',time.hour);
      writeln('> Minute: ',time.min);
      write('> Second: ',time.sec);
      readkey;
      clrscr;
    end;
  repeat
    begin
      lef:=leftadress+'\'+searchmas[leftline,1].name;
      rig:=rightadress+'\'+searchmas[rightline,2].name;
      if panel then assign(input,lef) else assign(input,rig);
      getfattr(input,a);
      assign(input,'');
      reset(input);
      bin(a);
      writeln;
      {for i:=1 to 8 do write(binary[i]);
      readkey;}
      write('>\\// >ReadOnly:   '); x(binary[8]=1);
      write('>\\// >Hidden:     '); x(binary[7]=1);
      write('>\\// >SystemFile: '); x(binary[6]=1);
      write('>\\// >VolumeID:   '); x(binary[5]=1);
      write('>\\// >Directory:  '); x(binary[4]=1);
      write('>\\// >Archive:    '); if binary[3]=1 then write('+ ') else write('- ');
      ch:=readkey;
      if ch='c' then
        begin
          {$I-}
          readln(attr);
          {$I+}
          if ioresult<>0 then break;
          lef:=leftadress+'\'+searchmas[leftline,1].name;
          rig:=rightadress+'\'+searchmas[rightline,2].name;
          if panel then assign(input,lef) else assign(input,rig);
          setfattr(input,attr);
          assign(input,'');
          reset(input);
        end else
      if ch='~' then
        begin
          windows;
          for i:=1 to 20 do writeln(mys.fill[i]);
          write(mys.fill[21]);
          readkey;
        end;
      gotoxy(26,6);
    end;
  until ch<>'c';
end;

procedure f5(leftadress,rightadress:string);
var i,ukaz:integer;
s1,s2:string;
procedure f5copy(leftadress,rightadress:string);
var searchmas:array [1..100] of string[12];
    searchatt:array [1..100] of byte;
search:searchrec;
i,num:integer;
begin
  {$I-}
  chdir('C:\');
  chdir(leftadress);
  chdir(leftadress+'\.');
  {$I+}
  if IOResult<>0 then
    begin
      copyfile(leftadress,rightadress);
      exit;
    end;
  findfirst('*.*',$3F,search);
  findnext(search);
  num:=0;
  {$I-}
  while IOResult=0 do
    begin
      inc(num);
      findnext(search);
      if IOResult<>0 then break;
      searchmas[num]:=search.name;
      searchatt[num]:=search.attr;
      if searchmas[num]=searchmas[num-1] then break;
      if num=100 then
        begin
          textcolor(red);
          writeln('error : too many files');
          textcolor(green);
          break;
        end;
    end;
  dec(num);
  {$I+}
  for i:=1 to num do if (searchatt[i]-16<16)and(searchatt[i]<>0) then
                        begin
                                              f5copy(leftadress+'\'+searchmas[i],rightadress+'\'+searchmas[i]) end else
                                              copyfile(leftadress+'\'+searchmas[i],rightadress+'\'+searchmas[i]);
end;
procedure repair;
var i:integer;
s:string;
begin
  leftpanel:=rightpanel;
  for i:=1 to 100 do
      searchmas[i,1]:=searchmas[i,2];
  for i:=1 to 100 do
      pan[i,1]:=pan[i,2];
  s:=leftadress;
  leftadress:=rightadress;
  rightadress:=s;
end;
var l,r:string;
begin
  window(1,1,80,rezim);
  clrscr;
  l:=leftadress;
  r:=rightadress;
  if not panel then repair;
  for i:=1 to leftpanel do if pan[i,1] then
                             begin
                               if ioresult=ioresult then write;
                               f5copy(leftadress+'\'+searchmas[i,1].name,rightadress+'\'+searchmas[i,1].name);
                             end;
  if ioresult<>0 then ;
  close(output);
  close(input);
  assigncrt(output);
  rewrite(output);
  assigncrt(input);
  reset(input);
  for i:=1 to 100 do
    begin
      pan[i,1]:=false;
      pan[i,2]:=false;
    end;
  leftadress:=l;
  rightadress:=r;
  windows;
end;
procedure f7;
var i,q:integer;
s:string;
begin
  message;
  textcolor(red);
  writeLN('Please enter mame');
  gotoxy(5,4);
  writeln('of creating folder:');
  gotoxy(5,5);
  {ch:='1';
  for i:=1 to 12 do if ch=#8 then
                      begin
                        gotoxy(5,5+i-1);
                        write(' ');
                        gotoxy(5,5+i-1);
                      end else if ch<>#13 then
                         begin
                            if ch<>'1' then s:=s+ch;
                            read(ch);
                         end;}


  readln(s);
  {$I-}
  if panel then chdir(leftadress) else chdir(rightadress);
  mkdir(s);
  {$I+}
  q:=IOResult;
  if q=0 then
    begin
  textcolor(black);
  writeln('> Function: mkdir');
  writeln('> result:  OK');
  writeln('> IOResult = 0');
  if panel then writeln('> Panel: left panel') else
                writeln('> Panel: rigth panel');
  if panel then if length(leftadress)=3 then writeln('> Adress: ',leftadress+s+'\') else writeln('Adress: ',leftadress+'\'+s+
  '\') else
                if length(rightadress)=3 then writeln('> Adress: ',rightadress+s+'\') else writeln('Adress: ',rightadress+'\'
                +s+'\');

    end else
    begin
      writeln('> Function: mkdir');
      writeln('> result: failed');
      writeln('> IOResult = ',q);
      if panel then writeln('> Adress: ',leftadress) else
                    writeln('> Adress: ', rightadress);
      if panel then writeln('> panel: left panel') else
                    writeln('> panel: right panel');
      delete(s,12,length(s));
      write('Name of folder: ',s);
    end;
   readkey;
  windows;
end;
procedure decam(var s:string);
var i:integer;
begin
   for i:=length(s) downto 5 do   if (s[i]='.')and(s[i-1]='.') then break;
  if (s[i]='.')and(s[i-1]='.') then
    begin
      i:=i-2;
      delete(s,i,3);
      i:=i-1;
      while (s[i]<>'\') do
        begin
          delete(s,i,1);
          dec(i);
        end;
      delete(s,length(s),1);
      exit;
    end else
  if (s[i]='.')and(s[i-1]='\') then delete(s,i-1,2);

  if (s[4]='.')and(s[3]='.') then delete(s,3,2);
end;
procedure matrix;
var r:array[1..41,1..81]of char;
i:integer;
procedure wrt;
var i,j:integer;
begin
  gotoxy(1,1);
  for i:=1 to 25 do
  for j:=1 to 80 do {write(r[i,j]);}
    begin
      if r[i,j]<>' ' then
        begin
          gotoxy(j,i);
          write(r[i,j]);
          if i<>1 then
            begin
              gotoxy(j,i-1);
              write(' ');
            end;
        end;

    end;
  gotoxy(1,25);
  for i:=1 to 79 do write(' ');
  delay(10000);
end;
procedure sdvig;
var i,j:integer;
begin
  for i:=25 downto 2 do
  for j:=1 to 80 do r[i,j]:=r[i-1,j];
  for i:=1 to 80 do r[1,i]:=' ';
end;
begin
  window(1,1,80,43);
  window(1,1,80,25);
  fillchar(r,sizeof(r),' ');
  textcolor(green);
  clrscr;
  while not keypressed do
    begin
      sdvig;
      for i:=1 to 79 do if random(100)=0 then r[1,i]:=chr(random(10)+ord('0'));
      wrt;
    end;
end;
procedure graphic;
var s:string;
x,y,radius:integer;
grDriver : Integer;
 grMode : Integer;
ErrCode : Integer;
begin
  window(1,1,80,25);
  window(1,1,80,43);
  textbackground(black);
  textcoloR(white);
  clrscr;
  while true do
    begin
      {closegraph;}
      gotoxy(1,1);
      clreol;
      readln(s);
      {grDriver:=Detect;}
      if s='circle' then
        begin
          writeln('x y radius                    ');
          read(x,y,radius);
          write('                ');
          {InitGraph(grDriver, grMode, 'C:\BP\BGI');}
          {circle(x,y,radius);}
        end else
      if s='exit' then exit;
    end;
end;
procedure UpCaseString(var s:string);
var i:integer;
begin
  for i:=1 to length(s) do s[i]:=upcase(s[i]);
end;
procedure erase;
var q:string;
i:integer;
procedure era(const s:string);
var num:integer;
search:searchrec;
searchmas:array[1..100]of string[12];
searchatt:array[1..100]of byte;
i:integer;
byt:byte;
st:string;
begin
  if s='' then exit;
  if s='.' then exit;
  if s='..' then exit;
  {$I-}
    chdir(s);
    chdir(s+'\.');
  {$I+}
  getdir(byt,st);
  if ioresult=0 then ;
  {if copy(st,2,length(st))<copy(s,2,length(s)) then exit;}
  writeln('Current directoory is ',st);
  findfirst('*.*',$3F,search);
  findnext(search);
  num:=0;
  {$I-}
  while IOResult=0 do
    begin
      inc(num);
      findnext(search);
      if IOResult<>0 then break;
      searchmas[num]:=search.name;
      searchatt[num]:=search.attr;
      if searchmas[num]=searchmas[num-1] then break;
      if num=100 then
        begin
          textcolor(red);
          writeln('error : too many files');
          textcolor(green);
          break;
        end;
    end;
  dec(num);
  {$I+}
  for i:=1 to num do  if searchmas[i]='..' then continue else
  if (searchatt[i]-16<16)and(searchatt[i]<>0) then
                        begin
                                              era(s+'\'+searchmas[i]) end else
                                              erasefile(s+'\'+searchmas[i]);
  assigncrt(output);
  rewrite(output);
  writeln('Removing directory ',s);
  chdir('..');
  {$I-}
  swapvectors;
  exec(getenv('COMSPEC'),'/C rmdir '+s);
  swapvectors;
  {$I+}
  if ioresult=0 then ;
end;
begin
  window(1,1,80,25);
  window(1,1,80,43);
  clrscr;
  for i:=1 to 100 do
    if pan[i,1] then
    if (searchmas[i,1].attr-16<16)and(searchmas[i,1].attr<>0) then era(leftadress+'\'+searchmas[i,1].name) else
                                                  erasefile(leftadress+'\'+searchmas[i,1].name);
end;
function lg(b:longint):longint;
var a,i:longint;
begin
  a:=0;
  while b>0 do
    begin
      inc(a);
      b:=b div 2;
    end;
  lg:=a;
end;
function power(a,b:integer):extended;
var i:integer;
st:extended;
begin
  st:=a;
  for i:=1 to b+1 do st:=st/a;
  power:=st;
end;
function vir(s:string):extended;
type tlex=
              (
                 _Mul,
                 _Plus,
                 _End,
                 _Start,
                 _Div,
                 _Minus,
                 _Open,
                 _Num,
                 _Sqrt,
                 _Sqr,
                 _Close,
                 _log
              );
var
curlex,prlex:tlex;
i,posl:integer;
vl:extended;
err:boolean;
function expr:extended; forward;
function mult:extended; forward;
function item:extended; forward;
procedure error;
begin
  if err then exit else
                        err:=true;
  write('> Wrong: ')
end;
procedure nextlexem;
var l:boolean;
begin
  inc(i);
  prlex:=curlex;
  if s[i]='(' then curlex:=_Open else
  if s[i]=')' then curlex:=_Close else
  if s[i]='+' then curlex:=_Plus else
  if s[i]='*' then curlex:=_Mul else
  if s[i]='/' then curlex:=_Div else
  if s[i]='-' then curlex:=_Minus else
  if copy(s,i,4)='log(' then
    begin
      curlex:=_log;
      inc(i,3);
    end else
  if copy(s,i,4)='sqr(' then
    begin
      curlex:=_sqr;
      inc(i,3);
    end else
  if s[i]='.' then curlex:=_End else
  if (s[i]='s')and(s[i+1]='q')and(s[i+2]='r')and(s[i+3]='t')and(s[i+4]='(')then
    begin
      curlex:=_Sqrt;
      inc(i,4);
    end else
  if s[i] in ['0'..'9'] then
    begin
      curlex:=_Num;
      vl:=0;
      posl:=-255;
      l:=false;
      while (s[i] in ['0'..'9'])or(s[i]='.')or(s[i]=',') do
        begin
          if (s[i]='.')or(s[i]=',') then
            begin
              if i=length(s) then break;
              posl:=1;
              if l then break else l:=true;
              i:=i+1;
              continue;
            end;
          if l then vl:=vl+power(10,posl)*(ord(s[i])-ord('0')) else
          vl:=vl*10+ord(s[i])-ord('0');
          inc(i);
          inc(posl);
        end;
      dec(i);
    end else error;
end;
function expr:extended;
var a:extended;
begin
  a:=item;
  if (curlex=_Mul)or(curlex=_Div) then
    begin
      nextlexem;
      if prlex=_Mul then a:=a*mult else a:=a/mult;
    end;
  while (curlex=_Plus)or(curlex=_Minus) do
    begin
      nextlexem;
      if prlex=_Minus then a:=a-mult else a:=a+mult;
    end;
  expr:=a;
end;
function mult:extended;
var a:extended;
begin
  a:=item;
  while (curlex=_Mul)or(curlex=_Div) do
    begin
      nextlexem;
      if prlex=_Mul then a:=a*item else a:=a/item;
    end;
  mult:=a;
end;
function item:extended;
var a:extended;
begin
  case curlex of
    _Num:
      begin
        item:=vl;
        nextlexem;
        exit;
      end;
    _Sqrt:
      begin
        nextlexem;
        a:=expr;
          if a<0 then
             begin
               error;
               writeln('People as was as you made Windows Vista:');
               writeln('Invalid float operation');
             end else item:=sqrt(a);

        if curlex<>_Close then error else nextlexem;
        exit;
      end;
    _sqr:
      begin
        nextlexem;
        item:=sqr(expr);
        if curlex<>_close then error else nextlexem;
        exit;
      end;
    _log:
      begin
        nextlexem;
        item:=lg(round(expr))-1;
        if curlex<>_Close then error else nextlexem;
        exit;
      end;
    _Open:
      begin
        nextlexem;
        item:=expr;
        if curlex<>_Close then error else
        nextlexem;
        exit;
      end;
    _Minus:
      begin
        if (prlex<>_Open) and (prlex<>_Start) then error;
        nextlexem;
        item:=-item;
        exit;
      end;
  end;
  error;
end;
begin
  err:=false;
  s:=s+'.';
  curlex:=_Start;
  i:=0;
  nextlexem;
  vir:=expr;
end;
procedure crypt;
var s,z:string;
ch:char;
i:longint;
x:integer;
f:text;
rand:array[1..255]of longint;
begin
  writeln('> Procedure crypt started!');
  writeln('> Crypt:"Please enter a message to crypt":> ');
  readln(s);
  s:=s+#13;
  randomize;
  x:=random(30000);
  writeln('> Crypt:> ',x);
  randseed:=x;
  for i:=1 to length(s) do rand[i]:=random(50);
  for i:=1 to length(s) do
    begin
      write('> Crypt:> ');
      if ord(s[i])mod 3 =0 then writeln((ord(s[i])div 3+rand[i]+9)*257) else
      if ord(s[i])mod 2 =0 then writeln((ord(s[i])div 2+rand[i]+7)*263) else
                                writeln((ord(s[i])div 1+rand[i]+4)*277);
    end;
  writeln('Should I write it to file? y/n');
  ch:=readkey;
  if UpCase(ch)='Y' then
    begin
      writeln('> Crypt:"Please enter full name of file":>');
      readln(z);
      assign(f,z);
      rewrite(f);
      writeln(f,'Text crypted by newflmngr, version=',version:2:2);
      writeln(f,'Crypt:> ',x);
      randseed:=x;
      for i:=1 to length(s) do rand[i]:=random(50);
      for i:=1 to length(s) do
        begin
          append(f);
          write(f,'Crypt:> ');
          append(f);
          if ord(s[i])mod 3 =0 then writeln(f,(ord(s[i])div 3+rand[i]+9)*257) else
          if ord(s[i])mod 2 =0 then writeln(f,(ord(s[i])div 2+rand[i]+7)*263) else
                                    writeln(f,(ord(s[i])div 1+rand[i]+4)*277);
        end;
    end;
end;
procedure DECRYPT;
var f:text;
ch:char;
vl:longint;
s,sst:string;
qw:string[8];
x,n,i:integer;
qwe:longint;
l:boolean;
r:array [1..255]of longint;
rand:array[1..10000]of longint;
begin
  writeln('> Decrypter:"Decrypting  to  file or monitor?"f/m');
  ch:=readkey;
  if UpCase(ch)='F' then
    begin
      write('> Decrypter:".. to file":>');
      readln(sst);
      writeln('> Decrypter:"Decrypting from file or monitor?"f/m');
      l:=true;
    end;
  if UpCase(ch)<>'F' then writeln('> Decrypter:"Decrypting from file or monitor?"f/m');
  ch:=readkey;
  if UpCase(ch)='M' then
    begin
      write('> Decrypter :"Please enter N":>');
      readln(n);
      write('> Decrypter :"Please enter first number":>');
      readln(x);
      randseed:=x;
      for i:=1 to n do rand[i]:=random(50);
      for i:=1 to n do
        begin
          write('> Decrypter :"Please enter next number":>');
          readln(r[i]);
        end;
      for i:=1 to n do if (r[i])mod 257=0 then write(chr((r[i]div 257-9-rand[i])*3)) else
                       if (r[i])mod 263=0 then write(chr((r[i]div 263-7-rand[i])*2)) else
                                               write(chr((r[i]div 277-4-rand[i])*1));
    end else
    begin
      assigncrt(output);
      append(output);
      writeln('> Decrypter:"Please enter name of encrypted file" :>');
      readln(s);
      assign(f,s);
      reset(f);
      assign(output,sst);
      rewrite(output);
      readln(f,sst);
      writeln(sst);
      read(f,qw);
      readln(f,x);
      randseed:=x;
      for i:=1 to 10000 do rand[i]:=random(50);
      i:=1;
      while true do
        begin
          read(f,qw);
          {$I-}
          readln(f,qwe);
          {$I+}
          if IOResult<>0 then
            begin
              writeln('Unknown crypting program...');
              readkey;
              exit;
            end;
          if eof(f) then break;
                       if (qwe)mod 257=0 then write(chr((qwe div 257-9-rand[i])*3)) else
                       if (qwe)mod 263=0 then write(chr((qwe div 263-7-rand[i])*2)) else
                                              write(chr((qwe div 277-4-rand[i])*1));
          inc(i);
        end;
    end;
  assigncrt(output);
  append(output);
end;
procedure realmatrix;
type int=record
           x:byte;
           y:byte;
           v:byte;
           c:string[3];
           w:byte;
         end;
var i,j,count,ran:integer;
z:longint;
x:array[1..100]of int;
procedure prov;
var i:integer;
procedure sdvig(const qwerty:integer);
var i:integer;
begin
  dec(count);
  for i:=qwerty to count do x[i]:=x[i+1];
end;
begin
  for i:=1 to count do
    if (x[i].x=81)or(x[i].x=0)or(x[i].y=0)or(x[i].y=25) then sdvig(i);
end;
procedure clear;
var i:integer;
begin
  for i:=1 to count do
    begin
      gotoxy(x[i].x,x[i].y);
      write('  ');
    end;
end;
procedure gennext;
const dx:array[1..4]of integer=(0,0,1,-1);
      dy:array[1..4]of integer=(1,-1,0,0);
var i,k:integer;
begin
  for i:=1 to count do
    begin
      if x[i].v=0 then writeln('Very important error') else
      if z mod x[i].v<>0 then continue;
      dec(x[i].x,dx[x[i].w]);
      dec(x[i].y,dy[x[i].w]);
    end;
end;
procedure wrt;
var i:integer;
begin
  for i:=1 to count do
    begin
      gotoxy(x[i].x,x[i].y);
      write(x[i].c);
    end;
end;
var stcount,stv:integer;
h1,h2,m1,m2,s1,s2,s11,s12:word;
ch:char;
label l;
begin
  gettime(h1,m1,s1,s11);
  m1:=m1+h1*60;
  s1:=s1+m1*60;
  s11:=s1*100+s11;
  s12:=s11;
  while not keypressed and (s12-s11<200) do
    begin
      gettime(h2,m2,s2,s12);
      m2:=m2+h2*60;
      s2:=s2+m2*60;
      s12:=s2*100+s12;
    end;
  stcount:=20;
  stv:=4;
  if s12-s11>=100  then goto l;
  write('SaintMatrix "Please enter standart count[20]"> ');
  readln(stcount);
  write('SaintMatrix "Please enter standart V[5]"> ');
  readln(stv);
  l:
  if safely_mode='off' then textmode(co80);
  clrscr;
  textcolor(green);
  count:=0;
  z:=0;
  while {not keypressed}true do
    begin
      delay(1000);
      clear;
      inc(z);
      if count<stcount then ran:=random(5) else ran:=0;
      for i:=1 to ran do
        begin
          inc(count);
          x[count].x:=random(80)+1;
          x[count].y:=random(24)+1;
          x[count].v:=random(stv)+1;
          x[count].w:=random(4)+1;
          x[count].c:=chr(random(10)+ord('0'))+chr(random(10)+ord('0'));
          {if (x[count].w=1)or(x[count].w=2) then x[count].v:=x[count].v*2;}
        end;

      while keypressed do
        begin
          ch:=readkey;
          if ch='q' then exit;
          inc(count);
          x[count].x:=random(80)+1;
          x[count].y:=random(24)+1;
          x[count].v:=random(stv)+1;
          x[count].w:=random(4)+1;
          x[count].c:=ch;
        end;
      gennext;
      prov;
      wrt;
      if matrix_is_searching_you='on' then
    begin
      if z=5 then
        begin
          message;
          writeln('> Now MATRIX');
          writeln('    >is searching');
          writeln('    >YOU');
          for i:=1 to 10 do delay(10000);
          window(1,1,80,43);
          textcolor(green);
          textbackground(black);
        end else
      if z=1000 then
        begin
          message;
          writeln('> I');
          writeln('    >find');
          writeln('    >YOU');
          for i:=1 to 13 do delay(10000);
          window(1,1,80,43);
          textcolor(green);
          textbackground(black);
        end else
      if z=2000 then
        begin
          message;
          writeln('> Now I');
          writeln('    >look on');
          writeln('    >YOU');
          for i:=1 to 17 do delay(10000);
          window(1,1,80,43);
          textcolor(green);
          textbackground(black);
        end else
      if z=3000 then
        begin
          message;
          writeln('> Now ...');
          writeln('    >IP filtering ...');
          writeln('    >MAC sort');
          writeln('    >I know your IP and MAC');
          writeln('    >I know where you live');
          write('    >Trying to disconnect remote user');
          for i:=1 to 50 do delay(10000);
          window(1,1,80,43);
          textcolor(green);
          textbackground(black);
        end else
      if z=5000 then
        begin
          message;
          writeln('> Now ...');
          writeln('    >ERROR  #404 ...');
          writeln('    >Gateway not found ...');
          writeln('    >Where are YOU');
          write('    >I can''t disconnect you ');
          for i:=1 to 50 do delay(10000);
          window(1,1,80,43);
          textcolor(green);
          textbackground(black);
        end;
    end;
    end;
end;
procedure hren;
begin
  if safely_mode='off' then textmode(co80);
  randseed:=246;
  while not keypressed do
    begin
      gotoxy(random(80)+1,random(24)+1);
      textbackground(random(16));
      textcolor(random(30));
      write(random(250));
      delay(010);
    end;
  textbackground(black);
  textcolor(green);
end;
procedure command_string;
var q:string;
x,y,i,w:integer;
label l1,l2,l3,l4;
begin
  window(1,1,80,25);
  window(1,1,80,43);
  clrscr;
  repeat
    begin
  write('> please enter DOS command:');
  readln(q);
  if (q='default_iddqd')or(q='default')or(q='~') then
    begin
      l4:;
      clrscr;
      window(5,3,75,20);
      window(5,3,75,36);
      textcolor(magenta);
      write('          $$$  ');
      textcolor(green);
      write('Specially cmdline... ');
      textcolor(magenta);
      writeln('   $$$');
      textcolor(green);
      window(5,5,75,20);
      window(5,5,75,20);
      while q<>'BREAK' do
        begin
          if wherex<>1 then writeln;
          write('> Please enter a command: > ');
          y:=wherey;
          x:=wherex;
          readln(q);
          UpCaseString(q);
          if q='MODE' then
            begin
              textcolor(red+16);
              writeln('> Changing mode is dangerous...');
              textcolor(magenta);
              writeln('> BW40 <-> code 00 <-> 40x25 for colors adapters!!black/white!!');
              writeln('> CO40 <-> code 01 <-> 40x25 for colors adapters               ');
              writeln('> BW80 <-> code 02 <-> 80x25 for colors adapters!!black/white!!');
              writeln('> CO80 <-> code 03 <-> 80x25 for colors adapters!!standart!!   ');
              writeln('> MONO <-> code 07 <-> 80x25 for black/white adapters          ');
              readln(x);
              if safely_mode='off' then textmode(x);
            end else
          if q='RESTART' then
            begin
              writeln('Now the newflmngr is shutting down ...');
              delay(50000);delay(50000);delay(50000);delay(50000);
              delline;
              writeln('Starting newflmngr.exe');
              delay(50000);delay(50000);delay(50000);delay(50000);
              delline;
              writeln('Newflmngr.exe started');
              delay(50000);delay(50000);delay(50000);delay(50000);
              goto l1;
            end else
          if q='RANDOM' then
            begin
              window(1,1,80,25);
              window(1,1,80,43);
              textbackground(black);
              clrscr;
              l2:;
              write(chr(random(255)));
              if not keypressed then goto l2;
              readkey;
            end else
          if q='CALC' then
            begin
              l3:;
              writeln;
              write('Newflmngr''s calculator is starting:...:');
              delay(50000);delay(50000);delay(50000);delay(50000);
              delline;
              gotoxy(1,wherey);
              write('Newflmngr''s calculator started successful!!!');
              delay(50000);delay(50000);delay(50000);delay(50000);
              delline;
              gotoxy(1,wherey);
              write('> Calculator:"Enter an expresssion" :> ');
              readln(s);
              if s='exit' then continue;
              writeln('$Result = ',vir(s):6:6);
              goto l3;
            end else
          if q='EXIT' then
            begin
              windows;
              exit;
            end else
          if q='HALT' then halt else
          if q='HELP' then
            begin
              textcolor(lightgray);
              writeln('   Crypt          ---  to crypt some message                  ');
              writeln('   Decrypt        ---  to decrypt some message or text        ');
              writeln('   Mode           ---  to change write mode 80/43   80/25...  ');
              writeln('   Restart        ---  to restart file manager and kill bugs  ');
              writeln('   Revelation     ---  to view emulation of emulation of virus');
              writeln('   Matrix         ---  to view MATRIX                         ');
              writeln('   SaintMatrix    ---  to view saint MATRIX                   ');
              writeln('   Hren           ---  to view hren                           ');
              writeln('   Random         ---  to write random packs of symbols       ');
              writeln('   Calc           ---  to run newflmngr''s calculator         ');
              writeln('   Break          ---  to go out from My command line         ');
              writeln('   Exit           ---  to go out from    command line         ');
              writeln('   Halt           ---  to exit from my newflmngr',chr(1),chr(2),chr(3));
              writeln('   Help           ---  to view this help...                   ');
              writeln('   Please press any key to continue ...');readkey;
              textcolor(green);
            end else
          if q='MATRIX' then
            begin
              matrix;
              goto l4;
            end else
          if q='SAINTMATRIX' then
            begin
              realmatrix;
              goto l4;
            end else
          if q='HREN' then
            begin
              hren;
              goto l4;
            end else
          if q='REVELATION' then
            begin
              randseed:=666;
              windows;
              line;
              wrt;
              date;
              w:=0;
              while true
              do begin
              i:=0;
              inc(w);
              if w=2 then break;
              while true do
                begin
                  inc(i);
                  x:=random(80)+1;
                  y:=random(25)+1;
                  if (x=80)and(y=25) then continue;
                  gotoxy(x,y);
                  x:=random({255}2)+ord('0');
                  if (x=7)or(x=13) then continue;
                  write(chr(x));
                  delay(1000);
                  if i=4000 then break;
                end;
              i:=0;
              while true do
                begin
                  gotoxy(random(80),random(25));
                  write('Revelation -- hack attack');
                  delay(1000);
                  inc(i);
                  if i=100 then break;
                end;           end;
              clrscr;
              write('Deliting ''boot.ini'' ..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              write('Deliting system ..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              write('Format All disk : format c: ..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              delay(50000);delay(50000);delay(50000);
              write('Hacking BIOS  ..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              write('Killing BIOS  ..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              delay(50000);delay(50000);delay(50000);delay(50000);delay(50000);delay(50000);
              writeln('Are you a doomer? y/n');
              ch:=readkey;
              if UpCase(ch)='Y' then
              clrscr else
                begin
                  textcolor(red);
                  writeln('I can''t create anything!!!');
                  textcolor(green);
                  writeln('Press reset to view changes');
                  while true do delay(1);
                end;
              writeln('You are a doomer!!!');
              writeln('I did''nt know it....');
              write('Creating BIOS profile..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              write('Creating subsystem..');
              delay(50000);delay(50000);delay(50000);
              writeln('Successful');
              write('Creating database..');
              delay(50000);delay(50000);delay(50000);
              textcolor(red);
              writeln('Failed');
              textcolor(green);
              writeln('Create NEWFLMNGR.EXE ... successful');
              write('Please press reset to continue...');
              while true do delay(1);
            end else
            if q='CRYPT' then crypt else
            if q='DECRYPT' then decrypt else
            begin
              if y=16 then gotoxy(x+length(q)+1,y-1)
                else gotoxy(x+length(q)+1,y);
              write('... Unknown');
            end;
        end;
    end;
  swapvectors;
  exec(getenv('comspec'),'/C'+q);
  swapvectors;
    end;
  until q='';
  windows;
  wrt;
  exit;
  l1:;
  Restart:=true;
end;
begin
  l4:;
  restart:=false;
  adrr:=addr(adrr);
  if stsafely_mode='off' then textmode(co80);
{---------------------------CRT-----------------------------------}
  CheckSnow:=stCheckSnow;
  DirectVideo:=stDirectVideo;
{--------------------------colors---------------------------------}
  black:=stblack;
  folder:=stfolder;
  videl:=stvidel;
  green:=stgreen;
  brown:=stbrown;
  cyan:=stcyan;
  blue:=stblue;
  red:=stred;
  magenta:=stmagenta;
  gray:=stgray;
  orange:=storange;
{-------------------------1234567890------------------------------}
  rezim:=strezim;
  start:=ststart;
  longline:=stlongline;
  longword:=stlongword;
  dela:=stdela;
{-----------------------on/off------------------------------------}
  clre:=stclre;
  clrs:=stclrs;
  miganie:=stmiganie;
  glyuk:=stglyuk;
  bug:=stbug;
  cursor_place:=stcursor_place;
  safely_mode:=stsafely_mode;
  matrix_is_searching_you:=stmatrix_is_searching_you;
{---------------------------------begin---------------------------}
  clrscr;
  GetDir(0, bgiadress);
  {windows;   }
  textcolor(black);
  gotoxy(80,25);
  gotoxy(80,43);
  write(' ');
  windows;
  textcolor(green);
  leftpanel:=1;
  rightpanel:=1;
  leftline:=1;
  rightline:=1;
  leftstart:=0;
  rightstart:=0;
  panel:=true;
  lk:=false;
  leftadress:='C:';
  rightadress:='C:';
  getdir(0,leftadress);
  getdir(0,rightadress);
  if length(leftadress)=3 then delete(leftadress,3,1);
  if length(rightadress)=3 then delete(rightadress,3,1);
  while true do
    begin
      textbackground(black);
      {CLRSCR; }
      l3:;
      fillchar(searchmas,sizeof(searchmas),0);
      decam(leftadress);
      decam(rightadress);
      poisk(1,leftadress);
      poisk(2,rightadress);
      leftstart:=1;
      rightstart:=1;
      l1:;
      repeat
        begin
          {window(1,1,80,25);
          window(1,1,80,43);
          gotoxy(80,25);}
          textbackground(black);
          wrt;
          line;
          if miganie='on' then textcolor(white);
          ch:='^';
          while (ch<>'|')and(ch<>'`')and(ch<>'W')and
                (ch<>'A')and(ch<>'S')and(ch<>'D')and
                (ch<>' ')and(ch<>#01)and(ch<>#13)and
                (ch<>#10)and(ch<>#27)and(ch<>#9) and
                not ((ch>#200)and(ch<=#240)) do
            begin
              while not keypressed do date;
              ch:=readkey;
              if ch='@' then goto l4;
              pch:=ch;
              ch:=UpCase(ch);
            end;
          ch:=pch;
          if ch=#232 then
            begin
              if panel then dec(leftline,rezim-1) else
                            dec(rightline,rezim-1);
              prov;
              goto l3;
            end else
          if ch=#233 then
            begin
              if panel then inc(leftline, rezim-1) else
                            inc(rightline, rezim-1);
              prov;
              goto l3;
            end else
          if ch=#234 then
            begin
              help;
              windows;
              goto l3;
            end else
          if ch=#235 then
            begin
              erase;
              windows;
              goto l3;
            end else
          if ch=#236 then
            begin
              panel:=false;
              disk;
              goto l3;
            end else
          if ch=#237 then
            begin
              panel:=true;
              disk;
              goto l3;
            end else
          if ch=#238 then
            begin
              wrt;
              f10;
            end else
          if ch=#239 then
            begin
              f5(leftadress,rightadress);
              erase;
              windows;
              goto l3;
            end else
          if ch=#240 then
            begin
              f5(leftadress,rightadress);
              windows;
              goto l3;
            end else
          if ch='`' then
            begin
              func:=1;
              {windows;
              line;}
              window(2,2,79,21);
              window(2,2,79,39);
              clrscr;
              line;
              l2:;
              textcolor(lightgreen);
              window(2,2,80,25);
              window(2,2,80,43);
              gotoxy(1,1);
              {if func=1 then textbackground(cyan) else textbackground(black);
              writeln('exit');
              if func=2 then textbackground(cyan) else textbackground(black);
              writeln('copy file or folder');
              if func=3 then textbackground(cyan) else textbackground(black);
              writeln('change disk');
              if func=4 then textbackground(cyan) else textbackground(black);
              writeln('create folder');
              if func=5 then textbackground(cyan) else textbackground(black);
              writeln('execute');
              if func=6 then textbackground(cyan) else textbackground(black);
              writeln('disk data');
              if func=7 then textbackground(cyan) else textbackground(black);
              writeln('command string');
              if func=8 then textbackground(cyan) else textbackground(black);
              writeln('erase directory');
              if func=9 then textbackground(cyan) else textbackground(black);
              writeln('parametri');
              if func=10 then textbackground(cyan) else textbackground(black);
              writeln('graph');         }
              for i:=1 to QuantityFunc do
                begin
                  if i=func then
                    begin
                      textbackground(cyan);
                      textcolor(videl);
                    end else
                    begin
                      textbackground(black);
                      textcolor(green);
                    end;
                  writeln(functions[i]);
                end;
              textbackground(black);
              if miganie='on' then textcolor(white);
              while not keypressed do date;
              ch:=readkey;
              if ch=#13 then
                begin
              wrt;
              if func=1 then f10 else
              if func=2 then f5(leftadress,rightadress) else
              if func=3 then disk;
              if func=4 then f7 else
              if func=5 then com_str(false,'') else
              if func=6 then data else
              if func=7 then
                begin
                  command_string;
                  if restart then goto l4;
                end else
              if func=8 then erase else
              if func=9 then
                begin
                  f5(leftadress,rightadress);
                  erase;
                end else
              if func=10 then parametr else
              if func=11 then graphic else
              if func=12 then colour else
              if func=13 then options else
              if func=14 then help;
                windows;
                goto l3;
                end else
                begin

              if Upcase(ch)='W' then dec(func) else
              if UpCase(ch)='S' then inc(func)else
              if ch=#27 then continue;
              if func=0 then inc(func);
              if func=QuantityFunc+1 then dec(func);
              goto l2;
                end;
              ch:='`';
            end else
          if (ord(ch)=87)or(ord(ch)=83) then
          if panel then
             pan[leftline,1]:=not pan[leftline,1] else
             pan[rightline,2]:=not pan[rightline,2] else
          if ord(ch)=1 then
            begin
              parametr;
              windows;
              wrt;
              ch:='+';
            end else
          if ch='|' then
            begin
              windows;
              for ch:=chr(1) to chr(255) do write(ch);
              readkey;
              wrt;
            end else
          if ord(ch)=27 then
            begin
              gettime(hour,minute,sec,sec100);
              timetime:=sec100+sec*100+minute*10000+hour*1000000;
              while not keypressed do date;
              ch:=readkey;
              if ch=#27 then
                begin
                  gettime(hour,minute,sec,sec100);
                  if sec100+sec*100+minute*10000+hour*1000000-timetime<=TimeToHelp then
                    begin
              help;
              windows;
                    end;
                end;
            end else
          if ch=' ' then
            begin
              message;
              leftname:=searchmas[leftline,1 ].name;
              rightname:=searchmas[rightline,2].name;
              writeln('> Are you sure ');
              writeln('> To rename: ');
              if panel then writeln(leftname,'<LEFTPANEL>') else
                            writeln(rightname,'<RIGHTPANEL>');
              while (upcase(ch)<>'Y')and(upcase(ch)<>'N') do ch:=readkey;
              if upcase(ch)='Y' then
                begin
                  write('> To:');
                  readln(s);
                  {$I-}
                  swapvectors;
  {if panel then
    begin
      assign(input,leftadress+'\'+leftname);
      {rename(input, s); }{
      assign(input,'');
      reset(input);
      exec(getenv('comspec'),'/C'+leftadress+'\'+leftname+' '+s)
    end else
    begin
      assign(input,rightadress+'\'+rightname);
      {rename(input, s);}{
      assign(input,'');
      reset(input);
  exec(getenv('comspec'),'/C'+rightadress+'\'+rightname+' '+s);
    end;                              }
  swapvectors;
  assign(input,'');
  reset(input);
  if glyuk='on' then
    begin
      assign(output,'');
      rewrite(output);
    end else
    begin
      assigncrt(output);
      rewrite(output);
    end;
  message;


                  writeln('> Function: rename');
  if doserror=0 then writeln('> result:  OK') else writeln('> result: FAILED');
  writeln('> doserror = ',doserror);
  if panel then writeln('> Panel: left panel') else
                writeln('> Panel: rigth panel');
  if panel then if length(leftadress)=3 then writeln('> Adress: ',leftadress+s+'\') else writeln('Adress: ',leftadress+'\'+s+
  '\') else
                if length(rightadress)=3 then writeln('> Adress: ',rightadress+s+'\') else writeln('Adress: ',rightadress+'\'
                +s+'\');

                  {$I+}
                  goto l3;
                  readkey;
                end;
            end;
          if ord(ch)=9 then panel:=not panel else
          if UpCase(ch)='A' then panel:=true else
          if UpCase(ch)='D' then panel:=false else
          if UpCase(ch)='W' then
          if panel then dec(leftline) else dec(rightline) else
          if UpCase(ch)='S' then
          if panel then inc(leftline) else inc(rightline);

          prov;
        end;
      until ch=#13;
   {   if panel then if searmas[leftline,1].attr<>$10 then}
      {$I-}
      if (lk=false)and(((panel)and(length(leftadress)>=60)and(searchmas[leftline,1].name<>'..'))
      or((not panel)and(searchmas[rightline,2].name<>'..')and(length(rightadress)>=60))) then
        begin
          message;
          textcolor(red);
          writeln('Error: very big adress');
          write('Panel: ');
          if panel then writeln('LEFTPANEL') else writeln('RIGHTPANEL');
          write('     Continue?');
          while (upcase(ch)<>'Y')and(upcase(ch)<>'N')and(upcase(ch)<>'~') do ch:=readkey;
          if upcase(ch)='N' then
          continue else
          if ch='~' then
            begin
              message;
              writeln('Please write code:');
              readln(s);
              if s='iddqd' then lk:=true;
             end;
        end;
      if (panel) then
        begin
            chdir(leftadress+'\'+searchmas[leftline,1].name);
            if IOResult<>0 then
              begin
                chdir(leftadress+searchmas[leftline,1].name);
                if IOResult<>0 then
                  begin
                    window(1,1,80,25);
                    window(1,1,80,43);
                    textbackground(black);
                    clrscr;
                    swapvectors;
                    if ras(leftadress+'\'+searchmas[leftline,1].name)<>'' then
                    exec(ras(leftadress+'\'+searchmas[leftline,1].name),
                    leftadress+'\'+searchmas[leftline,1].name) else
                    exec(leftadress+'\'+searchmas[leftline,1].name,'');
                    swapvectors;
                    if doserror=0 then readkey;
                    {com_str(true,leftadress+'\'+searchmas[leftline,1].7name);
                    }
                    if safely_mode='off' then if rezim=25 then textmode(co80)else textmode(co80+font8x8);
                    windows;
                    wrt;
                    goto l1;
                  end;
                leftadress:=leftadress+searchmas[leftline,1].name
              end else
            leftadress:=leftadress+'\'+searchmas[leftline,1].name
        end else
        begin
            chdir(rightadress+'\'+searchmas[rightline,2].name);
            if IOResult<>0 then
              begin
                chdir(rightadress+searchmas[rightline,2].name);
                if IOResult<>0 then
                  begin
                    window(1,1,80,25);
                    window(1,1,80,43);
                    textbackground(black);
                    clrscr;
                    swapvectors;
                    if ras(rightadress+'\'+searchmas[rightline,2].name)<>'' then
                    exec(ras(rightadress+'\'+searchmas[rightline,2].name),
                    rightadress+'\'+searchmas[rightline,2].name) else
                    exec(rightadress+'\'+searchmas[rightline,2].name,'');
                    swapvectors;
                    if safely_mode='off' then if rezim=25 then textmode(co80)else textmode(co80+font8x8);
                    if doserror=0 then readkey;
                    windows;
                    wrt;
                    {com_str(true,rightadress+'\'+searchmas[rightline,1].name);
                    }goto l1;
                  end;rightadress:=rightadress+searchmas[rightline,2].name;
              end else
            rightadress:=rightadress+'\'+searchmas[rightline,2].name
        end;
      {$I+}
    end;
end.
