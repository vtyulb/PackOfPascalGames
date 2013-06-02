uses crt;
var ch:char;

begin
  ch:='r';
  while ch<>'~' do begin
    if keypressed then ch:=readkey else continue;
    sound(ord(ch)*100);
    delay(10000);
    nosound;
  end;
end.