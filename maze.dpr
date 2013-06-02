program Project4;

{$APPTYPE CONSOLE}

uses
  SysUtils,Math;
type point=record x,y:integer end;
     TGamer=record point:point;p,g:integer;klad,typeofklad:boolean;live:boolean end;
const n=6;
numberofgamers=2;
numberofdirs=2;
numberofforest=3;
lengthofriver=0;
cycleswall=n*4;
farcount=5;  //Дальность выстрела
dx:array[1..4]of integer=(0,0,1,-1);
dy:array[1..4]of integer=(1,-1,0,0);
{---------------------------------------}
{---------------Объекты-----------------}
{---------------------------------------}
   arsenal='@';                                 //   ----|
   hospital='H';                                //       |
   klad='I';                                    //   ----|
   lklad='L';                                   //
   dira='D';
   forest='F';
{---------------------------------------}
{-------------команды-------------------}
{---------------------------------------}
   go='GO';
   shut='FIRE';
   destroy='DESTROY';
   exits='EXIT';
   {----------}
   left='LEFT';
   right='RIGHT';
   down='DOWN';
   up='UP';
{---------------------------------------}
var r:array[0..n,0..n]of char;       //Масссив поля :!! без стен
wallvert:array[0..n,0..n]of boolean; //Массив вертикальных стен
wallgori:array[0..n,0..n]of boolean; //Массив горизонтальных стен
p:point;                             //Предыдущая созданная стена
w:array[1..n,1..n]of boolean;        //Клетки, куда мы можем добраться
gamers:array[1..n]of TGamer;         //Геймеры
ds:boolean;                          //Выбор типа стенки, кторую щас поставим
gorun:boolean;                       //Команда go
shutrun:boolean;                     //Команда shut
destroyrun:boolean;                  //Команда destroy
dirarun:boolean;                     //Команда зависнуть
q:integer;                           //Номер геймера
countforest:integer;
l:boolean;
{---------------------------------------}
function errorwalls:boolean; forward;
procedure wrt; forward;
{---------------------------------------}
procedure clrscr;
var i:integer;
begin
  for i:=1 to 1000 do writeln;
end;
procedure addwall;
begin
  ds:=not ds;
  p.x:=random(n-1)+1;
  p.y:=random(n-1)+1;
  if ds          then wallgori[p.y,p.x]:=true else
                      wallvert[p.y,p.x]:=true;
end;
function can_go_to(const p1,p2:point):boolean;
begin
  if abs(p1.x-p2.x)=1 then
    begin
      if not wallvert[p1.y,min(p1.x,p2.x)] then can_go_to:=true else
                                                can_go_to:=false;
    end else
    begin
      if not wallgori[min(p1.y,p2.y),p1.x] then can_go_to:=true else
                                                can_go_to:=false;
    end;
end;
function pointt(const y,x:integer):point;
begin
  pointt.x:=x;
  pointt.y:=y;
end;
procedure dfs(const p:point);
var i:integer;
begin
  if p.y>n then exit else
  if p.x>n then exit else
  if p.x=0 then exit else
  if p.y=0 then exit;


  w[p.y,p.x]:=true;
  for i:=1 to 4 do
     if (not w[p.y+dy[i],p.x+dx[i]])and(can_go_to(p,pointt(p.y+dy[i],p.x+dx[i]))) then
                         dfs(pointt(p.y+dy[i],p.x+dx[i]));
end;
function errorwalls:boolean;
var i,j:integer;
begin
  errorwalls:=false;
  for i:=1 to n do
  for j:=1 to n do w[i,j]:=false;
  dfs(pointt(1,1));
  for i:=1 to n do
  for j:=1 to n do if not w[i,j] then errorwalls:=true;

end;
procedure destroywall;
begin
  if ds then wallgori[p.y,p.x]:=false else
  wallvert[p.y,p.x]:=false;
end;
procedure genforest(y,x:integer);
var i,z:integer;
begin
  if countforest>numberofforest then exit;
  r[y,x]:=forest;
  for z:=1 to 4 do
    begin
      i:=random(4)+1;
      if can_go_to(pointt(y,x),pointt(y+dy[i],x+dx[i]))and(r[y+dy[i],x+dx[i]]='.') then
                                                            begin
                                                                 inc(countforest);
                                                                 genforest(y+dy[i],x+dx[i]);
                                                            end;
    end;
  if countforest<2 then genforest(y,x);
end;
procedure genriver(y,x:integer);
var i,j:integer;
l:boolean;
begin
      for i:=1 to 4 do begin l:=false; for j:=1 to lengthofriver do if not can_go_to(pointt(y,x),pointt(y+dy[i],x+dx[i]))or(r[y+dy[i],x+dx[i]]<>'.') then
                                                      begin
                                                        if l then r[y,x]:=#1;
                                                        exit;
                                                      end else
                                                      begin
                                                        if i=1 then r[y,x]:=#25 else
                                                        if i=2 then r[y,x]:=#24 else
                                                        if i=3 then r[y,x]:=#26 else
                                                                    r[y,x]:=#27;

                                                        inc(y,dy[i]);
                                                        inc(x,dx[i]);
                                                        l:=true;
                                                      end; end;
end;
procedure gen;
var i,j:integer;
begin
  for i:=1 to cycleswall do
    begin
      addwall;
      if errorWalls then destroywall;
    end;
  r[random(n)+1,random(n)+1]:=arsenal;

  repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
  r[p.y,p.x]:=lklad;

  repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
  r[p.y,p.x]:=lklad;

  repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
  r[p.y,p.x]:=klad;

  repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
  r[p.y,p.x]:=hospital;

  for i:=1 to numberofdirs+random(3) do
    begin
      repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
      r[p.y,p.x]:=chr(i+ord('0'));
    end;
  repeat p.x:=random(n)+1; p.y:=random(n)+1; until r[p.y,p.x]='.';
  genforest(p.y,p.x);
  for i:=1 to numberofgamers do
    begin
      clrscr;
      writeln('I wait coordinates(x,y) from gamer #',i);
      readln(gamers[i].point.x,gamers[i].point.y);
    end;
  clrscr;
end;
procedure init;
var i,j:integer;
begin
  randomize;
  countforest:=0;
  q:=1;
  gorun:=false;
  for i:=0 to n do
  for j:=0 to n do
    begin
      r[i,j]:='.';
      wallvert[i,j]:=false;
      wallgori[i,j]:=false;
    end;
  for i:=1 to n do
    begin
      gamers[i].point.x:=0;
      gamers[i].point.y:=0;
      gamers[i].p:=3;
      gamers[i].g:=3;
      gamers[i].klad:=false;
      gamers[i].typeofklad:=false;
      gamers[i].live:=true;
    end;
  for i:=0 to n do
    begin
      wallgori[0,i]:=true;
      wallgori[n,i]:=true;
      wallvert[i,0]:=true;
      wallvert[i,n]:=true;
    end;
  if random(2)=0 then wallgori[0,random(n)+1]:=false else
                      wallgori[n,random(n)+1]:=false;
end;
procedure help;
begin
  writeln('Go        napravlenie[left,right,up,down]');
  writeln('Destroy   napravlenie[left,right,up,down]');
  writeln('Fire      napravlenie[left,right,up,down]');
  writeln('Ask       ---- to ask true or false the klad');
  writeln('Lost klad ---- to lost the klad');
  writeln('Help      ---- to help');
  writeln('--------------------------------------------------------------------')
end;
procedure wrt;
var i,j:integer;
begin
  for i:=1 to n*2+1 do
    for j:=1 to n*2+1 do
      begin
        if (i mod 2=0)and(j mod 2=0) then write(r[i div 2,j div 2]) else
        if (i mod 2=1)and(j mod 2=1) then write(#177) else
        if (i mod 2=0)and(j mod 2=1) then if wallvert[i div 2,j div 2] then write('|') else write(' ')else
        if (i mod 2=1)and(j mod 2=0) then if wallgori[i div 2,j div 2] then write('-') else write(' ');
        if j=n*2+1 then writeln;
      end;
  for i:=1 to numberofgamers do writeln('Gamer number ',i,' x:',gamers[i].point.x,', y:',gamers[i].point.y);
end;
procedure upcasestring(var s:string);
var i:integer;
begin
  for i:=1 to length(s) do s[i]:=UpCase(s[i]);
end;
procedure deletespace(var s:string);
var i:integer;
begin
  for i:=1 to length(s) do if s[i]=' ' then delete(s,i,1);
end;
function errorcommand(var s:string):boolean;
begin
  errorcommand:=false;
  gorun:=false;
  shutrun:=false;
  destroyrun:=false;
  if copy(s,1,2)=go then
    begin
      gorun:=true;
      delete(s,1,2);
    end else
  if copy(s,1,4)=shut then
    begin
      SHUTRUN:=TRUE;
      delete(s,1,4);
    end else
  if copy(s,1,7)=destroy then
    begin
      destroyrun:=true;
      delete(s,1,7);
    end else
  if s=EXITs then halt(0) else
  if s='WRT' then
    begin
      wrt;
      errorcommand:=true;
      exit;
    end else
    gorun:=true;
  if (s<>up)and(s<>down)and(s<>right)and(s<>left) then errorcommand:=true;
end;
procedure gamerkill(const p:point);
var i:integer;
begin
  for i:=1 to numberofgamers do if (p.x=gamers[i].point.x)and(p.y=gamers[i].point.y) then
                                  begin
                                    writeln('You kill gamer #',i);
                                    gamers[i].live:=false;
                                    if gamers[i].klad then
                                    if gamers[i].typeofklad then r[gamers[i].point.y,gamers[i].point.x]:='I' else
                                                                 r[gamers[i].point.y,gamers[i].point.x]:='L';
                                    gamers[i].klad:=false;
                                  end;
end;
procedure shutq(p:point;const z:integer);
var count:integer;
begin
  count:=0;
  repeat
    if not can_go_to(p,pointt(p.y+dy[z],p.x+dx[z])) then break;
    inc(p.x,dx[z]);
    inc(p.y,dy[z]);
    gamerkill(p);
    inc(count);
  until count=farcount;
end;
procedure play;
var s:string;
z:integer;
i,j:integer;
temp1,temp2:integer;
label l1,l2;
begin
//  for i:=1 to numberofgamers do writeln('Gamer #',i,' x:',gamers[i].point.x,', y:',gamers[i].point.y);
  while true do
    begin
      writeln('---------------------------------------------');
      writeln('gamer #',q);
      writeln('You have ',gamers[q].g,' granats ',gamers[q].p,' patrons... Live status:',gamers[q].live,' Have treasure:',gamers[q].klad);
      l1:
      write('I wait a command > ');
      readln(s);
      deletespace(s);
      upcasestring(s);
      if s='HELP' then
         begin
           help;
           goto l1;
         end;
      if s='LOSTKLAD' then
        begin
          gamers[q].klad:=false;
          if gamers[q].typeofklad=true then
            r[gamers[q].point.y,gamers[q].point.x]:='I' else
            r[gamers[q].point.y,gamers[q].point.x]:='L';
          goto l2
        end;
      if s='help' then
        begin
          help;
          goto l1;
        end;
      if s='ASK' then
        begin
          if (gamers[q].point.x<=0)or(gamers[q].point.x>=n+1)or(gamers[q].point.y<=0)or(gamers[q].point.y>=n+1) then
            if gamers[q].typeofklad then
              begin
                writeln('You have the true treasure');
                writeln('Gamer #',q,' won...');
                wrt;
                writeln('Please press enter to continue...');
                readln;
                halt;
              end else writeln('You treasure isn''t true ...') else writeln('You treasure isn''t true ...');
          goto l2;
        end;
      if errorcommand(s) then
        begin
          writeln('Uncknown command...');
          goto l1;
        end else
      if gorun then
        begin
          writeln('You want to go ',s);
          if s=up then
              if can_go_to(gamers[q].point,pointt(gamers[q].point.Y-1,gamers[q].point.x)) then
                begin
                  gamers[q].point:=pointt(gamers[q].point.Y-1,gamers[q].point.x);
                  writeln('You go up...');
                end else writeln('And you find the wall') else

          if s=down then
              if can_go_to(gamers[q].point,pointt(gamers[q].point.Y+1,gamers[q].point.x)) then
                begin
                  gamers[q].point:=pointt(gamers[q].point.Y+1,gamers[q].point.x);
                  writeln('You go down...');
                end else writeln('And you find the wall') else

          if s=left then
              if can_go_to(gamers[q].point,pointt(gamers[q].point.Y,gamers[q].point.x-1)) then
                begin
                  gamers[q].point:=pointt(gamers[q].point.Y,gamers[q].point.x-1);
                  writeln('You go left...');
                end else writeln('You find the wall') else

          if s=right then
              if can_go_to(gamers[q].point,pointt(gamers[q].point.Y,gamers[q].point.x+1)) then
                begin
                  gamers[q].point:=pointt(gamers[q].point.Y,gamers[q].point.x+1);
                  writeln('You go right...');
                end else writeln('You find the wall') else
        end else
      if destroyrun then
        begin
          if (s=up)and(gamers[q].point.y-1=0) then
            begin
              writeln('You try to destroy the MAZE wall, you cann''t it');
              goto l2;
            end;
          if (s=down)and(gamers[q].point.y=n) then
            begin
              writeln('You try to destroy the MAZE wall, you cann''t it');
              goto l2;
            end;
          if (s=right)and(gamers[q].point.x=n) then
            begin
              writeln('You try to destroy the MAZE wall, you cann''t it');
              goto l2;
            end;
          if (s=left)and(gamers[q].point.x-1=0) then
            begin
              writeln('You try to destroy the MAZE wall, you cann''t it');
              goto l2;
            end;
          writeln('Now the ',s,' wall isn''t exist');
          dec(gamers[q].g);
          if gamers[q].g=-1 then
            begin
              gamers[q].g:=0;
              writeln('You havn''t got granats');
              goto l1;
            end;

          if s=up then wallgori[gamers[q].point.y-1,gamers[q].point.x]:=false else
          if s=down then wallgori[gamers[q].point.y,gamers[q].point.x]:=false else
          if s=right then wallvert[gamers[q].point.y,gamers[q].point.x]:=false else
          if s=left then wallvert[gamers[q].point.y,gamers[q].point.x-1]:=false;
        end else
      if shutrun then
        begin
          dec(gamers[q].p);
          if gamers[q].p=-1 then
            begin
              inc(gamers[q].p);
              writeln('You havn''t got patrons');
              goto l1;
            end;
          if s=up then z:=2 else
          if s=down then z:=1 else
          if s=right then z:=3 else z:=4;
          shutq(gamers[q].point,z);
        end;

      l:=false;
      if r[gamers[q].point.y,gamers[q].point.x]=#24 then begin dec(gamers[q].point.y);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#25 then begin inc(gamers[q].point.y);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#26 then begin inc(gamers[q].point.x);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#27 then begin dec(gamers[q].point.x);l:=true end;
      if r[gamers[q].point.y,gamers[q].point.x]=#24 then begin dec(gamers[q].point.y);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#25 then begin inc(gamers[q].point.y);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#26 then begin inc(gamers[q].point.x);l:=true end else
      if r[gamers[q].point.y,gamers[q].point.x]=#27 then begin dec(gamers[q].point.x);l:=true end;
      if l then
        begin
          if r[gamers[q].point.y,gamers[q].point.x]=#1 then writeln('You was in river, but now you are in normal cell...') else
                                                             writeln('You are in river');
        end;


      temp1:=-2;
      temp2:=-1;
      val(r[gamers[q].point.y,gamers[q].point.x],temp1,temp2);
      if temp1=numberofdirs then temp1:=0;
      if temp2=0 then
        begin
          for i:=1 to n do
          for j:=1 to n do
            begin
              z:=ord(r[i,j])-ord('0');
              if z=temp1+1 then
                             begin
                               ioresult;
                               writeln('You foll down into the black holl');
                               gamers[q].point.y:= i;
                               gamers[q].point.x:=j;
                             end;
            end;
          ioresult;
        end;
      if gamers[q].live=false then
        if r[gamers[q].point.y,gamers[q].point.x]=hospital then
          begin
            writeln('You find the hospital');
            writeln('You resurrection');
            gamers[q].live:=true;
          end else goto l2;

      if (r[gamers[q].point.y,gamers[q].point.x]='L')or(r[gamers[q].point.y,gamers[q].point.x]='I') then
        begin
          writeln('You find the treasure');
          if gamers[q].klad then
              writeln('But you can''t get it because you already have it...');
          gamers[q].klad:=true;
          if r[gamers[q].point.y,gamers[q].point.x]='L' then gamers[q].typeofklad:=false else gamers[q].typeofklad:=true;
          r[gamers[q].point.y,gamers[q].point.x]:='.';
        end;

      if r[gamers[q].point.y,gamers[q].point.x]=arsenal then
        begin
          writeln('You find the arsenal...');
          inc(gamers[q].p,3);
          inc(gamers[q].g,2);
        end;

      if r[gamers[q].point.y,gamers[q].point.x]=forest then
        begin
          writeln('Your the forest');
          writeln('Your in random cell of forest');
          while True do
          for i:=1 to n do
          for j:=1 to n do
          if r[i,j]=forest then
          if random(10)=7 then
            begin
              gamers[q].point.x:=j;
              gamers[q].point.y:=i;
              goto l2;
            end;
        end;
      l2: inc(q);
      if q>numberofgamers then q:=1;
    end;
end;
begin
  init;
  gen;
  help;
  play;
end.
