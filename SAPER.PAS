uses crt,dos;
const n=20;
      m=20;
      k=70;
dx:array[1..8]of shortint=(-1,-1,-1,0,0,1,1,1);
dy:array[1..8]of shortint=(-1,0,1,-1,1,-1,0,1);
var r:array[0..n+1,0..m+1]of char;
   us:array[0..n+1,0..m+1]of byte;
  boo:array[0..n+1,0..m+1]of boolean;
 mine:array[0..n+1,0..m+1]of boolean;
 tabl:array[0..n+1,0..n+1]of integer;
 cursX,cursY:byte;
 ch:char;
procedure genmas;
var x,y,i:integer;
begin
  for i:=1 to k do
    begin
      x:=random(m)+1;
      y:=random(n)+1;
      r[y,x]:='*';
    end;
end;
procedure genuse;
var i,j,z:integer;
begin
  for i:=1 to n do
  for j:=1 to m do
  for z:=1 to 8 do
    begin
      if r[i+dy[z],j+dx[z]]='*' then inc(us[i,j]);
      if us[i,j]>8 then
        z:=0;
    end;
end;
procedure init;
var i,j:integer;
begin
  randomize;
  clrscr;
  for i:=0 to n+1 do
  for j:=0 to m+1 do
    begin
      r[i,j]:='.';
      us[i,j]:=0;
      boo[i,j]:=false;
      mine[i,j]:=false;
    end;
  cursX:=m div 2+m mod 2;cursY:=n div 2+n mod 2;
end;
function readkeys:char;
var ch:char;
begin
  ch:=readkey;
  if ch=#0 then
    begin
      ch:=readkey;
      if ch=#80 then ch:='S' else
      if ch=#77 then ch:='D' else
      if ch=#75 then ch:='A' else
      if ch=#72 then ch:='W';
    end;
    ch:=UpCase(ch);
  readkeys:=ch;
end;
procedure reads(var ch:char);
begin
  while (ch<>'W')and(ch<>'S')and(ch<>'A')and(ch<>'D')
  and(ch<>'*')and(ch<>#13)and(ch<>'@')and(ch<>' ')and(ch<>'H') do ch:=readkeys;
end;
procedure prov;
begin
  if cursy=0 then inc(cursy) else
  if cursy=N+1 then dec(cursy) else
  if cursx=0 then inc(cursx) else
  if cursx=M+1 then dec(cursx);
end;
procedure wrt;
var i,j:integer;
begin
  for i:=1 to n do
  for j:=1 to m do
    begin
      textcolor(green);
      if mine[i,j] then textcolor(magenta);
      if boo[i,j] then textcolor(us[i,j]);
      if (i=cursY)and(j=CursX) then textcolor(11);

      if mine[i,j] then write('* ') else
      if boo[i,j] then
      if us[i,j]=9 then write('  ') else write(us[i,j],' ') else write('. ');

      if j=m then writeln;
    end;
end;
procedure bo(const i,j:integer);
var k:integer;
begin
  if (i=0)or(j=0)or(i=n+1)or(j=m+1)or(boo[i,j]) then exit;
  boo[i,j]:=true;
  if us[i,j]=0 then
    for k:=1 to 8 do bo(i+dy[k],j+dx[k]);
end;
function won:boolean;
var i,j:integer;
begin
  gotoxy(1,1);
  won:=true;
  for i:=1 to n do
  for j:=1 to m do if not((boo[i,j])or((mine[i,j])and(r[i,j]='*'))) then won:=false;
end;
procedure help;
var i,j,k,im,jm:integer;
begin
  for i:=1 to n do
  for j:=1 to m do tabl[i,j]:=0;

  for i:=1 to n do
  for j:=1 to m do
  for k:=1 to 8 do if (boo[j+dy[k],i+dx[k]])and(not boo[j,i])and(not mine[j,i])and(us[i,j]<>0)and(r[j,i]='*') then
  inc(tabl[i,j],10-us[i+dy[k],j+dx[k]]);
  im:=1;
  jm:=1;
  for i:=1 to n do
  for j:=1 to m do if (tabl[i,j]>tabl[im,jm])and(not boo[j,i]) then
                      begin
                        im:=i;
                        jm:=j;
                      end;
  ch:=' ';
  cursX:=im;
  cursy:=jm;
end;
procedure play;
begin
  while not won do
    begin
      prov;
      wrt;
      ch:='`';
      reads(ch);
      if ch='W' then dec(cursY) else
      if ch='S' then inc(cursY) else
      if ch='A' then dec(cursX) else
      if ch='D' then inc(cursX) else
      if ch='@' then exit else
      if ch='H' then help else
      if (ch='*')or(ch=' ') then mine[cursy,cursx]:=not mine[cursy,cursx] else
        begin
          if r[cursy,cursx]='*' then begin write('You find a mine');readkey;halt;end;
          bo(cursy,cursx);
        end;
    end;
  writeln('You find all of the mines!!!');
  writeln('Great you!!');
  readkey;
  readkey;
  exit;
end;
begin
  init;
  genmas;
  genuse;
  play;
end.