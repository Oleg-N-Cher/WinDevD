MODULE KolObj;
IMPORT SYSTEM, KolTypes;

TYPE
	AnsiString = KolTypes.AnsiString;
	DWORD = KolTypes.DWORD;
	Integer = KolTypes.Integer;

	PObj* = POINTER [1] TO TObj;
(* ---------------------------------------------------------------------
									TObj - base object to derive all others
--------------------------------------------------------------------- *)
(*//[TObj DEFINITION]*)
	 TObj* = (*EXTENSIBLE*) RECORD
	 (* Prototype for all objects of KOL. All its methods are important to
			implement objects in a manner similar to Delphi TObject class. *)
	 (*= ??????? ????? ??? ???? ?????? ???????? KOL. *)
(*
	 protected
		 fRefCount: Integer;
		 fOnDestroy: TOnEvent;
		 {$IFDEF OLD_REFCOUNT}
		 procedure DoDestroy;
		 {$ENDIF}
	 protected
		 fAutoFree: PList;
		 {* Is called from a constructor to initialize created object instance
				filling its fields with 0. Can be overriden in descendant objects
				to add another initialization code there. (Main reason of intending
				is what constructors can not be virtual in poor objects). }
		 {= ?????????? ??? ????????????? ???????. }
		 fTag: DWORD;
		 {* Custom data. }
	 public
		 destructor Destroy; {-} virtual; {+}{++}(* override; *){--}
		 {* Disposes memory, allocated to an object. Does not release huge strings,
				dynamic arrays and so on. Such memory should be freeing in overriden
				destructor. }
		 {= ??????????? ??????, ?????????? ??? ???????. ?? ??????????? ??????, ??????????
				??? ?????, ???????????? ???????? ? ?.?. ????? ?????? ?????? ???? ???????????
				? ???????????????? ??????????? ???????. }
	 {++}(*protected*){--}
		 {++}(*
		 procedure Init; virtual;
		 {* Can be overriden in descendant objects
				to add initialization code there. (Main reason of intending
				is what constructors can not be virtual in poor objects). }
		 *){--}
		 procedure Final;
		 {* It is called in destructor to perform OnDestroy event call and to
				released objects, added to fAutoFree list. }
	 public
		 procedure RefInc;
		 {* See comments below. }
		 {= ��. RefDec ����. }
		 function RefDec: Integer;
		 {* Decrements reference count. If it is becoming <0, and Free
				method was already called, object is (self-) destroyed. Otherwise,
				Free method does not destroy object, but only sets flag
				"Free was called".
		 |<br>
				Use RefInc..RefDec to provide a block of code, where
				object can not be destroyed by call of Free method.
				This makes code more safe from intersecting flows of processing,
				where some code want to destroy object, but others suppose that it
				is yet existing.
		 |<br>
				If You want to release object at the end of block RefInc..RefDec,
				do it immediately BEFORE call of last RefDec (to avoid situation,
				when object is released in result of RefDec, and attempt to
				destroy it follow leads to AV exception).
		 |<br>
				 Actually, this "function" is a procedure and does not return
				 any sensible value. It is declared as a function for internal
				 needs (to avoid creating separate code for Free method)
		 }
		 {= ????????? ??????? ?????????????. ???? ? ?????????? ??????? ??????????
				< 0, ? ????? Free ??? ??? ??????, ?????? (????-) ???????????. ?????,
				????? Free ?? ????????? ??????, ? ?????? ????????????? ???? "Free ???
				??????".
				|<br>
				??????????? RefInc..RefDec ??? ?????????????? ?????????? ??????? ??
				????????? ??????? ???? (???? ???? ????? ?????????????).
				|<br>
				???? ????? ????? (?????????) ?????? ?????? ? ????????? RefDec, ????????
				????? Free ?????????? ????? ????????? RefDec. }
		 property RefCount: Integer read fRefCount;
		 {* }
		 {$IFDEF OLD_FREE}
		 procedure Free;
		 {$ELSE NEW_FREE}
		 property Free: Integer read RefDec;
		 {* Before calling destructor of object, checks if passed pointer is not
				nil - similar what is done in VCL for TObject. It is ALWAYS recommended
				to use Free instead of Destroy - see also comments to RefInc, RefDec. }
		 {= ?? ?????? ???????????, ?????????, ?? ??????? ?? nil ? ???????? ?????????.
				?????? ????????????? ???????????? Free ?????? Destroy - ??. ??? ?? RefInc,
				RefDec. }
		 {$ENDIF NEW_FREE}

		 {-}
		 // By Vyacheslav Gavrik:
		 function InstanceSize: Integer;
		 {* Returns a size of object instance. }
		 {+}

		 constructor Create;
		 {* Constructor. Do not call it. Instead, use New<objectname> function
				call for certain object, e.g., NewLabel( AParent, 'caption' ); }
		 {= ???????????. ?? ??????? ???????? ???. ??? ??????????????? ????????,
				????????? ??????????????? ?????????? ??????? New<???-???????>. ????????,
				NewLabel( MyForm, '??????1' ); }
		 {-}
		 class function AncestorOfObject( Obj: Pointer ): Boolean;
		 {* Is intended to replace 'is' operator, which is not applicable to objects. }
		 {= }
		 function VmtAddr: Pointer;
		 {* Returns addres of virtual methods table of object. }
		 {= ?????????? ????? ??????? ??????????? ??????? (VMT). }
		 {+}
		 property OnDestroy: TOnEvent read fOnDestroy write fOnDestroy;
		 {* This event is provided for any KOL object, so You can provide your own
				OnDestroy event for it. }
		 {= ?????? ??????? ?????????????? ??? ???? ???????? KOL. ????????? ???????
				???-?????? ? ????? ? ??????????? ???????. }
		procedure Add2AutoFree( Obj: PObj );
		{* Adds an object to the list of objects, destroyed automatically
			 when the object is destroyed. Do not add here child controls of
			 the TControl (these are destroyed by another way). Only non-control
			 objects, which are not destroyed automatically, should be added here. }
		procedure Add2AutoFreeEx( Proc: TObjectMethod );
		{* Adds an event handler to the list of events, called in destructor.
			 This method is mainly for internal use, and allows to auto-destroy
			 VCL components, located on KOL form at design time (in MCK project). }
		procedure RemoveFromAutoFree( Obj: PObj );
		{* Removes an object from auto-free list }
		procedure RemoveFromAutoFreeEx( Proc: TObjectMethod );
		{* Removes a procedure from auto-free list }
		property Tag: DWORD read fTag write fTag;
		{* Custom data field. }
	 protected
		 {$IFDEF USE_NAMES}
		 fName: AnsiString;
		 fNamedObjList: Plist;
		 fOwnerObj: PObj;
		 {$ENDIF}
	 public
		 {$IFDEF USE_NAMES}
		 procedure SetName( NewOwnerObj: PObj; NewName: AnsiString);
		 property	Name: Ansistring read FName;

		 property	NamedObjList : PList read fNamedObjList;
		 property	OwnerObj: PObj read FOwnerObj;
		 function	FindObj(const ObjName: Ansistring): PObj;
		 {$ENDIF}
	 end;
(*//[END OF TObj DEFINITION]*)
	*)
		refCount-: Integer;
		tag*: DWORD;
		name-: POINTER TO AnsiString;
		ownerObj: PObj;
	END;

(*[CONSTRUCTOR TObj.Create;]*)
PROCEDURE (VAR obj: TObj) Create* (*NEW*);
BEGIN
	(*Init;*)
	obj.refCount := 0;
	(*{++}(* inherited; *){--}*)
END Create;
(*
//[procedure _TObj.Init]
procedure _TObj.Init;
begin
{$IFDEF _D2orD3}
	FillChar( Pointer( Integer(@Self) + 4 )^, Sizeof( Self ) - 4, 0 );
{$ENDIF}
end;
*)
PROCEDURE (VAR obj: TObj) Destroy* (*NEW*)(*EXTENSIBLE*);
BEGIN
	obj.name := NIL;
	obj.ownerObj := NIL;
END Destroy;

(*//[PROCEDURE TObj.RefDec]*)
PROCEDURE (VAR obj: TObj) RefDec (*NEW*);
BEGIN
	(*Result := 0; // stop Delphi alerting the Warning
	if @ Self = nil then Exit;*)
	DEC(obj.refCount, 2);
	(*{$IFDEF OLD_REFCOUNT}
	if (fRefCount < 0) and LongBool(fRefCount and 1) then
		Destroy;
	{$ELSE}*)
	IF obj.refCount < 0 THEN
		obj.Destroy;
	END;
	(*{$ENDIF}*)
END RefDec;

(*//[PROCEDURE TObj.RefInc]*)
PROCEDURE (VAR obj: TObj) RefInc (*NEW*);
BEGIN
	INC(obj.refCount, 2);
END RefInc;

PROCEDURE (VAR obj: TObj) Free* (*NEW*);
BEGIN
	obj.RefDec;
END Free;

END KolObj.
