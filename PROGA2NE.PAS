Uses CRT,DOS;
const
  dx:array[1..8]of integer=(-1,-1,-1,0,0,1,1,1);
  dy:array[1..8]of integer=(-1,0,1,-1,1,-1,0,1);
  n=30;
  stuser='expert'; {expert or novice or user}
  Standart_Cursor='@';
  show_computer_cursor=true;
  Nashi='X';
  Computer='O';
  minNashi='x';
  MinComputer='o';
  Up='A';
  Down='D';
  Left='W';
  Right='S';
  code='iddqd';
  Exit_Char='@';
var
  Field:array[-10..n+10,-10..n+10]of char;
  tabl:array[-10..n+10,-10..n+10]of longint;
  ulovn,ulovc:array[-10..n+10,-10..n+10,1..3]of byte;
  tabl_backup:array[-10..n+10,-10..n+10]of longint;
  ulovn_backup,ulovc_backup:array[-10..n+10,-10..n+10,2..3]of byte;
  history:array[0..100,1..2]of integer;
  StartX,StartY:integer;
  Cur_X,Cur_Y:integer;
  Comp_X,Comp_Y:integer;
  x,y:integer;
  count:integer;
  s,user:string;
  Who_Won:string;
  root:boolean;
  ds:boolean;
label l1;
procedure analyze; forward;
function can_5(i,j,number:integer;ch:char):byte; forward;

procedure Activate_Field_1;
begin
  window(1,1,80,1);
  textcolor(green);
  clrscr;
  write('Your current window is left, you can use "w" "a" "s" "d" to move and [enter]');
  window(1,3,39,25);
end;
procedure Activate_Field_2;
begin
  window(1,1,80,1);
  textcolor(green);
  clrscr;
  write('Your current window is right, please enter command (or "help" for help)');
  window(41,3,80,25);
  gotoxy(x,y);
end;
procedure null;
var i,j:integer;
begin
  for i:=1 to n do
  for j:=1 to n do field[i,j]:='.';
end;
procedure backup;
var i,j:integer;
begin
  for i:=0 to n+1 do
  for j:=0 to n+1 do tabl_backup[i,j]:=tabl[i,j];
end;
procedure unbackup;
var i,j:integer;
begin
  for i:=0 to n+1 do
  for j:=0 to n+1 do tabl[i,j]:=tabl_backup[i,j];
end;
procedure Prov;
begin
  if Cur_X=0 then inc(Cur_X);
  if Cur_Y=0 then inc(Cur_Y);
  if Cur_X=N+1 then dec(Cur_X);
  if Cur_Y=N+1 then dec(Cur_Y);
  if Cur_X=StartX then dec(StartX);
  if Cur_Y=StartY then dec(StartY);
  if Cur_X=StartX+20 then inc(StartX);
  if Cur_Y=StartY+18 then inc(StartY);
end;
function min(const i,j:integer):integer;
begin
  if i<j then min:=i else min:=j;
end;
procedure Write_Field(const l:boolean);
var i,j:integer;
Current_Char:char;
begin
  gotoxy(1,1);
  for i:=min(StartX,N-19) to min(StartX+20,N+1) do
  for j:=min(StartY,N-17) to min(StartY+18,N+1) do
    begin
      textcolor(green);
      Current_Char:=UpCase(Field[i,j]);
      if Field[i,j]='X' then textcolor(Red) else
      if Field[i,j]='O' then textcolor(Yellow);
      if (Field[i,j]='x')or(Field[i,j]='o') then
          textcolor(magenta+16);
      if show_computer_cursor then if l then if (i=Comp_x) and (j=Comp_y) then textcolor(blue);
      if l then if (i=Cur_X) and (j=Cur_Y) then
        begin
          textcolor(magenta);
          if Field[i,j]='.' then Current_Char:=Standart_Cursor;
        end;
      {if (i=0)or(i=n+1) then
        begin
          write(#205);
          write(Current_Char);
        end else }
      if current_char=#205 then write(#205,#205) else
      write(Current_Char,' ');
      if j=StartY+18 then writeln;
    end;
end;
procedure date;
var hour,minute,second,sec100:word;
begin
  gotoxy(1,22);
  gettime(hour,minute,second,sec100);
  write(hour,':',minute div 10,minute mod 10,':',second div 10,second mod 10,'.',sec100 div 10,sec100 mod 10);
end;
function won:boolean;
var i,j,c,qwerty,z:integer;
begin
  won:=false;
  for i:=1 to n do
  for j:=1 to n do
  for c:=1 to 8 do
  for qwerty:=0 to 5 do
    if qwerty=5 then
      begin
        won:=true;
        if field[i,j]=nashi then Who_Won:='I' else
                                 Who_Won:='computer';
        for z:=0 to 4 do if UpCase(field[i,j])=nashi then field[i+dx[c]*z,j+dy[c]*z]:=MinNashi else
                                                          field[i+dx[c]*z,j+dy[c]*z]:=MinComputer;
        exit;
      end else
    if field[i,j]='.' then break else
    if (field[i+dx[c]*qwerty,j+dy[c]*qwerty]<>field[i,j])or(field[i,j]=minnashi)or(field[i,j]=mincomputer) then break;
end;
procedure Evrystika(ch:char);
var i,j,c,z:integer;
k:longint;
begin
  if user='novice' then exit;
  if ch=nashi then k:=2000 else k:=3000;
  for i:=1 to n do
  for j:=1 to n do
  for c:=1 to 4 do if (field[i,j]=ch)and(field[i+dx[c]*3,j+dy[c]*3]=ch)and(can_5(i,j,c,ch)<2) then
                   if (field[i+dx[c]*2,j+dy[c]*2]=ch)or(field[i+dx[c],j+dy[c]]=ch) then
                     begin
                       inc(tabl[i+dx[c]*2,j+dy[c]*2],k);
                       inc(tabl[i+dx[c],j+dy[c]],k);
                       if ch=nashi then inc(ulovn[i+dx[c],j+dy[c],3]) else inc(ulovc[i+dx[c],j+dy[c],3]);
                       if ch=nashi then inc(ulovn[i+dx[c]*2,j+dy[c]*2,3]) else inc(ulovc[i+dx[c]*2,j+dy[c]*2,3]);
                     end;
  for i:=1 to n do
  for j:=1 to n do
  for c:=1 to 8 do if (field[i,j]=ch)and(field[i+dx[c]*4,j+dy[c]*4]=ch)and(can_5(i,j,c,ch)<>3) then
                   if ((field[i+dx[c]*2,j+dy[c]*2]=ch)and(field[i+dx[c],j+dy[c]]=ch))or
                      ((field[i+dx[c]*3,j+dy[c]*3]=ch)and(field[i+dx[c],j+dy[c]]=ch))or
                      ((field[i+dx[c]*2,j+dy[c]*2]=ch)and(field[i+dx[c]*3,j+dy[c]*3]=ch))
                                      then
                     begin
                       if can_5(i,j,c,ch)<2 then k:=100000 else
                                                 k:=30;
                       if ch=computer then k:=k*10;
                       for z:=1 to 3 do inc(tabl[i+dx[c]*z,j+dy[c]*z],k);
                       for z:=1 to 3 do if ch=nashi then
                                          begin
                                            inc(ulovn[i+dx[z],j+dy[z],2]);
                                            inc(ulovn[i+dx[z],j+dy[z],3]);
                                          end else
                                          begin
                                            inc(ulovc[i+dx[z],j+dy[z],2]);
                                            inc(ulovc[i+dx[z],j+dy[z],3]);
                                          end;
                     end;

  if ch=nashi then k:=20 else k:=50;
  for i:=1 to n do
  for j:=1 to n do
  for c:=1 to 4 do if (field[i,j]=ch)and(field[i+dx[c]*2,j+dy[c]*2]=ch)and(can_5(i,j,c,ch)<>3) then
                          begin
                            if ch=nashi then inc(ulovn[i+dx[c],j+dy[c],2]) else
                                             inc(ulovc[i+dx[c],j+dy[c],2]);
                            inc(tabl[i,j],K); end;

  if not ds then
  if user='expert' then
  for i:=1 to n do
  for j:=1 to n do
   begin
      if (field[i,j]<>'.')or(tabl[i,j]=0) then continue;
        field[i,j]:=Computer;
        ds:=true;
        backup;
        analyze;
        for c:=1 to n do
        for z:=1 to n do if (tabl[c,z]>=300){and(tabl[c,z]<2000)}{and(abs(i-c)<7)and(abs(j-z)<7)} then inc(tabl[i,j],500);
        unbackup;
        field[i,j]:='.';

        field[i,j]:=Nashi;
        backup;
        analyze;
        for c:=1 to n do
        for z:=1 to n do if (tabl[c,z]>=300){and(tabl[c,z]<2000)}{and(abs(i-c)<7)and(abs(c-z)<7)} then inc(tabl[i,j],250);
        ds:=false;
        unbackup;
        field[i,j]:='.'
   end;
  for i:=1 to n do
  for j:=1 to n do
    if (ulovn[i,j,2]>1)and(tabl[i,j]<2000) then
                         tabl[i,j]:=300*ulovn[i,j,3]+ulovn[i,j,2]*150 else
    if (ulovc[i,j,2]>1)and(tabl[i,j]<2000) then
                         tabl[i,j]:=400*ulovc[i,j,3]+ulovc[i,j,2]*250;

  for i:=1 to n do
  for j:=1 to n do if field[i,j]<>'.' then tabl[i,j]:=0;

end;
function can_5(i,j,number:integer;ch:char):byte;
var count,result:integer;
begin
 result:=0;
 while (field[i,j]='.')or(field[i,j]=ch) do begin inc(i,dx[number]); inc(j,dy[number]); end;
 if field[i-dx[number],j-dy[number]]<>'.' then inc(result);
 count:=1;
 dec(i,dx[number]);dec(j,dy[number]);
 while (field[i,j]='.')or(field[i,j]=ch) do begin dec(i,dx[number]); dec(j,dy[number]); inc(count);end;
 if field[i+dx[number],j+dy[number]]<>'.' then inc(result);
 if count<5 then result:=3;
 can_5:=result;
end;
procedure rec(const number,i,j:integer;k:integer;const ch:char);
var im:longint;
ds:boolean;
label l1;
begin
  im:=0;
  ds:=false;
  if (field[i,j]='.') then
    begin
      l1:
      if ch=nashi then
        begin
          if k=1 then
            begin
              im:=2;
              inc(tabl[i+dx[number],j+dy[number]],1);
            end;
          if (k=2)and((can_5(i,j,number,ch)=0)or ds)and(field[i+dx[number],j+dy[number]]='.') then
            begin
              im:=20;
              inc(tabl[i+dx[number],j+dy[number]],10);
              if field[i+dx[number],j+dy[number]]='.' then inc(ulovn[i,j,2]);
            end;
          if (k=3)and(can_5(i,j,number,ch)=0)and(field[i+dx[number],j+dy[number]]='.') then
            begin
              im:=2000;
              inc(ulovn[i,j,3]);
            end else if (k=3)and(not ds) then begin ds:=true;dec(k);goto l1; end;
          if k=4 then
           im:=100000;
        end else
        begin
          if k=1 then
            begin
              im:=3;
              inc(tabl[i+dx[number],j+dy[number]],2);
            end;
          if (k=2)and((can_5(i,j,number,ch)=0)or ds)and(field[i+dx[number],j+dy[number]]='.') then
            begin
              im:=50;
              inc(tabl[i+dx[number],j+dy[number]],10);
              if field[i+dx[number],j+dy[number]]='.' then inc(ulovc[i,j,2]);
            end;
          if (k=3)and(can_5(i,j,number,ch)=0)and(field[i+dx[number],j+dy[number]]='.') then
            begin
              im:=3000;
              inc(ulovc[i,j,3]);
            end else if (k=3)and(not ds) then begin ds:=true;dec(k);goto l1; end;
          if k=4 then
            im:=1000000;
        end;
      inc(tabl[i,j],im);
      exit;
    end;
  if field[i,j]<>ch then exit;
  rec(number,i+dx[number],j+dy[number],k+1,ch);
end;
procedure analyze;
var i,j,i1:integer;
begin
  for i:=1 to n do
  for j:=1 to n do begin tabl[i,j]:=0; ulovc[i,j,2]:=0; ulovc[i,j,3]:=0;
                                       ulovn[i,j,2]:=0; ulovn[i,j,3]:=0; end;

  for i:=1 to n do
  for j:=1 to n do
  for i1:=1 to 8 do
      if field[i,j]=nashi then rec(i1,i,j,0,nashi) else
      if field[i,j]=computer then rec(i1,i,j,0,computer);
  Evrystika(nashi);
  Evrystika(computer);
end;
procedure Choose_Max;
var i,j,count:integer;
mas_of_choosing:array[1..1000,1..2]of integer;
begin
  Comp_X:=1;
  Comp_Y:=1;
  count:=0;
  for i:=1 to n do
  for j:=1 to n do if field[i,j]='.' then
  if tabl[i,j]>tabl[Comp_X,Comp_Y] then
                     begin
                       count:=1;
                       mas_of_choosing[1,1]:=i;
                       mas_of_choosing[1,2]:=j;
                       Comp_X:=i;
                       Comp_Y:=j;
                     end else
                   if tabl[i,j]=tabl[Comp_X,Comp_Y] then
                     begin
                       inc(count);
                       mas_of_choosing[count,1]:=i;
                       mas_of_choosing[count,2]:=j;
                     end;
  count:=random(count)+1;
  Comp_X:=mas_of_choosing[count,1];
  Comp_Y:=mas_of_choosing[count,2];
end;
procedure Start_Play(const Who_Start:integer);
var ch:char;
label l1;
begin
  Activate_Field_1;
  clrscr; comp_x:=-1; comp_y:=-1;
  if not root then null;
  history[1,1]:=-1;
  history[1,2]:=-1;
  count:=Who_Start;
  if Who_Start=2 then begin comp_x:=n div 2;comp_y:=comp_x; goto l1; end;
  while not won do
    begin
      ch:=' ';
      while ch<>#13 do
        begin
          Write_Field(true);
          while not keypressed do date;
          ch:=readkey;
          if ch=#0 then
            begin
              ch:=readkey;
              if ch=#72 then ch:=Left else
              if ch=#75 then ch:=Up else
              if ch=#77 then ch:=Down else
              if ch=#80 then ch:=Right;
            end else
          if ch=#32 then ch:=#13;
          ch:=UpCase(ch);
          if ch=Exit_Char then
            begin
              Activate_Field_2;
              exit;
            end;
          if (ch=Up)or(ch=Down)or(ch=Left)or(ch=Right) then
            begin
              if ch=Up then dec(Cur_y) else
              if ch=Down then inc(Cur_y) else
              if ch=Left then dec(Cur_x) else
              if ch=Right then inc(Cur_x);
              prov;
            end;
          if root and (ch=#13) then break;
          if (ch=#13) and (Field[Cur_X,Cur_Y]<>'.') then ch:=' ';
        end;
      Field[Cur_X,Cur_Y]:=Nashi;
      history[count,1]:=Cur_X;
      history[count,2]:=Cur_Y;
      inc(count);
      if won then break;
      Analyze;
      Choose_Max;
      l1:
      Field[Comp_X,Comp_Y]:=Computer;
      history[count,1]:=Comp_X;
      history[count,2]:=Comp_Y;
      inc(count);
    end;
  Write_Field(false);
  Activate_Field_2;
  textcolor(magenta);
  if Who_Won='I' then
    begin
      writeln('You won...');
      if root then writeln('But you are cheater') else writeln('But it was random');
    end else
    begin
      writeln('I won...    ...Because I''m AI..');
    end;
  textcolor(green);
  dec(count);
end;
procedure UnKnown;
begin
  writeln(' Unknown command "',s,'"');
  writeln(' Please enter "help" for help');
end;
procedure Start_Help;
begin
  writeln('Possible commands are: ');
  writeln('  > About');
  writeln('  > Expire');
  writeln('  > Play');
  writeln('  > Play 2');
  writeln('  > Exit');
  writeln('  > Restart');
  writeln('  > History');
  writeln('  > Help');
end;
procedure INIT;
var i,j:integer;
begin
  textmode(co80);
  window(1,1,80,25);
  textcolor(8);
  randomize;
  for i:=1 to N do
  for j:=1 to N do Field[i,j]:='.';
  for i:=1 to n do
    begin
      field[0,i]:=#205;
      field[n+1,i]:=#205;
    end;
  for i:=1 to n do
    begin
      field[i,0]:=#186;
      field[i,n+1]:=#186;
    end;
  field[0,0]:=#201;
  field[n+1,0]:=#200;
  field[0,n+1]:=#187;
  field[n+1,n+1]:=#188;
  clrscr;
  user:='expert';
  gotoxy(1,2);
  for i:=1 to 80 do write(#205);
  gotoxy(40,2); write(#203);
  for i:=3 to 25 do
    begin
      gotoxy(40,i);
      write(#186);
    end;
  Activate_Field_2;
  Cur_X:=n div 2;
  Cur_Y:=n div 2;
  StartX:=n div 2 -10;
  StartY:=n div 2 -10;
  ds:=false;
end;
procedure expert;
var i,j:integer;
ch:char;
fin,fout : text;
begin
  assign(fin,'game.txt');
  assign(fout,'game.txt');
  reset(fin);
  writeln('Reading data');
  for i:=1 to n do
      begin
           for j:=1 to n do
               read(fin,field[i,j]);
           readln(fin);
      end;
  writeln('Starting analyze...');
  analyze;
  writeln('Choosing maximum');
  Choose_Max;
  Field[Comp_X,Comp_Y]:=Computer;
  close(fin);
  rewrite(fout);
  for i:=1 to n do
  for j:=1 to n do
    begin
      write(fout,field[i,j]);
      if j=n then writeln(fout);
    end;
  close(fout);
  halt(0);
end;
procedure Check_root;
var s:string; ch:char;
begin
  root:=false;
  writeln('password: '); s:=''; ch:=' ';
  while ch<>#13 do
    begin
      ch:=readkey;
      s:=s+ch;
    end;
  if copy(s,1,length(s)-1)=code then root:=true else writeln('  login incorrect');
end;
function UpCaseString(s:string):string;
var i:integer;
begin
  for i:=1 to length(s) do s[i]:=UpCase(s[i]);
  UpCaseString:=s;
end;
procedure expire;
var a:integer;
begin
  writeln('Expert(1) User(2) Novice(3)');
  read(a);
  if a=1 then user:='expert' else if a=2 then user:='user' else user:='novice';
end;
procedure StartViewHistory;
var current:char;
i:integer;
begin
  null;
  Activate_Field_1;
  for i:=1 to count do
    begin
      if i mod 2=1 then current:=Nashi else current:=Computer;
      field[history[i,1],history[i,2]]:=current;
      won;
      Write_Field(false);
      readkey;
    end;
  Activate_Field_2;
end;
procedure Start_About;
begin
  writeln('Program created by Tyulbashev 06.10');
  Start_Help;
end;
begin
  l1: INIT;
  Start_Help;
  if paramcount>=1 then expert;
  while true do
    begin
      write('> ');
      readln(s);
      s:=UpCaseString(s);
      x:=WhereX;
      y:=WhereY;
      if s='ABOUT' then Start_About else
      if s='EXPIRE' then expire else
      if s='PLAY' then Start_Play(1) else
      if s='PLAY 2' then Start_Play(2) else
      if s='HELP' then Start_Help else
      if s='HISTORY' then StartViewHistory else
      if s='RESTART' then goto l1 else
      if s='ROOT' then Check_root else
      if s='EXIT' then exit else UnKnown;
    end;
end.