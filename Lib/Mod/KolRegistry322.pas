////////////////////////////////////////////////////////////////////////
//                        R  E  G  I  S  T  R  Y                      //
////////////////////////////////////////////////////////////////////////

{ -- registry -- }

function RegKeyOpenRead( Key: HKey; const SubKey: KOLString ): HKey;
begin
  if RegOpenKeyEx( Key, PKOLChar( SubKey ), 0, KEY_READ, Result ) <> ERROR_SUCCESS then
     Result := 0;
end;

function RegKeyOpenWrite( Key: HKey; const SubKey: KOLString ): HKey;
begin
  if RegOpenKeyEx( Key, PKOLChar( SubKey ), 0, KEY_READ or KEY_WRITE, Result ) <> ERROR_SUCCESS then
     Result := 0;
end;

function RegKeyOpenCreate( Key: HKey; const SubKey: KOLString ): HKey;
var dwDisp: DWORD;
begin
  if RegCreateKeyEx( Key, PKOLChar( SubKey ), 0, nil, 0, KEY_ALL_ACCESS, nil, Result,
                     @dwDisp ) <> ERROR_SUCCESS then
    Result := 0;
end;

function RegKeyGetDw( Key: HKey; const ValueName: KOLString ): DWORD;
var dwType, dwSize: DWORD;
begin
  dwSize := sizeof( DWORD );
  Result := 0;
  if (Key = 0) or
     (RegQueryValueEx( Key, PKOLChar( ValueName ), nil, @dwType, PByte( @Result ), @dwSize ) <> ERROR_SUCCESS)
     or (dwType <> REG_DWORD) then Result := 0;
end;

{$IFDEF REGKEYGETSTREX_ALWAYS}
function RegKeyGetStr( Key: HKey; const ValueName: KOLString ): KOLString;
begin
    Result := RegKeyGetStrEx( Key, ValueName
           {$IFDEF OPTIONAL_REG_EXPAND_SZ}, FALSE {$ENDIF} );
end;
{$ELSE}
function RegKeyGetStr( Key: HKey; const ValueName: KOLString ): KOLString;
var dwType, dwSize: DWORD;
    Buffer: PKOLChar;

    function Query: Boolean;
    begin
      Result := RegQueryValueEx( Key, PKOLChar( ValueName ), nil, @dwType,
                Pointer( Buffer ), @dwSize ) = ERROR_SUCCESS;
    end;
begin
  Result := '';
  if Key = 0 then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  dwSize := 0;
  Buffer := nil;
  if not Query or (dwType <> REG_SZ) then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  GetMem( Buffer, dwSize * Sizeof( KOLChar ) );
  if Query then
    Result := Buffer;
  FreeMem( Buffer );
end;
{$ENDIF}

function RegKeyGetStrEx( Key: HKey; const ValueName: KOLString
  {$IFDEF OPTIONAL_REG_EXPAND_SZ} ; ExpandEnvVars: Boolean {$ENDIF} ):
KOLString;
var dwType, dwSize: DWORD;
    Buffer, Buffer2: PKOLChar;
    Sz: Integer;
    function Query: Boolean;
    begin
      Result := RegQueryValueEx( Key, PKOLChar( ValueName ), nil, @dwType,
                Pointer( Buffer ), @dwSize ) = ERROR_SUCCESS;
    end;
begin
  Result := '';
  if Key = 0 then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  dwSize := 0;
  Buffer := nil;
  if not Query or ((dwType <> REG_SZ) and (dwtype <> REG_EXPAND_SZ)) then
     Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  GetMem( Buffer, dwSize * Sizeof( KOLChar ) );
  if Query then
  begin
     if (dwtype = REG_EXPAND_SZ) {$IFDEF OPTIONAL_REG_EXPAND_SZ} and (ExpandEnvVars) {$ENDIF} then
     begin
        Sz := ExpandEnvironmentStrings(Buffer,nil,0);
        GetMem(Buffer2,Sz * Sizeof( KOLChar ));                            //
        ExpandEnvironmentStrings(Buffer, Buffer2, Sz); //
        Result:=Buffer2;                               //
        FreeMem(Buffer2);                              //
     end else Result := Buffer;
  end;
  FreeMem( Buffer );
end;

function RegKeySetDw( Key: HKey; const ValueName: KOLString; Value: DWORD ): Boolean;
begin
  Result := (Key <> 0) and (RegSetValueEx( Key, PKOLChar( ValueName ), 0,
    REG_DWORD, @Value, sizeof( DWORD ) ) = ERROR_SUCCESS);
end;

function RegKeySetStr( Key: HKey; const ValueName: KOLString; const Value: KOLString ): Boolean;
begin
  Result := (Key <> 0) and (RegSetValueEx( Key, PKOLChar( ValueName ), 0,
            REG_SZ, PKOLChar(Value),
             (Length( Value ) + 1)*Sizeof(KOLChar) ) = ERROR_SUCCESS);
end;

function RegKeySetStrEx( Key: HKey; const ValueName: KOLString; const Value: KOLString;
                         expand: Boolean): Boolean;
var dwType: DWORD;
begin
  dwType := REG_SZ;
  if expand then
    dwType := REG_EXPAND_SZ;
  Result := (Key <> 0) and (RegSetValueEx(Key, PKOLChar(ValueName), 0, dwType,
            PKOLChar(Value), (Length(Value) + 1)*Sizeof(KOLChar)) = ERROR_SUCCESS);
end;

procedure RegKeyClose( Key: HKey );
begin
  if Key <> 0 then
    RegCloseKey( Key );
end;

function RegKeyDelete( Key: HKey; const SubKey: KOLString ): Boolean;
begin
  Result := FALSE;
  if Key <> 0 then
    Result := RegDeleteKey( Key, PKOLChar( SubKey ) ) = ERROR_SUCCESS;
end;

function RegKeyDeleteValue( Key: HKey; const SubKey: KOLString ): Boolean;
begin
  Result := FALSE;
  if Key <> 0 then
    Result := RegDeleteValue( Key, PKOLChar( SubKey ) ) = ERROR_SUCCESS;
end;

function RegKeyExists( Key: HKey; const SubKey: KOLString ): Boolean;
var K: Integer;
begin
  if Key = 0 then
  begin
    Result := FALSE; Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  end;
  K := RegKeyOpenRead( Key, SubKey );
  Result := K <> 0;
  if K <> 0 then
    RegKeyClose( K );
end;

function RegKeyValExists( Key: HKey; const ValueName: KOLString ): Boolean;
var dwType, dwSize: DWORD;
begin
  Result := (Key <> 0) and
            (RegQueryValueEx( Key, PKOLChar( ValueName ), nil,
            @dwType, nil, @dwSize ) = ERROR_SUCCESS);
end;

function RegKeyValueSize( Key: HKey; const ValueName: KOLString ): Integer;
begin
  Result := 0;
  if Key = 0 then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  RegQueryValueEx( Key, PKOLChar( ValueName ), nil, nil, nil, @ DWORD( Result ) );
end;

function RegKeyGetBinary( Key: HKey; const ValueName: KOLString; var Buffer; Count: Integer ): Integer;
begin
  Result := 0;
  if Key = 0 then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  Result := Count;
  RegQueryValueEx( Key, PKOLChar( ValueName ), nil, nil, @ Buffer, @ Result );
end;

function RegKeySetBinary( Key: HKey; const ValueName: KOLString; const Buffer; Count: Integer ): Boolean;
begin
  Result := (Key <> 0) and (RegSetValueEx( Key, PKOLChar( ValueName ), 0,
                    REG_BINARY, @ Buffer, Count ) = ERROR_SUCCESS);
end;

function RegKeyGetDateTime(Key: HKey; const ValueName: KOLString): TDateTime;
begin
  RegKeyGetBinary( Key, ValueName, Result, Sizeof( Result ) );
end;

function RegKeySetDateTime(Key: HKey; const ValueName: KOLString; DateTime: TDateTime): Boolean;
begin
  Result := RegKeySetBinary( Key, ValueName, DateTime, Sizeof( DateTime ) );
end;

{$IFDEF OLD_REGKEYGETSUBKEYS}
//-----------------------------------------------
// functions by Valerian Luft <luft@valerian.de>
//-----------------------------------------------
function RegKeyGetSubKeys( const Key: HKEY; List: PKOLStrList) : Boolean;
var
  I, Size, NumSubKeys, MaxSubKeyLen : DWORD;
  KeyName: KOLString;
begin
  Result := False;
  List.Clear ;
  if RegQueryInfoKey(Key, nil, nil, nil, @NumSubKeys, @MaxSubKeyLen, nil, nil, nil, nil,
nil, nil) = ERROR_SUCCESS then
    begin
      if NumSubKeys > 0 then begin
        for I := 0 to NumSubKeys-1 do
        begin
          Size := MaxSubKeyLen+1;
          SetLength(KeyName, Size);
          RegEnumKeyEx(Key, I, @KeyName[1], Size, nil, nil, nil, nil);
          KeyName := Trim(KeyName); // fixed by Jon
          List.Add(KeyName);
        end;
      end;
      Result:= True;
  end;
end;
{$ELSE} // new (faster) version by Alex Shyshko (Psychedelic)
function RegKeyGetSubKeys(const Key: HKEY; List: PKOLStrList) : Boolean;
var
  i, MaxSubKeyLen, Size: DWORD;
  Buf: PKOLChar;
begin
 Result:=false;
 List.Clear;

 if RegQueryInfoKey(Key, nil, nil, nil, nil, @MaxSubKeyLen, nil, nil, nil, nil,
     nil, nil) = ERROR_SUCCESS then
  begin
  if MaxSubKeyLen > 0 then
    begin
      Size:=MaxSubKeyLen + 1;              //
      GetMem(Buf,Size*Sizeof(KOLChar));    // fixed by Jon
      i:=0;

      while RegEnumKeyEx(Key,i,buf,Size,nil,nil,nil,nil) <> ERROR_NO_MORE_ITEMS do
      begin
       List.Add(KOLString(Buf));
       Size:=MaxSubKeyLen + 1;
       inc(i);
      end;

      FreeMem(Buf{,MaxSubKeyLen + 1});
    end; // if MaxSubKeyLen
   Result:=true;
  end; // if RegQueryInfoKey

end;
{$ENDIF}

{$IFDEF OLD_REGKEYGETVALUENAMES}
function RegKeyGetValueNames(const Key: HKEY; List: PKOLStrList): Boolean;
var
  I, Size, NumSubKeys, NumValueNames, MaxValueNameLen: DWORD;
  ValueName: KOLString;
begin
  List.Clear ;
  Result:=False;
  if RegQueryInfoKey(Key, nil, nil, nil, @NumSubKeys, nil, nil, @NumValueNames,
@MaxValueNameLen, nil, nil, nil) = ERROR_SUCCESS then
  begin
     if NumValueNames > 0 then
        for I := 0 to NumValueNames - 1 do begin
          Size := MaxValueNameLen + 1;
          SetLength(ValueName, Size);
          //FillChar(ValueName[1],Size,#0);
          RegEnumValue(Key, I, @ValueName[1], Size, nil, nil, nil, nil);
          ValueName := Trim(ValueName);
          List.Add(ValueName);
        end;
     Result := True;
  end ;
end;
{$ELSE} // new (faster) version by Alex Shyshko (Psychedelic)
function RegKeyGetValueNames(const Key: HKEY; List: PKOLStrList) : Boolean;
var
  i, MaxValueNameLen, Size: DWORD;
  Buf: PKOLchar;
begin
 Result:=false;
 List.Clear;

 if RegQueryInfoKey(Key, nil, nil, nil, nil, nil, nil, nil, @MaxValueNameLen, nil,
     nil, nil) = ERROR_SUCCESS then
  begin
  if MaxValueNameLen > 0 then
    begin
      Size:=MaxValueNameLen+1;
      GetMem(Buf,Size * SizeOf(KOLChar) );
      i:=0;
      while RegEnumValue(Key,i,buf,Size,nil,nil,nil,nil) <> ERROR_NO_MORE_ITEMS do
      begin
       List.Add(KOLString(Buf));
       Size:=MaxValueNameLen+1;
       inc(i);
      end;

      FreeMem(Buf {,MaxValueNameLen + ... system always knows how long buffer is});
    end; // if MaxValueNameLen
   Result:=true;
  end; // if RegQueryInfoKey

end;
{$ENDIF}

function RegKeyGetValueTyp (const Key:HKEY; const ValueName: KOLString) : DWORD;
begin
Result:= Key ;
if Key <> 0 then
   RegQueryValueEx (Key,@ValueName[1],NIL,@Result,NIL,NIL)
end;

//////////////////////////////////////////////////////////////////////
