program Project1;

Uses CRT;
type point=record x,y:integer; end;
const n=10;
      chitcode=false;

      kol_1=4;
      kol_2=3;
      kol_3=2;
      kol_4=1;

      nizya=5;
      ubit=6;
      ranen=7;

      dx:array[0..8]of shortint=(0,-1,1,0,0,-1,1,1,-1);
      dy:array[0..8]of shortint=(0,0,0,-1,1,-1,1,-1,1);

      left=1;
      right=2;
      up=3;
      down=4;

var r1,r2:array[-6..n+6,-6..n+6]of integer;
    b1,b2:array[-6..n+6,-6..n+6]of boolean;
    x:array[1..n*n]of point;
    seterror:integer;
    curs,comp:point;
    count:integer;

procedure wrt(a,k:integer); forward;


function won:boolean;
var i,j:integer;
result:boolean;
begin
  result:=true;
  for i:=1 to n do
  for j:=1 to n do if (r2[i,j]<>0)and(r2[i,j]<>5)and(not b1[i,j]) then result:=false;
  if not result then
    begin
      result:=true;
  for i:=1 to n do
  for j:=1 to n do if (r1[i,j]<>0)and(r1[i,j]<>5)and(not b2[i,j]) then result:=false;
    end;
  won:=result;
end;
procedure reads(var ch:char);
label l1;
begin
  l1:
  ch:='1';
  ch:=readkey;
  if ch=#0 then ch:=readkey;
  if ch=#72 then ch:='w';
  if ch=#75 then ch:='a';
  if ch=#77 then ch:='d';
  if ch=#80 then ch:='s';
  if ch='w' then ch:='W';
  if ch='s' then ch:='S';
  if ch='a' then ch:='A';
  if ch='d' then ch:='D';
  if (ch<>'W')and(ch<>'S')and(ch<>'A')and(ch<>'D')and(ch<>#13)and(ch<>#32)and(ch<>'@') then goto l1;
end;
function can(i,j,k,a:integer):boolean;
var z:integer;
begin
  can:=true;
  for z:=0 to a-1 do if r1[i+dy[k]*z,j+dx[k]*z]<>0 then can:=false;
end;
function ranens(k,i,j:integer):boolean;
var
a,b,count:integer;
begin
  count:=0;
  if k=2 then
    begin
      for a:=i-r2[i,j]+1 to i+r2[i,j]-1 do
      for b:=j-r2[i,j]+1 to j+r2[i,j]-1 do if (r2[i,j]=r2[a,b])and(b1[a,b]) then inc(count);
    end else
  if k=1 then
    begin
      for a:=i-r1[i,j]+1 to i+r1[i,j]-1 do
      for b:=j-r1[i,j]+1 to j+r1[i,j]-1 do if (r1[i,j]=r1[a,b])and(b2[a,b]) then inc(count);
    end;
  if count>=r2[i,j] then ranens:=false else ranens:=true;
end;
procedure wrt_symbol(i,j,k:integer);
begin
  if k=1 then
    begin
      textcolor(r1[i,j]+1);
      if (b2[i,j])and((r1[i,j]=5)or(r1[i,j]=0)) then
        begin
          textcolor(red);
          write('%');
        end else
      if (r1[i,j]=5)or(r1[i,j]=0) then
        begin
          textcolor(8);
          write('.');
        end else
      if (r1[i,j]<>5)and(r1[i,j]<>0)and(b2[i,j]) then
        begin
          textcolor(yellow);
          write(#219);
        end else write(#219);
    end else
    begin
      if (i=curs.y)and(j=curs.x) then
        begin
          textcolor(yellow);
          write('@');
          exit;
        end;
      if chitcode=true then textcolor(r2[i,j]+1) else textcolor(8);
      if b1[i,j] then
        begin
          textcolor(magenta);
          if (r2[i,j]=0)or(r2[i,j]=5) then write('O')
                                                      else
        begin
          if ranens(2,i,j) then textcolor(blue) else
                               textcolor(red);
          write('X');
        end end else write('$');

{      if (r2[i,j]=5)or(r2[i,j]=0) then
        begin
          textcolor(8);
          write('.');
        end else write(#219);}
    end;
end;
procedure wrt_game;
var i,j:integer;
begin
  gotoxy(1,1);
  for i:=1 to n do
    begin
      for j:=1 to n do wrt_symbol(i,j,1);
      for j:=1 to 10 do write(' ');
      for j:=1 to n do wrt_symbol(i,j,2);
      writeln;
    end;
  textcolor(green);
end;
procedure analyze;
var i,j,k:integer;
b:boolean;
begin
  count:=0;
  comp.x:=n div 2+n mod 2;
  comp.y:=n div 2+n mod 2;

  for i:=1 to n do
  for j:=1 to n do
  for k:=1 to 4 do if not b2[i,j] then
                    if (b2[i+dy[k],j+dx[k]])and(b2[i+dy[k]*2,j+dx[k]*2]) then
                    if (r1[i+dy[k],j+dx[k]]<>0)and(r1[i+dy[k],j+dx[k]]<>5) then
                    if (r1[i+dy[k]*2,j+dx[k]*2]<>0)and(r1[i+dy[k]*2,j+dx[k]*2]<>5) then
                      begin
                        comp.x:=j;
                        comp.y:=i;
                        exit;
                      end;


  for i:=1 to n do
  for j:=1 to n do
  for k:=1 to 4 do if not b2[i,j] then
                   if (b2[i+dy[k],j+dx[k]])and(r1[i+dy[k],j+dx[k]]<>0)and(r1[i+dy[k],j+dx[k]]<>5) then
                     begin
                       inc(count);
                       x[count].x:=j;
                       x[count].y:=i;
                     end;
 if count=0 then
   begin
     repeat
       comp.y:=random(n)+1;
       comp.x:=random(n)+1;
       inc(count);
       if count>=10000 then
         begin
           writeln('Very important error');
           exit;
         end;
       b:=true;
       for i:=1 to 4 do if (r1[comp.y+dy[i],comp.x+dx[i]]<>0)and(b2[comp.y+dy[i],comp.x+dx[i]])
                   and(r1[comp.y+dy[i],comp.x+dx[i]]<>5) then b:=false
     until (not b2[comp.y,comp.x])and b;
     exit;
   end;
 count:=random(count)+1;
 comp.x:=x[count].x;
 comp.y:=x[count].y;
end;
procedure prov;
begin
 if curs.y=n+1 then dec(curs.y);
 if curs.y=0 then inc(curs.y);
 if curs.x=n+1 then dec(curs.x);
 if curs.x=0 then inc(curs.x);
end;
procedure play;
var ch:char;
i,j,k:integer;
label l1,l2;
begin
  l1:
  while not won do
    begin
      wrt_game;
      reads(ch);
      case ch of
        '@':exit;
        'W':dec(curs.y);
        'S':inc(curs.y);
        'A':dec(curs.x);
        'D':inc(curs.x);
        #13:
                if b1[curs.y,curs.x] then goto l1 else
                  begin
                    b1[curs.y,curs.x]:=true;
                    for i:=1 to 8 do if (r2[curs.y+dy[i],curs.x+dx[i]]<>0)and(r2[curs.y+dy[i],curs.x+dx[i]]<>5) then
                      if ranens(2,curs.y+dy[i],curs.x+dx[i])=false then goto l1;
                    if (r2[curs.y,curs.x]<>0)and(r2[curs.y,curs.x]<>5) then goto l1;
                  end;
      end;
      prov;
      wrt_game;
      if ch<>#13 then continue;
      l2:
      analyze;
      b2[comp.y,comp.x]:=true;
      if ranens(1,comp.y,comp.x)=false then
        begin
          for i:=1 to n do
          for j:=1 to n do
          for k:=1 to 8 do if b2[i,j] and (r1[i,j]<>0)and(r1[i,j]<>5) then b2[i+dy[k],j+dx[k]]:=true;
        end;
      if (r1[comp.y,comp.x]<>0)and(r1[comp.y,comp.x]<>5) then goto l2;
      wrt_game;
    end;
end;
procedure init;
var i,j:integer;
begin
  fillchar(r1,sizeof(r1),2);
  fillchar(r2,sizeof(r2),2);
  for i:=1 to n do
  for j:=1 to n do
    begin
      r1[i,j]:=0;
      r2[i,j]:=0;
      b1[i,j]:=false;
      b2[i,j]:=false;
    end;
  seterror:=0;
  curs.x:=n div 2;
  curs.y:=n div 2;
  randomize;
end;
procedure setstay(i,j,k,a:integer);
var z,y,x:integer;
begin

  for z:=1 to a do
    begin
      r1[i,j]:=a;
      for y:=0 to 4 do
      for x:=0 to 4 do if y<>x then if r1[i+dy[y]+dy[x],j+dx[y]+dx[x]]=0 then r1[i+dy[y]+dy[x],j+dx[y]+dx[x]]:=nizya;
      i:=i+dy[k];
      j:=j+dx[k];
    end;
end;
procedure genuser;
procedure set_(const a:integer);
var k:integer;
ch:char;
label l1,l2;
begin
  gotoxy(1,1);
  k:=1;
  l1: wrt(a,k);
  ch:='!';
  while not((ch=#13)and(can(curs.y,curs.x,k,a))) do
    begin
      l2:
      reads(ch);
      case ch of
        '@':exit;
        'W':dec(curs.y);
        'S':inc(curs.y);
        'A':dec(curs.x);
        'D':inc(curs.x);
        #13:
          begin
            if (k=1) then
              begin
                if can(curs.y,curs.x,k,a) then setstay(curs.y,curs.x,k,a) else goto l2;
              end else
              begin
                if a=4 then if can(curs.y-3,curs.x,k,a) then setstay(curs.y-3,curs.x,k,a) else goto l2 else
                if a=3 then if can(curs.y-2,curs.x,k,a) then setstay(curs.y-2,curs.x,k,a) else goto l2 else
                if a=2 then if can(curs.y-1,curs.x,k,a) then setstay(curs.y-1,curs.x,k,a) else goto l2 else
              end;
            break;
          end;
        #32:if a<>1 then if k=1 then k:=4 else k:=1;
      end;
      wrt(a,k);
    end;
  wrt(a,k)
end;
var i:integer;
begin
  for i:=1 to kol_4 do set_(4);
  for i:=1 to kol_3 do set_(3);
  for i:=1 to kol_2 do set_(2);
  for i:=1 to kol_1 do set_(1);
end;
procedure gen;
procedure set_(const a:integer);
var i,j,k:integer;
begin
  if seterror>=1000 then exit;
  for i:=1 to n do
  for j:=1 to n do
  for k:=1 to 4 do
    if can(i,j,k,a)  then
    if random(100)=7 then
      begin
        setstay(i,j,k,a);
        exit;
      end;
  inc(seterror);
  set_(a);
end;

var i:integer;
begin
  for i:=1 to kol_4 do set_(4);
  for i:=1 to kol_3 do set_(3);
  for i:=1 to kol_2 do set_(2);
  for i:=1 to kol_1 do set_(1);
  if seterror>=1000 then
    begin
      init;
      gen;
    end;
end;
procedure wrt(a,k:integer);
var i,j:integer;
begin
  if k=4 then dec(a);
  clrscr;
  for i:=1 to n do
  for j:=1 to n do
    begin
      if (j>=curs.x+(a-1)*dx[k])and(j<=curs.x)and(i>=curs.y-a*dy[k])and(i<=curs.y) then
        begin
          textcolor(magenta);
          write('@ ');
        end else
        begin
          textcolor(r1[i,j]+1);
          write(r1[i,j],' ');
        end;
      if j=n then writeln;
    end;
end;
procedure swap(var a,b:integer);
var c:integer;
begin
  c:=a;
  a:=b;
  b:=c;
end;
procedure swaparrays;
var i,j:integer;
begin
  for i:=1 to n do
  for j:=1 to n do swap(r1[i,j],r2[i,j]);
end;
begin
  r1:=r2;
  textmode(CO40);
  init;
  gen;
  wrt(1,0);
  writeln('Computer field was generated');
  swaparrays;
  genuser;
  textcolor(green);
  writeln('User field was generated');
  writeln('Game will start now...');
  while keypressed do readkey;
  clrscr;
  wrt_game;
  play;
  textcolor(magenta);
  writeln('GAME OVER');
  readkey;
end.
