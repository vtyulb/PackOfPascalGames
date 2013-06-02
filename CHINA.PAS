uses crt;
type point=record x,y:integer end;
const n=15;
poin=2;
dx:array[1..4]of shortint=(-1,0,1,0);
dy:array[1..4]of shortint=(0,1,0,-1);
var
field:record
       user:array[0..n+1,0..n+1]of byte;
       comp:array[0..n+1,0..n+1]of boolean;
      end;
prioritet:array[0..n+1,0..n+1]of integer;
temp:array[1..n*n]of point;
wall:array[0..n*2+1,0..n*2+1]of boolean;
tmp:array[0..n+1,0..n+1]of integer;
cursor:point;
count:integer;
WallCount:integer;
up,left,right,down:boolean;
procedure init;
var i,j:integer;
begin
  randomize;
  textmode(co80+font8x8);
  clrscr;
  for i:=0 to n+1 do
  for j:=0 to n+1 do
    begin
      field.user[i,j]:=0;
      field.comp[i,j]:=false;
      tmp[i,j]:=0;
      prioritet[i,j]:=0;
    end;
  field.comp[n div 2,n div 2]:=true;
  count:=1;
  cursor.x:=n+1;
  cursor.y:=n+1;
  wallcount:=0;
end;
function max(const a,b:integer):integer;
begin
  if a<b then max:=b else max:=a;
end;
function out(const i,j:integer):boolean;
begin
out:=false;
                   if field.comp[i+dx[1],j+dy[1]] then
                   if field.comp[i+dx[2],j+dy[2]] then
                   if field.comp[i+dx[3],j+dy[3]] then
                   if field.comp[i+dx[4],j+dy[4]] then field.comp[i,j]:=true; out:=true;

end;
procedure rasshirenie;
var i,j,k,z:integer;
begin
  for k:=1 to poin*10 do begin
  for i:=3 to n-1 do
  for j:=3 to n-1 do
    if field.comp[i,j]=true then
    if count<poin then
        for z:=1 to 4 do
          begin
            inc(count);
            {field.comp[i+dx[z],j+dy[z]]:=true;}
            prioritet[i+dx[z],j+dy[z]]:=prioritet[i,j]+1;
            temp[count].x:=i+dx[z];
            temp[count].y:=j+dy[z];
          end else
      for z:=1 to 4 do if (random(20-prioritet[i,j])=1) then
        begin
          field.comp[i+dx[z],j+dy[z]]:=true;
          prioritet[i+dx[z],j+dy[z]]:=prioritet[i,j]+1;;
          INC(count);
          field.comp[i+dx[z],j+dy[z]]:=true;
          if not out(i+dx[z],j+dy[z]) then
            begin
              temp[count].x:=i+dx[z];
              temp[count].y:=j+dy[z];
            end;
        end;

      for i:=1 to count do field.comp[temp[i].x,temp[i].y]:=true; end;

  for i:=1 to n do
  for j:=1 to n do if field.comp[i,j]=false then
                   if field.comp[i+dx[1],j+dy[1]] then
                   if field.comp[i+dx[2],j+dy[2]] then
                   if field.comp[i+dx[3],j+dy[3]] then
                   if field.comp[i+dx[4],j+dy[4]] then field.comp[i+dx[1],j+dy[1]]:=false;
end;
procedure genuser;
var i,j,z:integer;
begin
  for i:=1 to n do
  for j:=1 to n do
  for z:=1 to 4 do if field.comp[i,j] then if field.comp[i+dx[z],j+dy[z]]=false then inc(field.user[i,j]);

  for i:=1 to n do
  for j:=1 to n do if field.user[i,j]=4 then field.user[i,j]:=0;

  for i:=1 to n do
  for j:=1 to n do if field.user[i,j]<>0 then if random(8)=0 then field.user[i,j]:=0;
end;
procedure wrt;
var i,j,z:integer;
begin
  clrscr;
  for i:=1 to n do
  for j:=1 to n do
    begin
      if field.user[i,j]=0 then
        begin
          textcolor(green);
          if (i=(cursor.x+1)/2)and(j=(cursor.y+1)/2) then textcolor(magenta) else
                                                            textcolor(8);

          write('.');
        end else
        begin
          textcolor(red);
          if (i=(cursor.x+1)/2)and(j=(cursor.y+1)/2) then textcolor(lightred);
          write(field.user[i,j]);
        end;

          if (i=(cursor.x+1)/2)and(j=cursor.y/2) then textcolor(magenta) else
                                                            textcolor(8);
          if wall[i*2-1,j*2] then
            begin
              if (i=(cursor.x+1)/2)and(j=cursor.y/2) then textcolor(6) else
              textcolor(blue);
              write(chr(186));
            end else
          write(chr(179));

      if j=n then
        begin
          writeln;
          for z:=1 to n do
            begin
             if (i=cursor.x/2)and(z=(cursor.y+1)/2)
             then textcolor(magenta) else textcolor(8);
          if wall[i*2,z*2-1] then
            begin
              if (i=cursor.x/2)and(z=(cursor.y+1)/2) then textcolor(6) else
              textcolor(blue);
              write(chr(205));
            end else write(#196);

             if (wall[i*2+dx[1],z*2+dy[1]]) then up:=true else up:=false;
             if (wall[i*2+dx[2],z*2+dy[2]]) then right:=true else right:=false;
             if (wall[i*2+dx[3],z*2+dy[3]]) then down:=true else down:=false;
             if (wall[i*2+dx[4],z*2+dy[4]]) then left:=true else left:=false;

             if (i=cursor.x/2)and(z=cursor.y/2) then textcolor(lightred) else
             textcolor(green);
             if (up)and(down)and(left)and(right) then write(#206) else
             if (not up)and(not down)and(not right)and(not left) then write(#197) else

             if (not up)and(not down)and(left)and(right) then write(#216) else
             if (up)and(down)and(not left)and(not right) then write(#215) else

             if (up)and(left)and(down)and(not right) then write(#185) else
             if (up)and(down)and(right)and(not left) then write(#204) else
             if (up)and(right)and(left)and(not down) then write(#202) else
             if (down)and(right)and(left)and(not up) then write(#203) else

             if (down)and(left) then write(#187) else
             if (down)and(right) then write(#201) else
             if (up)and(left) then write(#188) else
             if (up)and(right) then write(#200) else

             if (down) then write(#210) else
             if (up) then write(#208) else
             if (left) then write(#181) else
             if (right) then write(#198) else
             write('error');
            end;
          writeln;
        end;
    end;
  {writeln;
  for i:=1 to n do
  for j:=1 to n do
    begin
      if field.comp[i,j] then textcolor(red) else textcolor(green);
      if field.comp[i,j] then write('1 ') else write('0 ');
      {if field.user[i,j]=0 then textcolor(green) else textcolor(red);
      write(field.user[i,j],' ');}
   {   if j=n then writeln;
    end;}
end;
function readk:char;
var ch:char;
begin
  ch:=readkey;
  if ch=#0 then
    begin
      ch:=readkey;
      if ch=#72 then ch:='W' else
      if ch=#75 then ch:='A' else
      if ch=#77 then ch:='D' else
      if ch=#80 then ch:='S';
    end;
  ch:=UpCase(ch);
  READK:=CH;
end;
function readkey:char;
begin
  readkey:=readk;
end;
procedure genusr;
var i,j:integer;
begin
  for i:=1 to n do for j:=1 to n do tmp[i,j]:=0;

  for i:=1 to n do
  for j:=1 to n do
    begin
      if (wall[i*2+dx[1]-1,j*2+dy[1]-1]) then inc(tmp[i,j]);
      if (wall[i*2+dx[2]-1,j*2+dy[2]-1]) then inc(tmp[i,j]);
      if (wall[i*2+dx[3]-1,j*2+dy[3]-1]) then inc(tmp[i,j]);
      if (wall[i*2+dx[4]-1,j*2+dy[4]-1]) then inc(tmp[i,j]);
    end;
end;
function won:boolean;
var i,j:integer;
begin
  won:=true;
  genusr;
  for i:=1 to n do
  for j:=1 to n do if field.user[i,j]<>0 then if tmp[i,j]<>field.user[i,j] then won:=false;
end;
procedure play;
var ch:char;
begin
  wrt;
  while not won do
    begin
      CH:='`';
      while (ch<>'W')and(ch<>'S')and(ch<>'A')and(ch<>'D')
        and(ch<>#13)and(ch<>'@')and(ch<>#32)
       do ch:=readkey;
      if ch='@' then halt else
      if ch='W' then dec(cursor.x) else
      if ch='S' then inc(cursor.x) else
      if ch='A' then dec(cursor.y) else
      if ch='D' then inc(cursor.y) else
      if (ch=#13)or(ch=#32) then
        begin
          inc(wallcount);
          wall[cursor.x,cursor.y]:=not wall[cursor.x,cursor.y];
        end;
      wrt;
    end;
  cursor.x:=0;
  cursor.y:=0;
  wrt;
  writeln('You find the China wall!!!');
  write('Great you!!');
  readkey;
end;
begin
  init;
  rasshirenie;
  genuser;
  play;
end.