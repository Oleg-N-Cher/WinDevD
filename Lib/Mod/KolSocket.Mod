MODULE KolSocket;

IMPORT
  SYSTEM, w := WinApi, n := WinNet, KolObj, KolStrings, KolTypes, Ignore;

CONST
  WM_SOCKET                 = w.WM_USER + 7000H;
  WM_SOCKETERROR            = w.WM_USER + 7001H;
  WM_SOCKETCLOSE            = w.WM_USER + 7002H;
  WM_SOCKETREAD             = w.WM_USER + 7003H;
  WM_SOCKETCONNECT          = w.WM_USER + 7004H;
  WM_SOCKETACCEPT           = w.WM_USER + 7005H;
  WM_SOCKETWRITE            = w.WM_USER + 7006H;
  WM_SOCKETOOB              = w.WM_USER + 7007H;
  WM_SOCKETLISTEN           = w.WM_USER + 7008H;
  WM_SOCKETLOOKUP           = w.WM_USER + 7009H;

  EVENTS_DOLISTEN           = n.FD_CLOSE + n.FD_ACCEPT;
  EVENTS_DOCONNECT          = n.FD_CONNECT + n.FD_CLOSE + n.FD_READ;
  EVENTS_SETSOCKETHANDLE    = n.FD_READ + n.FD_CLOSE + n.FD_CONNECT;

  MaxWord                   = 65535;
  MinWord                   = 0;

  c_FIRST*                  = 1;

  INVALID_SOCKET            = n.INVALID_SOCKET;
  HWND_DESKTOP              = NIL;

TYPE
  TMessage = RECORD [1]
    msg    : SHORTINT;
    lParam : w.LPARAM;
    wParam : w.WPARAM;
  END;

  TWndMethod = PROCEDURE (VAR self: SYSTEM.PTR; VAR message: TMessage);

  PhWnd = POINTER [1] TO ThWnd;
  ThWnd = RECORD (KolObj.TObj)
    m_hWnd: w.HWND;
  END;

  PAsyncSocket* = POINTER [1] TO TAsyncSocket;
  TKOLSocket*   = PAsyncSocket;

  TWMSocket = RECORD
    msg: SHORTINT; (*
    case Integer of
    0: (
      SocketWParam: Word;
      SocketDataSize: LongInt;
      SocketNumber: Longint;
      SocketAddress: PAsyncSocket);
    1: (
      WParamLo: Byte;
      WParamHi: Byte;
      SocketEvent: Word;
      SocketError: Word;
      ResultLo: Word;
      ResultHi: Word);
    2: (
      WParam: Word;
      TaskHandle: Word;
      WordHolder: Word;
      pHostStruct: Pointer); *)
(* 0: *)
      SocketNumber: n.SOCKET; (* INTEGER *)
      SocketAddress: PAsyncSocket;
(* 1: *)
      SocketError: SHORTINT;
  END;
(*
  TBArray = array[0..65534] of byte;

  TBufRecord = record
     i: integer;
     p:^TBArray;
  END;
*)
  TSocketMessageEvent = PROCEDURE (self: PAsyncSocket; SocketMessage: TWMSocket);

  TAsyncSocket* = RECORD (KolObj.TObj)
    m_SockAddr:         n.sockaddr_in;
    m_Handle:           n.SOCKET;
    m_hWnd:             PhWnd;
    fConnected:         BOOLEAN;(*
    fDNSResult:         string;
    fDNSHandle:         integer;
    FDnsBuffer:         array [0..MAXGETHOSTSTRUCT] of char;
    FList:              PList;*)
    FOnError:           TSocketMessageEvent;
    FOnLookup:          TSocketMessageEvent;
    FOnAccept:          TSocketMessageEvent;
    FOnClose:           TSocketMessageEvent;
    FOnConnect:         TSocketMessageEvent;
    FOnRead:            TSocketMessageEvent;
    FOnWrite:           TSocketMessageEvent;
    FOnListen:          TSocketMessageEvent;
    FOnOOB:             TSocketMessageEvent;
(*
  protected
    destructor Destroy; virtual;

  private
    PROCEDURE GetCount: LongInt;
    PROCEDURE GetPortNumber: LongInt;
    PROCEDURE GetIPAddress: String;
    PROCEDURE ErrorTest(Evaluation: LongInt): LongInt;

    PROCEDURE AllocateSocket;
    PROCEDURE KillWinsockBug;
    PROCEDURE SetPortNumber(NewPortNumber: LongInt);
    PROCEDURE SetIPAddress(NewIPAddress: String);
    PROCEDURE SetSocketHandle(NewSocketHandle: TSocket);
    PROCEDURE  GetConnected: boolean;

    // Message Handlers

    PROCEDURE HWndProcedure(VAR Message: TMessage);

    PROCEDURE Message_Error(VAR Message: TWMSocket);
    PROCEDURE Message_Lookup(VAR Message: TWMSocket);
    PROCEDURE Message_Close(VAR Message: TWMSocket);
    PROCEDURE Message_Accept(VAR Message: TWMSocket);
    PROCEDURE Message_Read(VAR Message: TWMSocket);
    PROCEDURE Message_Connect(VAR Message: TWMSocket);
    PROCEDURE Message_Write(VAR Message: TWMSocket);
    PROCEDURE Message_OOB(VAR Message: TWMSocket);
    PROCEDURE Message_Listen(VAR Message: TWMSocket);
    PROCEDURE DoReceive(Buffer: Pointer; VAR ReceiveLen: LongInt);
    PROCEDURE DoFinal(Abort: boolean);

  public
    PROCEDURE ProcessMessages;
    PROCEDURE  DoGetHostByAddr(IPAddr: PChar): String;
    PROCEDURE  DoGetHostByName(Name: PChar): String;

    PROCEDURE DoLookup(host: string);
    PROCEDURE DoClose;
    PROCEDURE DoSend(Buffer: Pointer; VAR SendLen: LongInt);
    PROCEDURE DoListen;
    PROCEDURE DoConnect;
    PROCEDURE DoAccept(VAR AcceptSocket: PAsyncSocket);

    PROCEDURE SendString(fString: String);

    PROCEDURE  ReadData(b: pointer; c: integer): integer;
    PROCEDURE  ReadLine(c: char): string; overload;
    PROCEDURE  ReadLine(c: char; t: integer): string; overload;
    PROCEDURE  LocalIP: String;
    PROCEDURE  LocalPort: integer;

    property  SocketHandle: TSocket read m_Handle write SetSocketHandle;
    property  IPAddress: String read GetIPAddress write SetIPAddress;
    property  PortNumber: LongInt read GetPortNumber write SetPortNumber;
    property  Count: LongInt read GetCount;
    property  Connected: boolean read GetConnected;
    property  DNSResult: string read fDNSResult write fDNSResult;

    property  OnError: TSocketMessageEvent read FOnError write FOnError;
    property  OnLookup: TSocketMessageEvent read FOnLookup write FOnLookup;
    property  OnAccept: TSocketMessageEvent read FOnAccept write FOnAccept;
    property  OnClose: TSocketMessageEvent read FOnClose write FOnClose;
    property  OnConnect: TSocketMessageEvent read FOnConnect write FOnConnect;
    property  OnRead: TSocketMessageEvent read FOnRead write FOnRead;
    property  OnWrite: TSocketMessageEvent read FOnWrite write FOnWrite;
    property  OnOOB: TSocketMessageEvent read FOnOOB write FOnOOB;
    property  OnListen: TSocketMessageEvent read FOnListen write FOnListen;
  *)END;
VAR
  InstanceCount: INTEGER; (* = 0 *)
(*
  PROCEDURE NewThWnd(WndMethod: TWndMethod): PhWnd;*)
  PROCEDURE ^ NewAsyncSocket* (): PAsyncSocket;
  PROCEDURE ^ (VAR self: TAsyncSocket) Message_Error* (VAR message: INTEGER);

  PROCEDURE ^ ErrToStr (err: INTEGER; VAR errStr: ARRAY OF CHAR);
(*
implementation

uses objects;

PROCEDURE NewThWnd;
BEGIN
  New(Result, Create);
  Result.m_hWnd := AllocateHWnd(WndMethod);
END;  // constructor ThWnd.Create(WndMethod: TWndMethod)

destructor ThWnd.Destroy;
BEGIN
  DeallocateHWnd(m_hWnd);
  inherited;
END;
*)
PROCEDURE NewAsyncSocket* (): PAsyncSocket;
VAR
  TempWSAData: n.WSADATA; Result: PAsyncSocket;
BEGIN
  INC(InstanceCount);
  NEW(Result); Result^.Create;
  IF (InstanceCount = c_FIRST) THEN Ignore.Int (
    (*Result^.ErrorTest( *)n.WSAStartup(101H, TempWSAData));
  END;(*
  Result.KillWinsockBug;
  Result.m_Handle := INVALID_SOCKET;
  Result.m_SockAddr.sin_family := AF_INET;
  Result.m_SockAddr.sin_addr.s_addr := INet_Addr('0.0.0.0');
  Result.PortNumber := 0;
  Result.FList := NewList;
  Result.m_hWnd := NewThWnd(Result.HWndProcedure);
*)
  RETURN Result
END NewAsyncSocket; (* CONSTRUCTOR TAsyncSocket.Create *)

(*PROCEDURE TAsyncSocket.GetCount;
VAR i: integer;
    t:^TBufRecord;
BEGIN
   result := 0;
   for i := 0 to FList.Count - 1 do BEGIN
      t := FList.Items[i];
      result := result + t^.i;
   END;
END;

PROCEDURE TAsyncSocket.ReadData;
VAR n,
    r: integer;
    t:^TBufRecord;
    u:^TBufRecord;
    a:^TBArray;
BEGIN
   IF FList.count = 0 THEN BEGIN
      result := 0;
      exit;
   END;
   n := 0;
   a := b;
   while (n < c) and (n < count) do BEGIN
      r := c - n;
      t := FList.Items[0];
      IF r > t^.i THEN r := t^.i;
      move(t^.p^, a^[n], r);
      n := n + r;
      IF r = t^.i THEN BEGIN
         FreeMem(t^.p, t^.i);
         FreeMem(t, SizeOf(TBufRecord));
         FList.Delete(0);
      end else BEGIN
         GetMem(u, SizeOf(TBufRecord));
         u^.i := t^.i - r;
         GetMem(u^.p, u^.i);
         move(t^.p^[r], u^.p^, u^.i);
         FreeMem(t^.p, t^.i);
         FreeMem(t, SizeOf(TBufRecord));
         FList.Items[0] := u;
      END;
   END;
   result := n;
END;

PROCEDURE TAsyncSocket.ReadLine(c: char): string;
VAR i,
    n,
    j: integer;
    t:^TBufRecord;
    s: string;
BEGIN
   result := '';
   n := 0;
   IF count = 0 THEN exit;
   for i := 0 to FList.Count - 1 do BEGIN
      t := FList.Items[i];
      for j := 0 to t^.i - 1 do BEGIN
         inc(n);
         IF chr(t^.p^[j]) = c THEN BEGIN
            setlength(s, n - 1);
            ReadData(@s[1], n - 1);
            ReadData(@n   ,     1);
            result := s;
            exit;
         END;
      END;
   END;
   setlength(s, n);
   ReadData(@s[1], n);
   Result := s;
END;

PROCEDURE TAsyncSocket.ReadLine(c: char; t: integer): string;
VAR tt: longint;
   Msg: tagMSG;
BEGIN
   result := '';
   tt := gettickcount;
   while (result = '') and (longint(gettickcount) < tt + t * 1000) do BEGIN
      IF PeekMessage(Msg, m_hWnd.m_hWnd, 0, 0, PM_REMOVE) THEN BEGIN
         DispatchMessage(Msg);
      END;
      result := ReadLine(c);
      IF m_Handle = INVALID_SOCKET THEN exit;
   END;
END;

PROCEDURE TAsyncSocket.GetIPAddress: String;
BEGIN
  Result := INet_NToA(m_SockAddr.sin_addr);
END;  // PROCEDURE TAsyncSocket.GetIPAddress: String

PROCEDURE TAsyncSocket.GetPortNumber: LongInt;
BEGIN
  Result := NToHS(m_SockAddr.sin_port);
END;  // PROCEDURE TAsyncSocket.GetPortNumber: Word

PROCEDURE TAsyncSocket.AllocateSocket;
BEGIN
  IF (m_Handle = INVALID_SOCKET) THEN
    BEGIN
    m_Handle := ErrorTest(socket(AF_INET, SOCK_STREAM, 0));
    END;  // IF (m_Handle = INVALID_SOCKET) THEN
END;  // PROCEDURE TAsyncSocket.AllocateSocket

PROCEDURE TAsyncSocket.SetSocketHandle(NewSocketHandle: TSocket);
BEGIN
  DoFinal(True);
  m_Handle := NewSocketHandle;
  ErrorTest(WSAAsyncSelect(m_Handle, m_hWnd.Handle, WM_SOCKET, EVENTS_SETSOCKETHANDLE));
END;  // PROCEDURE TAsyncSocket.SetSocketHandle(NewSocketHandle: TSocket)

PROCEDURE TAsyncSocket.GetConnected;
BEGIN
   result := m_Handle <> INVALID_SOCKET;
END;
*)
PROCEDURE (VAR self: TAsyncSocket) ErrorTest (evaluation: INTEGER): INTEGER;
VAR
  tempMessage: TWMSocket;
BEGIN
  IF (evaluation = n.SOCKET_ERROR) OR (evaluation = INVALID_SOCKET) THEN
    tempMessage.msg := WM_SOCKETERROR;
    tempMessage.SocketError := SHORT( n.WSAGetLastError() );
    tempMessage.SocketNumber := self.m_Handle;
    tempMessage.SocketAddress := SYSTEM.VAL(PAsyncSocket, SYSTEM.ADR(self));

  END;
  RETURN evaluation
END ErrorTest;

PROCEDURE KillWinsockBug;
VAR
  Addr: INTEGER;
BEGIN
  Addr := 0;
  (* For an unknown reason, if a call is made to GetHostByName and it should *)
  (* fail, the following call to GetHostByAddr will not fail, but return '>' *)
  (* in the place of the host name.  This clears the problem up. *)
  Ignore.Ptr(
    n.gethostbyname(SYSTEM.VAL(w.PtrSTR, SYSTEM.ADR("")))
  );
  Ignore.Ptr(
    n.gethostbyaddr(SYSTEM.VAL(w.PtrSTR, SYSTEM.ADR(Addr)),
      SIZE(INTEGER), n.PF_INET)
  );
  Ignore.Ptr(
    n.gethostbyname(SYSTEM.VAL(w.PtrSTR, SYSTEM.ADR("")))
  );
END KillWinsockBug;
(*
PROCEDURE TAsyncSocket.SetIPAddress(NewIPAddress: String);
VAR
   pTempHostEnt: PHostEnt;
BEGIN
  m_SockAddr.sin_addr.s_addr := INet_Addr(PChar(NewIPAddress));
  IF (m_SockAddr.sin_addr.s_addr = u_long(INADDR_NONE))  THEN
     BEGIN
     pTempHostEnt := GetHostByName(PChar(NewIPAddress));
     IF (pTempHostEnt <> Nil) THEN
        m_SockAddr.sin_addr.s_addr := PInAddr(pTempHostEnt^.h_addr_list^)^.s_addr;
     END;
END;  // PROCEDURE TAsyncSocket.SetIPAddress(NewIPAddress: String)

PROCEDURE TAsyncSocket.SetPortNumber(NewPortNumber: LongInt);
BEGIN
  IF ((NewPortNumber > 0) AND (NewPortNumber <= MaxWord)) THEN
    m_SockAddr.sin_port := HToNS(NewPortNumber);
END;  // PROCEDURE TAsyncSocket.SetPortNumber(NewPortNumber: Word)

PROCEDURE TAsyncSocket.DoReceive(Buffer: Pointer; VAR ReceiveLen: LongInt);
BEGIN
  ReceiveLen := recv(m_Handle, Buffer^, ReceiveLen, 0);
  ErrorTest(ReceiveLen);
END;  // TAsyncSocket.DoReceive(Buffer: Pointer; BufferLen: LongInt)

PROCEDURE TAsyncSocket.DoSend(Buffer: Pointer; VAR SendLen: LongInt);
BEGIN
  SendLen := send(m_Handle, Buffer^, SendLen, 0);
  ErrorTest(SendLen);
END;  // PROCEDURE TAsyncSocket.DoSend(Buffer: Pointer; BufferLen: LongInt)

PROCEDURE TAsyncSocket.DoLookup;
VAR
   IPAddr  : TInAddr;
BEGIN
   IF Host = '' THEN BEGIN
      Exit;
   END;

   { Cancel any pending lookup }
   IF FDnsHandle <> 0 THEN
      WSACancelAsyncRequest(FDnsHandle);

    FDnsResult := '';

    IPAddr.S_addr := Inet_addr(PChar(Host));
    IF IPAddr.S_addr <> u_long(INADDR_NONE) THEN BEGIN
        FDnsResult := inet_ntoa(IPAddr);
{        TriggerDnsLookupDone(0);}
        Exit;
    END;

    FDnsHandle := WSAAsyncGetHostByName(m_hWnd.Handle,
                                        WM_SOCKETLOOKUP,
                                        @Host[1],
                                        @FDnsBuffer,
                                        SizeOf(FDnsBuffer));
    IF FDnsHandle = 0 THEN BEGIN
       ErrorTest(WSAGetLastError);
       Exit;
    END;
END;

PROCEDURE TAsyncSocket.DoClose;
BEGIN
   DoFinal(True);
END;

PROCEDURE TAsyncSocket.DoFinal;
VAR
  TempMessage: TWMSocket;
BEGIN
  IF (m_Handle <> INVALID_SOCKET) THEN BEGIN
    IF not Abort THEN BEGIN
       ProcessMessages;
    END;
    TempMessage.Msg := WM_SOCKETCLOSE;
    TempMessage.SocketNumber := m_Handle;
    TempMessage.SocketAddress := @self;
    Message_Close(TempMessage);
    ErrorTest(closesocket(m_Handle));
    m_Handle := INVALID_SOCKET;
    END;
END;

PROCEDURE TAsyncSocket.DoAccept(VAR AcceptSocket: PAsyncSocket);
VAR
  TempSize: Integer;
  TempSock: TSocket;
  TempAddr: TSockAddrIn;
BEGIN
  TempSize := SizeOf(TSockAddr);
  TempSock := accept(m_Handle, @TempAddr, @TempSize);
  AcceptSocket.m_SockAddr := TempAddr;
  IF (ErrorTest(TempSock) <> INVALID_SOCKET) THEN
    AcceptSocket.SocketHandle := TempSock;
END;  // PROCEDURE TAsyncSocket.DoAccept(VAR AcceptSocket: TAsyncSocket)

PROCEDURE TAsyncSocket.DoListen;
VAR
  TempMessage: TWMSocket;
BEGIN
  DoClose;
  AllocateSocket;
  IF
    (ErrorTest(WSAAsyncSelect(m_Handle, m_hWnd.Handle, WM_SOCKET, EVENTS_DOLISTEN))
      <> SOCKET_ERROR) AND
    (ErrorTest(bind(m_Handle, m_SockAddr, SizeOf(TSockAddr))) <> SOCKET_ERROR) AND
    (ErrorTest(listen(m_Handle, 5)) <> SOCKET_ERROR) THEN
    BEGIN
    TempMessage.Msg := WM_SOCKETLISTEN;
    TempMessage.SocketNumber := m_Handle;
    TempMessage.SocketAddress := @self;
    Message_Listen(TempMessage);
    end
  else
    DoClose;
END;  // PROCEDURE TAsyncSocket.DoListen

PROCEDURE TAsyncSocket.DoConnect;
VAR
  TempResult: LongInt;
BEGIN
  DoClose;
  AllocateSocket;
  ErrorTest(WSAAsyncSelect(m_Handle, m_hWnd.Handle, WM_SOCKET, EVENTS_DOCONNECT));
  TempResult := connect(m_Handle, m_SockAddr, SizeOf(TSockAddr));
  IF ((TempResult = SOCKET_ERROR) AND (WSAGetLastError <> WSAEWOULDBLOCK)) THEN
    ErrorTest(SOCKET_ERROR);
END;  // PROCEDURE TAsyncSocket.DoConnect

PROCEDURE TAsyncSocket.SendString;
VAR
  L: LongInt;
BEGIN
  L := Length(fString);
  DoSend(PChar(fString), L);
END;

PROCEDURE TAsyncSocket.DoGetHostByName(Name: PChar): String;
VAR
   pTempHostEnt: PHostEnt;
BEGIN
  pTempHostEnt := GetHostByName(Name);
  IF (pTempHostEnt <> Nil) THEN
    Result := inet_ntoa(pInAddr(pTempHostEnt^.h_addr_list^)^)
  else
    Result := '';
END;

PROCEDURE TAsyncSocket.ProcessMessages;
VAR Msg: TMsg;
BEGIN
   while PeekMessage(Msg, m_hWnd.m_hWnd, WM_SOCKET, WM_SOCKETLOOKUP, PM_REMOVE) do BEGIN
      DispatchMessage(Msg);
   END;
END;

PROCEDURE TAsyncSocket.DoGetHostByAddr(IPAddr: PChar): String;
VAR
   pTempHostEnt: PHostEnt;
   TempAddr: LongInt;
BEGIN
  TempAddr := INet_Addr(IPAddr);
  pTempHostEnt := GetHostByAddr(@TempAddr, SizeOf(TempAddr), PF_INET);
  IF (pTempHostEnt <> Nil) THEN
    Result := pTempHostEnt^.h_name
  else
    Result := '';
END;

PROCEDURE TAsyncSocket.HWndProcedure(VAR Message: TMessage);
VAR
  TempMessage: TWMSocket;
BEGIN
  case Message.Msg of
    WM_SOCKETLOOKUP:
      BEGIN
         TempMessage.Msg := WM_SOCKETLOOKUP;
         TempMessage.SocketNumber := m_Handle;
         TempMessage.SocketAddress := @self;
         Message_Lookup(TempMessage);
      END;
    WM_SOCKET:
      BEGIN
      IF (Message.LParamHi > WSABASEERR) THEN
        BEGIN
        WSASetLastError(Message.LParamHi);
        ErrorTest(SOCKET_ERROR);
        end  // IF (Message.LParamHi > WSABASEERR) THEN
      else
        BEGIN
        case Message.LParamLo of
          FD_READ:
            BEGIN
            TempMessage.SocketDataSize := 0;
            ErrorTest(IOCtlSocket(m_Handle, FIONREAD, TempMessage.SocketDataSize));
            TempMessage.Msg := WM_SOCKETREAD;
            TempMessage.SocketNumber := m_Handle;
            TempMessage.SocketAddress := @self;
            Message_Read(TempMessage);
            END;  // FD_READ
          FD_CLOSE:
            BEGIN
            DoFinal(False);
            END; // FD_CLOSE
          FD_CONNECT:
            BEGIN
            TempMessage.Msg := WM_SOCKETCONNECT;
            TempMessage.SocketNumber := m_Handle;
            TempMessage.SocketAddress := @self;
            Message_Connect(TempMessage);
            END;  // FD_CONNECT
          FD_ACCEPT:
            BEGIN
            TempMessage.Msg := WM_SOCKETACCEPT;
            TempMessage.SocketNumber := m_Handle;
            TempMessage.SocketAddress := @self;
            Message_Accept(TempMessage);
            END;  // FD_ACCEPT
          FD_WRITE:
            BEGIN
            TempMessage.Msg := WM_SOCKETWRITE;
            TempMessage.SocketNumber := m_Handle;
            TempMessage.SocketAddress := @self;
            Message_Write(TempMessage);
            END;  // FD_WRITE
          FD_OOB:
            BEGIN
            TempMessage.Msg := WM_SOCKETOOB;
            TempMessage.SocketNumber := m_Handle;
            TempMessage.SocketAddress := @self;
            Message_OOB(TempMessage);
            END;  // FD_OOB
          END;  // case Message.LParamLo of
        end  // else (IF (Message.LParamHi > WSABASEERR) THEN)
      END;  // WM_SOCKET:
      else
      Message.Result := DefWindowProc(m_hWnd.m_hWnd, Message.Msg, Message.WParam, Message.LParam);
    END;  // case Message.Msg of
END;  // PROCEDURE TAsyncSocket.HWndProcedure(VAR Message: TMessage)
*)
PROCEDURE (VAR self: TAsyncSocket) Message_Error* (VAR message: INTEGER);
VAR
  text: ARRAY 64 OF CHAR; socketNumber: ARRAY 24 OF CHAR;
  socketNumberInt: LONGINT;
BEGIN
    ErrToStr(message, text);
    KolStrings.Append(text, " on socket ");
    IF SIZE(n.SOCKET) = 4 THEN
      socketNumberInt := SYSTEM.VAL(INTEGER, message);
    ELSE
      socketNumberInt := SYSTEM.VAL(LONGINT, message);
    END;
    KolTypes.IntToString(socketNumberInt, socketNumber);
    KolStrings.Append(text, socketNumber);
    Ignore.Int(
      w.MessageBox(
        HWND_DESKTOP,
        SYSTEM.VAL(w.PtrSTR, text),
        SYSTEM.VAL(w.PtrSTR, SYSTEM.ADR("Message_Error")),
        w.MB_OK)
    );

END Message_Error;
(*
PROCEDURE TAsyncSocket.Message_Lookup(VAR Message: TWMSocket);
VAR p: PHostEnt;
BEGIN
  p := @fDNSBuffer;
  fDNSResult := p.h_name;
  IF Assigned(FOnLookup) THEN FOnLookup(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETLOOKUP on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Lookup', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_LookUp(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Close(VAR Message: TWMSocket);
BEGIN
  fConnected := False;
  IF Assigned(FOnClose) THEN FOnClose(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETCLOSE on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Close', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Close(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Accept(VAR Message: TWMSocket);
BEGIN
  fConnected := True;
  IF Assigned(FOnAccept) THEN FOnAccept(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETACCEPT on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Accept', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Accept(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Read(VAR Message: TWMSocket);
VAR t:^TBufRecord;
BEGIN
  IF Message.SocketDataSize > 0 THEN BEGIN
     fConnected := True;
     GetMem(t, sizeof(TBufRecord));
     t^.i := Message.SocketDataSize;
     GetMem(t^.p, t^.i);
     DoReceive(t^.p, t^.i);
     FList.Add(t);
  END;
  IF Assigned(FOnRead) THEN FOnRead(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETREAD on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Read', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Read(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Connect(VAR Message: TWMSocket);
BEGIN
  fConnected := True;
  IF Assigned(FOnConnect) THEN FOnConnect(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETCONNECT on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Connect', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Connect(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Write(VAR Message: TWMSocket);
BEGIN
  fConnected := True;
  IF Assigned(FOnWrite) THEN FOnWrite(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETWRITE on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Write', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Write(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_OOB(VAR Message: TWMSocket);
BEGIN
  IF Assigned(FOnOOB) THEN FOnOOB(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETOOB on socket ' + Int2Str(Message.SocketNumber)),
    'Message_OOB', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_OOB(VAR Message: TWMSocket)

PROCEDURE TAsyncSocket.Message_Listen(VAR Message: TWMSocket);
BEGIN
  IF Assigned(FOnListen) THEN FOnListen(Message)
  else
  MessageBox(HWND_DESKTOP, PChar('WM_SOCKETLISTEN on socket ' + Int2Str(Message.SocketNumber)),
    'Message_Listen', MB_OK);
END;  // PROCEDURE TAsyncSocket.Message_Listen(VAR Message: TWMSocket)

destructor TAsyncSocket.Destroy;
VAR t:^TBufRecord;
    i: integer;
BEGIN
  DoClose;
  IF (InstanceCount = c_FIRST) THEN
    ErrorTest(WSACleanup);
  m_hWnd.Free;
  for i := 0 to FList.Count - 1 do BEGIN
     t := FList.Items[i];
     FreeMem(t^.p, t^.i);
     FreeMem(t, SizeOf(TBufRecord));
  END;
  FList.Free;
  InstanceCount := InstanceCount - 1;
  inherited;
END;
*)
PROCEDURE ErrToStr (err: INTEGER; VAR errStr: ARRAY OF CHAR);
BEGIN
  IF err = n.WSAEINTR THEN
    COPY("WSAEINTR", errStr);
  ELSIF err = n.WSAEBADF THEN
    COPY("WSAEBADF", errStr);
  ELSIF err = n.WSAEACCES THEN
    COPY("WSAEACCES", errStr);
  ELSIF err = n.WSAEFAULT THEN
    COPY("WSAEFAULT", errStr);
  ELSIF err = n.WSAEINVAL THEN
    COPY("WSAEINVAL", errStr);
  ELSIF err = n.WSAEMFILE THEN
    COPY("WSAEMFILE", errStr);
  ELSIF err = n.WSAEWOULDBLOCK THEN
    COPY("WSAEWOULDBLOCK", errStr);
  ELSIF err = n.WSAEINPROGRESS THEN
    COPY("WSAEINPROGRESS", errStr);
  ELSIF err = n.WSAEALREADY THEN
    COPY("WSAEALREADY", errStr);
  ELSIF err = n.WSAENOTSOCK THEN
    COPY("WSAENOTSOCK", errStr);
  ELSIF err = n.WSAEDESTADDRREQ THEN
    COPY("WSAEDESTADDRREQ", errStr);
  ELSIF err = n.WSAEMSGSIZE THEN
    COPY("WSAEMSGSIZE", errStr);
  ELSIF err = n.WSAEPROTOTYPE THEN
    COPY("WSAEPROTOTYPE", errStr);
  ELSIF err = n.WSAENOPROTOOPT THEN
    COPY("WSAENOPROTOOPT", errStr);
  ELSIF err = n.WSAEPROTONOSUPPORT THEN
    COPY("WSAEPROTONOSUPPORT", errStr);
  ELSIF err = n.WSAESOCKTNOSUPPORT THEN
    COPY("WSAESOCKTNOSUPPORT", errStr);
  ELSIF err = n.WSAEOPNOTSUPP THEN
    COPY("WSAEOPNOTSUPP", errStr);
  ELSIF err = n.WSAEPFNOSUPPORT THEN
    COPY("WSAEPFNOSUPPORT", errStr);
  ELSIF err = n.WSAEAFNOSUPPORT THEN
    COPY("WSAEAFNOSUPPORT", errStr);
  ELSIF err = n.WSAEADDRINUSE THEN
    COPY("WSAEADDRINUSE", errStr);
  ELSIF err = n.WSAEADDRNOTAVAIL THEN
    COPY("WSAEADDRNOTAVAIL", errStr);
  ELSIF err = n.WSAENETDOWN THEN
    COPY("WSAENETDOWN", errStr);
  ELSIF err = n.WSAENETUNREACH THEN
    COPY("WSAENETUNREACH", errStr);
  ELSIF err = n.WSAENETRESET THEN
    COPY("WSAENETRESET", errStr);
  ELSIF err = n.WSAECONNABORTED THEN
    COPY("WSAECONNABORTED", errStr);
  ELSIF err = n.WSAECONNRESET THEN
    COPY("WSAECONNRESET", errStr);
  ELSIF err = n.WSAENOBUFS THEN
    COPY("WSAENOBUFS", errStr);
  ELSIF err = n.WSAEISCONN THEN
    COPY("WSAEISCONN", errStr);
  ELSIF err = n.WSAENOTCONN THEN
    COPY("WSAENOTCONN", errStr);
  ELSIF err = n.WSAESHUTDOWN THEN
    COPY("WSAESHUTDOWN", errStr);
  ELSIF err = n.WSAETOOMANYREFS THEN
    COPY("WSAETOOMANYREFS", errStr);
  ELSIF err = n.WSAETIMEDOUT THEN
    COPY("WSAETIMEDOUT", errStr);
  ELSIF err = n.WSAECONNREFUSED THEN
    COPY("WSAECONNREFUSED", errStr);
  ELSIF err = n.WSAELOOP THEN
    COPY("WSAELOOP", errStr);
  ELSIF err = n.WSAENAMETOOLONG THEN
    COPY("WSAENAMETOOLONG", errStr);
  ELSIF err = n.WSAEHOSTDOWN THEN
    COPY("WSAEHOSTDOWN", errStr);
  ELSIF err = n.WSAEHOSTUNREACH THEN
    COPY("WSAEHOSTUNREACH", errStr);
  ELSIF err = n.WSAENOTEMPTY THEN
    COPY("WSAENOTEMPTY", errStr);
  ELSIF err = n.WSAEPROCLIM THEN
    COPY("WSAEPROCLIM", errStr);
  ELSIF err = n.WSAEUSERS THEN
    COPY("WSAEUSERS", errStr);
  ELSIF err = n.WSAEDQUOT THEN
    COPY("WSAEDQUOT", errStr);
  ELSIF err = n.WSAESTALE THEN
    COPY("WSAESTALE", errStr);
  ELSIF err = n.WSAEREMOTE THEN
    COPY("WSAEREMOTE", errStr);
  ELSIF err = n.WSASYSNOTREADY THEN
    COPY("WSASYSNOTREADY", errStr);
  ELSIF err = n.WSAVERNOTSUPPORTED THEN
    COPY("WSAVERNOTSUPPORTED", errStr);
  ELSIF err = n.WSANOTINITIALISED THEN
    COPY("WSANOTINITIALISED", errStr);
  ELSIF err = n.WSAHOST_NOT_FOUND THEN
    COPY("WSAHOST_NOT_FOUND", errStr);
  ELSIF err = n.WSATRY_AGAIN THEN
    COPY("WSATRY_AGAIN", errStr);
  ELSIF err = n.WSANO_RECOVERY THEN
    COPY("WSANO_RECOVERY", errStr);
  ELSIF err = n.WSANO_DATA THEN
    COPY("WSANO_DATA", errStr);
  ELSE
    COPY("UNDEFINED WINSOCK ERROR", errStr);
  END;
END ErrToStr;
(*
PROCEDURE TAsyncSocket.LocalIP;
VAR Name: TSockAddrIn;
     len: integer;
BEGIN
   GetSockName(m_Handle, Name, len);
   Result := int2str(ord(Name.sin_addr.S_un_b.s_b1)) + '.' +
             int2str(ord(Name.sin_addr.S_un_b.s_b2)) + '.' +
             int2str(ord(Name.sin_addr.S_un_b.s_b3)) + '.' +
             int2str(ord(Name.sin_addr.S_un_b.s_b4));
END;

PROCEDURE TAsyncSocket.LocalPort;
VAR Name: TSockAddrIn;
     len: integer;
BEGIN
   GetSockName(m_Handle, Name, len);
   Result  := NToHS(Name.sin_port);
END;
*)

BEGIN
  InstanceCount := 0;
END KolSocket.
